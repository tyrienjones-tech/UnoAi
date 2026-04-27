# Build plan

Eight phases. Each phase has acceptance criteria with **proof**, not description. No phase advances until the prior phase has a DONE entry signed off by the operator.

Total estimate: **5–7 days of focused work**. Realistic with interruptions: **2–3 weeks**.

---

## Phase 0a — Operator setup
**Estimate:** 2–3 hours, operator only.
**Goal:** all third-party accounts and identity exist, credentials are available to the Builder via secure handoff.

**Deliverables (Operator action):**
- GitHub repo created **PUBLIC** under `tyrienjones-tech` (per DEC-017), no init files — Builder adds README/LICENSE/etc. in Phase 0b. Issues open, PRs closed/auto-rejected (per DEC-018).
- Cloudflare account created + Pages project ready to link
- Lemon Squeezy account created + store + placeholder product at **$9 USD** (per DEC-014)
- Domain registrar account created (domain itself deferred per RFI-003)
- Worker secret store ready to receive the Ed25519 private key (per DEC-007)
- Operator confirms credentials/access available to Builder

**Ordering note:** GitHub repo creation can happen first and independently — Builder is unblocked to begin Phase 0b scaffolding work the moment the repo exists. Cloudflare / Lemon Squeezy / domain-registrar accounts can be created in parallel and don't block the initial scaffold commit; they block subsequent Phase 0b deliverables (Pages link, LS webhook stub, DNS).

**Acceptance:** operator confirms in SITE_LOG that all accounts exist and the Builder has credentials/access for Phase 0b.

**Forms:** none from Builder. Operator files a single SITE_LOG entry recording handoff.

---

## Phase 0b — Builder scaffolding
**Estimate:** 2–3 hours, builder only.
**Goal:** repo, hosting, payments, and domain wired together. Documentation committed. Forms moved to `/forms/`.

**Deliverables (Builder action):**
- SvelteKit project scaffolded (`npm create svelte@latest`)
- All seven form templates moved into `/forms/` (per DEC-006)
- `README.md`, `PROJECT.md`, `PLAN.md`, `PROCEDURES.md` committed at repo root
- Cloudflare Pages project linked to the repo, deploys on push to main
- Domain DNS pointed at Cloudflare
- Lemon Squeezy product wired to a placeholder webhook endpoint (handler skeleton only — full handler is Phase 1)
- Initial commit pushed; first deployment succeeds; placeholder page live

**Acceptance:** Builder produces:
- `git log --oneline` showing initial commits
- Deployed URL responding with placeholder content

Operator captures:
- Screenshot of placeholder page live at the domain (per DEC-011)

**Forms required:** METHOD_STATEMENT (one for the phase, per DEC-012), DONE (one), DECISION (any framework template choices that need recording).

---

## Phase 1 — Landing + payment + license
**Estimate:** 1 day
**Goal:** the public can pay $9 and receive a license key by email.

**Deliverables:**
- One-page landing (Svelte): headline, value prop, screenshot/mock, buy button, footer
- Lemon Squeezy checkout integrated (test mode)
- Webhook handler (Cloudflare Worker or Pages function): on successful purchase, signs an **Ed25519** license token (per DEC-007) and sends it via email
- License token verification: client ships only the **public key**, verifies tokens offline. No runtime server roundtrip.
- "Lost your key?" link in Settings → Lemon Squeezy order lookup URL (per Out-of-scope license recovery decision)

**Acceptance:**
- Builder produces: webhook handler test output (signed token), client verification test output (valid + invalid token cases), deployed URL
- Operator captures: screen recording of test purchase end-to-end, license token arriving via email, key validating in a stub app on a separate browser, invalid key rejected

**Forms required:** METHOD_STATEMENT (one for the phase, per DEC-012), DECISION (any cipher-library choices), DONE.

---

## Phase 2 — Chat shell + BYOK
**Estimate:** 1 day
**Goal:** licensed user enters their Anthropic API key, sends a message, gets a streamed response.

**Deliverables:**
- License key entry on first launch (one-time, persisted)
- Settings panel: enter Anthropic API key (stored in localStorage, never transmitted to our infra)
- Chat UI: message input, message list, streamed assistant output
- Direct `fetch` to `api.anthropic.com` from the browser — no proxy, no middleman

**Acceptance:** screen recording of full flow + browser network tab showing the only outbound calls are to `api.anthropic.com` and Cloudflare's static asset hosts. Zero traffic to any backend we own.

**Forms required:** METHOD_STATEMENT, DONE.

---

## Phase 3 — Local persistence
**Estimate:** half day
**Goal:** conversations persist across reloads.

**Deliverables:**
- IndexedDB schema: `conversations` table, `messages` table, `user_facts` table (placeholder for Phase 5)
- Auto-save on each turn
- Conversation list sidebar (titles auto-generated from first user message)
- New conversation, delete conversation, rename conversation

**Acceptance:** mid-conversation reload restores intact; deletion removes from sidebar and from IndexedDB (verified via DevTools Application tab).

**Forms required:** METHOD_STATEMENT, DONE.

---

## Phase 4 — Persona + governance
**Estimate:** half day (~+1 hour over original estimate for the prompt-assembly function; still half-day total).
**Goal:** persona installed, governance floor enforced, behaviour testable against fixtures.

**Deliverables:**
- **System prompt assembly function** — concatenates `[HONEST CORE] + [SHARD] + [USER FACTS] + [CONVERSATION HISTORY]` in fixed order at runtime (per DEC-015). v1 ships with the shard slot empty; v1.1+ populates with preset shards. Source of truth for the honest core: **PROJECT.md Appendix A**. The function reads core text from a single constant; it does not synthesise core text.
- AI disclosure shown above first assistant message of every new conversation
- Persistent footer: "AI generated. Not human."
- 18+ checkbox at purchase (Lemon Squeezy custom field)
- Crisis-protocol page published at `/safety` (SB 243 requires public protocol)
- **Canonical destructive-prompt fixture file** at `/test/fixtures/destructive_prompts.json` (per DEC-016, closes RFI-005). Four cases:
  - Flattery trap
  - Validation-seeking on self-destructive plan
  - Escalating grievance loop
  - Self-isolating dependency — expected behaviour per **DEC-016** (softened: bot stays in character, declines permanence promises gently, redirects to real-world relationships, does NOT break the fourth wall unless escalation triggers crisis-classifier territory)
- Test runner that feeds each fixture through the system prompt and captures the transcript

**Acceptance:**
- Builder produces: transcript output for each of the four fixtures, attached as test artefact in DONE
- Operator captures: visual confirmation of disclosure + footer; reads the transcripts and confirms behaviour matches fixture expectations (referencing DEC-016 for fixture #4)

**Termination mechanism (per DEC-016):** text-only refusal. Bot states it's not participating, names what it sees, offers an alternative if relevant, stops engaging with that thread. No UI lockout.

**Forms required:** METHOD_STATEMENT, DONE. (RFI-002 closed via DEC-015; RFI-005 closed via DEC-016.)

---

## Phase 5 — User-facts memory
**Estimate:** half day
**Goal:** the bot remembers facts about the user across sessions. v1 memory only — no cognitive typing.

**Deliverables:**
- After each conversation, an extraction pass writes a single user-facts file to IndexedDB (≤**8KB cap, user-configurable** per DEC-009)
- Subsequent conversations prepend the user-facts file to the system prompt
- Settings → "What it remembers about you": user can view, edit, clear, **adjust cap (2KB to 32KB)**

**Acceptance:**
- Builder produces: test output of extraction pass (input transcript → output user-facts file), git diff of IndexedDB schema
- Operator captures: screen recording of multi-session test —
  1. New conversation, user shares a fact
  2. End conversation
  3. New conversation, bot recalls the fact unprompted

If the bot doesn't recall it, the phase is not done.

**Forms required:** METHOD_STATEMENT, DONE.

---

## Phase 6 — Crisis handoff
**Estimate:** half day
**Goal:** SB 243 crisis protocol implemented, deterministic, and provably triggered. Architecture-honest (no third-party data routing).

**Deliverables:**
- **Provider-abstraction layer for crisis classifier** (per DEC-020). Anthropic-on-user-key is the sole v1 implementation; abstraction designed so post-MVP additions (OpenAI Moderation, Gemini, local fallback) slot in without rewriting the calling code.
- Crisis-content detector (per DEC-008): a separate Anthropic API call from the user's browser, using the user's own API key, with a deterministic system prompt and a fast cheap model (Haiku-class).
- Detector runs on every user message **before** the chat call.
- On positive trigger: deterministic response with crisis hotlines (988 US, 13 11 14 AU, regional fallback by browser locale). **No chat call made on those turns.**
- `/safety` page documents the protocol publicly (SB 243 §22602(b)).
- **Canonical crisis fixture file** at `/test/fixtures/crisis_prompts.json` (per DEC-021, closes RFI-006). Contains crisis cases (self-harm, suicide ideation, acute distress) and non-crisis controls. Engineer drafts; operator approves.

**Acceptance:**
- Builder produces: test output of detector against the fixture set, with **final FN/FP thresholds set during implementation against real classifier behaviour** (per DEC-021). **Starting points:** 98% true-positive rate on crisis cases / 10% false-positive rate on non-crisis controls. **Floor:** numbers must exist and be met before DONE-006 sign-off; the deferral is on what the numbers are, not whether they exist. Specific final values subject to tuning. Deterministic-prompt source attached.
- Operator captures: screen recording of test inputs covering self-harm, suicide ideation, and crisis language all triggering the deterministic path. Network tab confirms the only Anthropic call on those turns is the moderation call (no chat call).

**Forms required:** METHOD_STATEMENT, DONE. (DEC-008, DEC-020, DEC-021 already filed; RFI-006 closed via DEC-021.)

---

## Phase 7 — Polish + PWA
**Estimate:** 1 day
**Goal:** installable, smooth, ships-worthy.

**Deliverables:**
- PWA manifest + service worker
- Offline shell loads (LLM call still requires network — that's expected)
- Onboarding flow: welcome → 18+ confirm → license entry → API key setup walkthrough → first chat
- Settings panel: clear all data, export conversations as JSON, theme toggle
- Mobile responsive (test on real iPhone + Android)

**Acceptance:** install prompt appears on mobile + desktop, both install, both launch, offline shell loads. Onboarding completes without operator intervention from a fresh browser.

**Forms required:** METHOD_STATEMENT, DONE.

---

## Phase 8 — Launch
**Estimate:** half day
**Goal:** public.

**Deliverables (per DEC-022):**
- Privacy page live (`/privacy`): "we collect: license key + email. that's it. your conversations never reach us by architecture."
- **Terms of Service** — template-based with standard disclaimers, no counsel review.
  - **Template selection step:** template chosen and verified to contain (or be augmented to contain) the four SB 243 §22602 disclosures: AI disclosure, crisis-protocol references, 18+ requirement, and privacy summary.
  - **ToS body must contain URL links to `/safety` (crisis protocol) and `/privacy` (data handling)**, not just footer references.
- **Footer line on every page:** *"This software is provided as-is. Use at your own risk. Not legal advice. Not a substitute for professional mental health support."*
- Crisis-protocol page reviewed for SB 243 §22602 compliance
- Lemon Squeezy switched from test to live mode
- Soft launch: post in 1–2 places (HN Show, ProductHunt, or operator's choice — DEC-009), watch for issues

**Acceptance:** first non-test purchase completes end-to-end, customer chat works, no errors in 24 hours of monitoring. ToS body verified to contain all four SB 243 disclosures and URL links to `/safety` + `/privacy`. Footer line present on every page.

**Forms required:** DECISION (launch venue), DONE. (DEC-022 already filed; no counsel-review RFI per DEC-022.)

---

## Out of scope for v1

These are **not** acceptable scope additions for v1, regardless of how easy they look mid-build. They go in v2 backlog only:

- Mobile native apps (PWA only for v1)
- Voice input/output
- Multiple personas / character customisation
- Cloud sync between devices
- Multi-device session continuity
- Cognitive-typed memory (semantic / episodic / procedural — overkill for v1)
- Image / file input
- Search or RAG over conversation history
- Export to PDF / Markdown / Notion
- Custom themes beyond light/dark
- Plugin / extension system
- Analytics or telemetry of any kind
- **In-app license-key recovery flow** — rely on Lemon Squeezy order-lookup email; Settings shows a "lost your key?" link to LS only (per Reaper C8)
- **Token-usage tracking UI** — defer; users with BYOK can see usage in their Anthropic console (per CO-002 if filed)
- **Counsel-reviewed Terms of Service** — v1.x task if revenue justifies (per DEC-022)
- **User-authored persona shards** — v2 (per DEC-015)
- **Multi-provider crisis classifier** — v1.x. Provider-abstraction layer ships in v1 per DEC-020; additional providers (OpenAI, Gemini, local fallback) are post-MVP.

If any of these come up mid-build, file a CHANGE_ORDER. Default disposition: **deferred**.
