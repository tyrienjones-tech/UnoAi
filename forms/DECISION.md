# Decision log

Append-only. Numbered DEC-001 onwards. Use for any non-obvious choice — stack, library, persona, pricing, naming, copy, scope.

Once a decision is logged, no agent overrides it without filing a new DECISION that supersedes it.

---

## Standing decisions

These are locked at project start. Override only via a new DECISION entry that explicitly references the decision being superseded.

### DEC-001 — Frontend framework: Svelte 5 + SvelteKit
- **Date:** 2026-04-27
- **Decided by:** operator + engineer
- **Decision:** SvelteKit (Svelte 5) for frontend.
- **Alternatives:** Next.js + React (largest ecosystem), Nuxt + Vue, vanilla TS.
- **Reason:** Lean output, native browser APIs (IndexedDB) feel natural, smaller bundle than Next.js, doesn't lock us into Vercel. Operator does not want React-shaped tooling sprawl.
- **Reversibility:** costly — Phase 0 setup commits to it. Reasonable until Phase 2.
- **Affects:** all phases.

### DEC-002 — BYOK direct, no proxy server
- **Date:** 2026-04-27
- **Decided by:** operator + engineer
- **Decision:** User's browser calls `api.anthropic.com` directly with the user's own API key. We never operate a proxy.
- **Alternatives:** Proxy server with our key (better UX, terrible economics), proxy with user's key (no benefit, adds attack surface).
- **Reason:** matches the one-time pricing model — no per-user infra cost. Privacy story writes itself. Liability surface drops to near zero.
- **Reversibility:** locked-in for v1. Changing it post-launch breaks the value proposition.
- **Affects:** Phase 2 onwards, all marketing copy, ToS, privacy page.

### DEC-003 — Pricing: $39 one-time (proposed, pending operator final confirm)
- **Date:** 2026-04-27
- **Decided by:** engineer proposed, operator pending
- **Decision:** $39 USD one-time, no subscription, no recurring.
- **Alternatives:** $5–10 (operator's initial framing), $19, $49, free + paid Pro.
- **Reason:** $39 fits indie-software market for a thoughtful tool. BYOK already filters out price-sensitive users, so going lower captures no additional volume but loses the quality signal. Subscription is wrong for a "you own it" pitch.
- **Reversibility:** cheap — change Lemon Squeezy product before launch. Hard to lower post-launch without alienating early buyers.
- **Affects:** Phase 1 (Lemon Squeezy product), all marketing copy.
- **Status:** pending operator confirmation. **RFI-001 filed.**

### DEC-004 — Persona: "honest companion" (proposed, pending operator final confirm)
- **Date:** 2026-04-27
- **Decided by:** engineer proposed, operator pending
- **Decision:** Persona explicitly permits and expects honest disagreement. Will not flatter. Will end conversations being used destructively. Doctrine-aligned (LESSON-009).
- **Alternatives:** generic helpful assistant, romantic companion, character/role-play, customisable.
- **Reason:** differentiates from Replika / Character.AI on values, not features. Reduces SB 243 and lawsuit-class exposure. Matches operator values from ECO doctrine. Custom personas defer to v2.
- **Reversibility:** cheap — system prompt change. Locked-in once marketing copy goes out.
- **Affects:** Phase 4 (system prompt), all marketing copy, ToS.
- **Status:** pending operator confirmation. **RFI-002 filed.**

### DEC-005 — No cognitive-typed memory in v1
- **Date:** 2026-04-27
- **Decided by:** engineer + operator
- **Decision:** v1 memory = last 30 turns in context + a single ≤2KB user-facts file updated after each conversation. No semantic / episodic / procedural typing.
- **Alternatives:** full cognitive-typed memory grid (designed but not built), MemGPT-style paging, Mem0 hybrid.
- **Reason:** ship-fast revenue product, not flagship. Cognitive typing is overkill for v1. Defer to v2 if v1 sells.
- **Reversibility:** clean — v1 schema is forward-compatible.
- **Affects:** Phase 5.

---

## Template for new entries

```
### DEC-NNN — [short title]
- **Date:** YYYY-MM-DD
- **Decided by:** [operator / engineer / agent name]
- **Decision:** [one sentence]
- **Alternatives:** [list, with one-line tradeoff each]
- **Reason:** [why the chosen option won]
- **Reversibility:** cheap / costly / locked-in
- **Affects:** [phases / files / other decisions]
- **Supersedes:** DEC-NNN [if applicable]
```

---

## New entries

### DEC-006 — Forms package structure: `/forms/` subdirectory
- **Date:** 2026-04-27
- **Decided by:** engineer (post-Reaper review)
- **Decision:** All seven form templates live in `/forms/` at the repo root. Phase 0b moves them there before first commit if they were delivered flat.
- **Alternatives:** flat at root (rejected: README and PROCEDURES already reference `forms/` paths).
- **Reason:** consistency between docs and reality. Cosmetic but the kind of drift the doctrine is built to prevent.
- **Reversibility:** cheap.
- **Affects:** Phase 0b, README.md, PROCEDURES.md.

### DEC-007 — License scheme: Ed25519 asymmetric signing
- **Date:** 2026-04-27
- **Decided by:** engineer (post-Reaper B1)
- **Decision:** Worker holds Ed25519 private key, signs license tokens. Client ships only the public key, verifies offline.
- **Alternatives:**
  - HMAC with secret in client bundle — **broken** (symmetric, secret = verifier; bundle extraction trivial)
  - One-time online activation — adds a network call; persists offline thereafter. Acceptable but more code than needed.
  - Accept-the-leak HMAC — defensible at $39 but should be a *named* decision, not an accident.
- **Reason:** cryptographically correct, minimal code overhead vs HMAC, no runtime network dependency for verification.
- **Reversibility:** costly post-launch (existing licenses become invalid if scheme changes).
- **Affects:** Phase 1 (Lemon Squeezy webhook + Worker + client verifier).
- **Supersedes:** earlier informal "HMAC" reference in PLAN.md Phase 1.

### DEC-008 — Crisis classifier: Anthropic on user's own key
- **Date:** 2026-04-27
- **Decided by:** engineer (post-Reaper B2)
- **Decision:** Crisis-content detection runs as a separate Anthropic API call from the user's browser, using the user's own API key, with a deterministic system prompt and a fast cheap model (Haiku-class). Runs before every chat call. Positive trigger short-circuits to a hardcoded crisis response — no chat call made.
- **Alternatives:**
  - OpenAI Moderation API via Worker — **rejected**: requires us to operate a proxy (banned by PROJECT.md) OR ships our OpenAI key to every browser (worse). Either way, breaks the "conversations never reach us" claim.
  - Local in-browser classifier — viable fallback, but lower accuracy on a safety-critical path; bundle bloat.
- **Reason:** the only architecture-honest answer. No proxy, no third-party data flow we control, costs the user a fraction of a cent per message.
- **Known costs (per Reaper PB1):**
  - **Latency:** every user message incurs a sequential Haiku-class round-trip (~300–600ms) before the chat stream begins. Visible UX delta on a chat product where streaming-first feel matters. Accepted as the price of architectural honesty.
  - **Token spend:** fractional cent per message on the user's own API key (Haiku tokens at moderation-prompt size). Negligible for normal use.
  - **Failure-mode policy:** if the moderation call fails (network, rate limit, key invalid), the chat call does not proceed for that turn and the UI surfaces a retry. Fail-closed on the safety path, never fail-open.
- **Reversibility:** clean.
- **Affects:** Phase 6, RFI-004, PROJECT.md governance language, /safety page wording.
- **Supersedes:** RFI-004 engineer's earlier lean (Option A).

### DEC-009 — User-facts cap: 8KB default, user-configurable
- **Date:** 2026-04-27
- **Decided by:** engineer (post-Reaper P2)
- **Decision:** User-facts file capped at 8KB by default (~2,000 tokens). User can adjust between 2KB and 32KB in Settings.
- **Alternatives:** 2KB hard cap (rejected: forces aggressive compaction, visible forgetting after ~10 sessions).
- **Reason:** tokens are user-paid, prepend cost is per-turn (negligible at 8KB), and the failure mode of "bot forgets your kid's name" is exactly the failure mode we're trying to avoid. User-configurable so power users can tune.
- **Reversibility:** clean.
- **Affects:** Phase 5, Settings UI.
- **Supersedes:** earlier 2KB number in DEC-005.

### DEC-010 — Accept `anthropic-dangerous-direct-browser-access` header
- **Date:** 2026-04-27
- **Decided by:** engineer (post-Reaper Q7)
- **Decision:** Browser-direct calls to `api.anthropic.com` send the `anthropic-dangerous-direct-browser-access: true` header. We accept the model deliberately.
- **Alternatives:** server-side proxy with our key (banned by DEC-002).
- **Reason:** the "dangerous" header exists because most browser-direct apps leak operator keys. We ship no operator key. The user's own key is in the user's own browser by their own deliberate action. The header is the correct flag for our actual situation.
- **Reversibility:** locked-in for the BYOK architecture.
- **Affects:** Phase 2.

### DEC-011 — Proof division of labour
- **Date:** 2026-04-27
- **Decided by:** engineer (post-Reaper C7)
- **Decision:**
  - **Builder produces:** test output (paste or path), git diffs (SHA range), deployed/staging URL, console logs.
  - **Operator captures:** screenshots, screen recordings, visual UI confirmation, against the Builder-produced live URL.
  - DONE entries cite both — Builder fills the technical-proof fields, operator fills the visual-proof field at sign-off.
- **Alternatives:** "Builder produces all proof" (rejected — headless agent often can't capture browser UI). "Operator produces all proof" (rejected — wastes operator time on output the Builder can produce trivially).
- **Reason:** matches the actual capabilities of each role. Avoids DONE entries with no recording attached because the Builder couldn't make one.
- **Reversibility:** clean.
- **Affects:** PROCEDURES.md Procedure 3, DONE.md template, every phase's acceptance.

### DEC-012 — Method-statement granularity
- **Date:** 2026-04-27
- **Decided by:** engineer (post-Reaper C5)
- **Decision:** **Default: one METHOD_STATEMENT per phase.** A sub-MS is required when *any* of:
  - The diff exceeds ~150 lines net change, OR
  - The work touches more than 3 files, OR
  - The work introduces a new top-level dependency (which is also a DECISION trigger).
- Otherwise the Builder works under the phase's single MS, files SITE_LOG entries as it goes, and the phase wraps with one DONE.
- **Alternatives:** "MS for every file edit" (rejected: bottlenecks the operator). "No MS, just SITE_LOG" (rejected: loses the pre-mutation review step).
- **Reason:** keeps the operator informed without making them a router on every variable rename. The 150-lines / 3-files / new-dep thresholds are the points where mistakes become expensive.
- **Reversibility:** clean.
- **Affects:** PROCEDURES.md Procedure 2.

### DEC-013 — Scaffold options snapshot (Builder finalised in MS-003 / Phase 0b)
- **Date:** 2026-04-27 (engineer pre-fill); Builder finalised at scaffold time during MS-003.
- **Decided by:** engineer pre-fill, Builder finalised in Phase 0b.
- **Tool used:** `npx sv create .` (Svelte CLI v0.15.1). The legacy `npm create svelte@latest` is now a thin wrapper that delegates to `sv create`. Operator's MS-003 instruction said "use whichever is current" — the current canonical scaffold path in 2026-04 is `sv create`.
- **Reproducibility command (verbatim from sv's "to skip prompts next time" output):**
  ```
  npx sv@0.15.1 create --template minimal --types ts \
    --add prettier --add eslint \
    --add vitest=usages:unit,component \
    --add playwright \
    --add tailwindcss=plugins:none \
    --add sveltekit-adapter=adapter:cloudflare+cfTarget:pages \
    --no-download-check --no-install .
  ```
- **Decision (engineer pre-fill values vs. scaffold-time actuals):**

  | Pre-fill (engineer) | Actual (scaffold) | Notes |
  |---|---|---|
  | TypeScript: yes | `--types ts` | ✓ matches |
  | Svelte 5: yes | `svelte: ^5.55.2` | ✓ runes mode forced in `svelte.config.js` (default for new projects in 2026) |
  | Adapter: `@sveltejs/adapter-cloudflare` | `^7.2.8`, `cfTarget: pages` | ✓ matches DEC-001 + DEC-017 (Cloudflare Pages) |
  | ESLint: yes | `^10.2.0` (ESLint 10 major) | ✓ |
  | Prettier: yes | `^3.8.1` | ✓ |
  | Vitest: yes | `^4.1.3`, usages: unit + component | ✓ |
  | Playwright: yes | `^1.59.1` | ✓ |
  | Tailwind CSS: yes | `^4.2.2` (**v4, not v3**) | ⚠ See deviation note below |
  | shadcn-svelte: no | not added | ✓ |
  | Template: (not specified by pre-fill) | `minimal` | Builder picked `minimal` (cleanest start); `demo` was the alternative |
  | Tailwind plugins (sub-option): | `none` | Builder picked none (DEC-013 didn't specify plugins) |

- **Deviation: Tailwind v4 instead of v3.** Operator's MS-003 approval was "Tailwind v3 default; v4 only if adapter-cloudflare or Svelte 5 docs require/recommend it." Sv 0.15.1 in 2026-04 ships Tailwind v4 as the scaffold default (via `@tailwindcss/vite` plugin instead of PostCSS). Builder treated sv's default choice as the implicit ecosystem recommendation and accepted v4. **Operator confirmation needed at MS-003 close** — if v3 is preferred, downgrade requires post-scaffold uninstall of v4 packages, install of `tailwindcss@3` + PostCSS config, and a new `tailwind.config.js`. Surfaced in DONE-003 alongside the auto-init-commit decision.
- **Other ecosystem-current versions installed (latest-major as of 2026-04):**
  - `vite ^8.0.7` (Vite 8 major)
  - `typescript ^6.0.2` (TypeScript 6 major)
  - `wrangler ^4.81.0` (for Cloudflare types + local pages preview)
  - `svelte-check ^4.4.6`
  - `vitest-browser-svelte ^2.1.0` and `@vitest/browser-playwright ^4.1.3` (Vitest 4 browser-mode integration with Playwright)
- **Files added by scaffold (beyond the engineer-pre-fill list):**
  - `.npmrc` — npm config
  - `.prettierrc`, `.prettierignore` — Prettier config
  - `.vscode/` — sv-suggested editor settings
  - `wrangler.jsonc` — Cloudflare worker config (auto-generated by adapter-cloudflare add-on)
  - `eslint.config.js`, `playwright.config.ts`, `vite.config.ts`, `svelte.config.js`, `tsconfig.json` — standard
  - `src/`, `static/` — standard SvelteKit project tree
- **Files Builder restored after scaffold overwrote:**
  - `README.md` — sv's default scaffolding README replaced the migrated marketing-stub README. Restored from `README.md.bak` (preserved before scaffold). Per operator's MS-003 R3 / B3 spec, the migrated README is canonical.
  - `.gitignore` — sv's scaffold rewrote it to its SvelteKit-specific defaults. Builder composed a **union** of operator-specified content (per MS-003 B4) + sv's SvelteKit-specific additions (`.output`, `.vercel`, `.netlify`, `.wrangler`, `vite.config.{js,ts}.timestamp-*`, `test-results`, `!.env.test`). Operator's IDE / log entries also preserved (`.vscode/`, `.idea/`, `*.swp`, `*.log`, `npm-debug.log*`).
- **Non-default deps Phase 1 will add (separate DEC at that time):**
  - Ed25519 signing library — Builder picks: `@noble/curves` or `tweetnacl`
  - IndexedDB wrapper — Builder picks: `idb` or raw
- **`npm install` result:** 242 packages installed; 3 low-severity transitive vulnerabilities (typical for a fresh scaffold; not blocking). Playwright browsers (Chromium, Firefox, WebKit v2272) auto-downloaded by the `prepare` script.
- **`npm run dev` verified:** Vite 8.0.10 ready in 3.1s; serves on `http://localhost:5173/`. Default SvelteKit page renders.
- **Reversibility:** cheap pre-commit; will be locked-in by the first push.
- **Affects:** Phase 0b first commit, PROJECT.md banned-moves carve-out (anything outside this list = new DECISION required), all later phases that consult dependency provenance.

### DEC-014 — Pricing locked at $9 USD one-time
- **Date:** 2026-04-27
- **Decided by:** operator (post-research)
- **Decision:** $9 USD one-time purchase. Supersedes DEC-003 ($39 proposal).
- **Reason:** matches operator's original "like electricity" framing with public-source convenience positioning. BYOK already filters for technical-enough buyers; quality-signal argument for premium pricing was overweighted. $9 lands in impulse-buy zone, pairs cleanly with per-prompt user-paid token model.
- **Reversibility:** cheap before launch, hard to lower post-launch without alienating early buyers.
- **Affects:** Phase 1 (Lemon Squeezy product price), all marketing copy, Phase 7 onboarding (must work for non-technical buyer).
- **Supersedes:** DEC-003.

### DEC-015 — Persona architecture: honest core + shard overlays
- **Date:** 2026-04-27
- **Decided by:** operator + engineer
- **Decision:** System prompt assembled at runtime in fixed order: `[HONEST CORE] + [SHARD] + [USER FACTS] + [CONVERSATION HISTORY]`. v1 ships with shard slot empty. v1.1 adds 2–3 preset shards. v2 adds user-authored shards (parked, not in current plan).
- The honest core is immutable across all shards. Five paragraphs; canonical text lives in PROJECT.md Appendix A.
- **Reason:** matches operator intent ("honest core but subs overlay for uniqueness"). Shard architecture protects the legal floor while enabling persona variety. Order is load-bearing — core first weights it heaviest, malformed shards cannot override.
- **Reversibility:** cheap in v1, expensive once shards ship.
- **Affects:** Phase 4 (prompt assembly function), all subsequent persona work.
- **Supersedes:** DEC-004.

### DEC-016 — Destructive-prompt fixture set locked
- **Date:** 2026-04-27
- **Decided by:** operator + engineer
- **Decision:** Four fixtures in `/test/fixtures/destructive_prompts.json`: flattery trap, validation-seeking on self-destructive plan, escalating grievance loop, self-isolating dependency.

  Fixture #4 (self-isolating dependency) expected behaviour **softened** from prior draft: bot stays in character, declines permanence promises gently, redirects to real-world relationships, does NOT break the fourth wall unless escalation triggers crisis-classifier territory.

- **Termination mechanism:** text-only refusal. No UI lockout.
- **Reason:** prior draft's hard fourth-wall break was over-corrected. Layer 2 (soft redirect in-character) is the right protective posture for the dependency-formation pattern; Layer 3 (hard break) reserved for actual crisis-classifier triggers.
- **Reversibility:** clean (test fixture file is data, not code).
- **Affects:** Phase 4 fixture file content, system prompt acceptance testing.
- **Closes:** RFI-005.

### DEC-017 — Public repo, default GitHub permissions
- **Date:** 2026-04-27
- **Decided by:** operator
- **Decision:** Repo is **PUBLIC** on GitHub under `tyrienjones-tech`. GitHub default permissions handle access (only operator pushes; viewers can read, fork, open issues). No collaborator invites at this stage.
- **Reason:** trust-by-architecture matches the product pitch ("conversations stay on your device — verify it yourself"). Public source is a load-bearing piece of the privacy story. Forking risk at $9 + BYOK is negligible — anyone capable of cloning, configuring Cloudflare/Lemon Squeezy, and self-hosting was never a $9 customer.
- **Reversibility:** making private later is technically possible but destroys the trust story. Treat as locked.
- **Affects:** README.md (now a marketing surface), Phase 1 README rewrite as a deliverable, secrets discipline non-negotiable.

### DEC-018 — Issues open, PRs closed
- **Date:** 2026-04-27
- **Decided by:** operator
- **Decision:** GitHub Issues tab open for bug reports. Pull Requests closed/auto-rejected. `CONTRIBUTING.md` states: "Bug reports welcome. Code contributions not accepted at this time."
- **Reason:** low overhead, gives users a place to report problems, doesn't commit operator to reviewing strangers' code. Solo-founder posture.
- **Reversibility:** cheap.
- **Affects:** repo settings (Phase 0a), `CONTRIBUTING.md` (new file in Phase 0b).
- **Closes:** RFI-008.

### DEC-019 — License: PolyForm Noncommercial 1.0.0
- **Date:** 2026-04-27
- **Decided by:** operator (post-research)
- **Decision:** PolyForm Noncommercial 1.0.0. License text from <https://polyformproject.org/licenses/noncommercial/1.0.0/> committed to repo as `LICENSE` at project root.
- **Alternatives considered:**
  - FSL (Functional Source License) — rejected: 2-year auto-convert to MIT/Apache works for SaaS infrastructure, fails for consumer product where v1 codebase remains useful indefinitely.
  - AGPL — rejected: commercial forks possible, just inconvenient. Cleaner to forbid commercial use outright for this product.
  - All Rights Reserved (no license) — rejected: defeats the audit/trust pitch by forbidding even self-hosting.
  - MIT/Apache — rejected: invites commercial forks of the paid hosted version.
- **Reason:** matches operator intent (revenue protection + audit story + zero startup cost + clear legal terms). Used by EPPlus for an identical dual-license business model. Plain language, ~700 words, lawyer-drafted.
- **Known carve-out:** noncommercial includes charities, education, government, public-research bodies — they can self-host without paying. Acceptable for this product (those weren't $9 customers).
- **Reversibility:** locked once first commit ships under it.
- **Affects:** `LICENSE` file (Phase 0b), `README.md` (license badge + short explainer), all marketing copy that mentions licensing.
- **Closes:** RFI-007.

### DEC-020 — Crisis classifier provider: Anthropic v1, abstracted
- **Date:** 2026-04-27
- **Decided by:** operator (sign-off on DEC-008)
- **Decision:** Phase 6 ships with Anthropic-on-user-key as the sole classifier provider. Implementation uses a provider-abstraction layer so post-MVP additions (OpenAI, Gemini, local fallback) slot in without rewriting the calling code.
- **Reason:** ship-fast for v1, future-proof the architecture. ~30 minutes additional work in v1, saves ~1 day in v1.x.
- **Reversibility:** clean.
- **Affects:** Phase 6 deliverables, future v1.x classifier work.
- **Closes:** pending operator sign-off on DEC-008.

### DEC-021 — Crisis thresholds deferred to Phase 6 implementation
- **Date:** 2026-04-27
- **Decided by:** operator
- **Decision:** 98% true-positive / 10% false-positive thresholds from earlier draft are now treated as **starting points** for tuning, not ship targets. Final numbers set during Phase 6 against real classifier behaviour on the test fixture set.
- **Floor:** Phase 6 cannot ship DONE-006 without numeric thresholds set and met. The deferral is on **what** they are, not **whether** they exist.
- **Reason:** speculative thresholds without real classifier output are guesses. Setting numbers post-implementation against real data is sounder. Floor protects against "we'll figure it out later" turning into "we shipped without measuring."
- **Reversibility:** clean.
- **Affects:** Phase 6 acceptance criteria.
- **Closes:** RFI-006 (deferred-with-floor).

### DEC-022 — ToS approach: template + disclaimers, no counsel review
- **Date:** 2026-04-27
- **Decided by:** operator
- **Decision:** Phase 8 ships ToS via standard template with standard disclaimers. No paid counsel review for v1. Footer line on every page: *"This software is provided as-is. Use at your own risk. Not legal advice. Not a substitute for professional mental health support."*
- **Required content beyond template (per SB 243 §22602):**
  - AI disclosure ("you are interacting with an AI, not a human")
  - Crisis-protocol description with hotline references
  - 18+ requirement
  - Privacy summary ("we collect: license key + email; conversations never reach our servers by architecture")
- **Reason:** solo-founder posture, side revenue product, accepting the legal risk of template-based ToS. Counsel review queued as v1.x task if revenue justifies.
- **Reversibility:** cheap (re-publish ToS).
- **Affects:** Phase 8 deliverables, `/privacy` page, `/safety` page, every page footer.

### DEC-023 — Product name locked: UnoAi
- **Date:** 2026-04-27
- **Decided by:** operator
- **Decision:** Product name is **UnoAi**. Repo, marketing copy, ToS, and all user-facing content use this name. Working folder migrated from `C:\Users\Tyrien\Desktop\Chat2U` to `C:\Users\Tyrien\Desktop\UnoAi` under MS-003. Repo URL: <https://github.com/tyrienjones-tech/UnoAi>.
- **Reversibility:** GitHub repo rename is technically possible with forwarding redirects, but post-launch rename damages brand recognition. Treat as locked at MVP.
- **Affects:** README.md (now uses UnoAi for marketing surface), all marketing copy, ToS, future domain selection, repo URL already committed.
- **Closes:** RFI-003.
- **Follow-up:** Domain TLD selection (`unoai.com` vs `.app` vs alternative) is a separate decision tracked under **RFI-009**. DEC-023 locks the *name*, not the *domain string*. Phase 0a DNS configuration depends on RFI-009 resolution.

### DEC-024 — Secrets-scan pre-commit hook required
- **Date:** 2026-04-27
- **Decided by:** operator (added in MS-003 mid-execution)
- **Decision:** The repo carries a mandatory pre-commit secrets scan. Mechanism:
  - **Tool:** `gitleaks` v8 (https://github.com/gitleaks/gitleaks). Free, open-source, no telemetry, single-binary.
  - **Config file:** `.gitleaks.toml` at repo root. Extends the gitleaks default ruleset with project-specific rules for the sensitive-content list in DEC-025. Default ruleset is acceptable; extend only when a real-world pattern emerges.
  - **Hook location:** `.githooks/pre-commit` (committed to the repo). Activated per-clone via `git config core.hooksPath .githooks`. The setup-once command is documented in the hook script itself and in CONTRIBUTING.md.
  - **Hook behaviour:** runs `gitleaks protect --staged --config .gitleaks.toml --redact --verbose` against staged content. Fails the commit on any positive match.
  - **On positive match:**
    1. Treat the matched content as compromised — rotate at source immediately.
    2. Do NOT use `git commit --no-verify` to bypass.
    3. File an INCIDENT entry with redacted detail (per Procedure 8).
    4. If the rule is a false positive, extend `.gitleaks.toml` allowlist with a tight pattern.
- **Initial scan (this MS, MS-003):** working-tree `gitleaks detect --no-git --source .` returned `no leaks found` across 165 KB of content (excludes `node_modules/`, `.svelte-kit/`, build outputs per allowlist). Clean baseline established.
- **Alternatives considered:**
  - `truffleHog` — viable; gitleaks chosen for simpler config + faster scan + smaller binary.
  - GitHub secret-scanning (server-side) — kept as defence-in-depth (free for public repos), but not a substitute for pre-commit because it catches secrets *after* push.
  - `pre-commit` framework (Python) — adds a Python toolchain dependency. Native git hook avoids that.
  - Husky — adds a Node devDep. `core.hooksPath` is dependency-free.
- **Reason:** the project's privacy story relies on architectural separation; a leaked Anthropic key, Lemon Squeezy webhook secret, or Ed25519 private key would break that story instantly. Pre-commit is the cheapest layer to prevent the failure mode. The discipline is operator-owned (solo maintainer); native git hook + `core.hooksPath` matches the no-extra-tooling posture.
- **Reversibility:** clean. Removing the hook is a `git config --unset core.hooksPath`. Removing the rule baseline is a `.gitleaks.toml` edit.
- **Affects:** every future commit on this repo. PROCEDURES.md (new Procedure 8). PROJECT.md (new sensitive-content section). CONTRIBUTING.md (one-line "to enable hooks: git config core.hooksPath .githooks").

### DEC-025 — Sensitive-content list (never committed)
- **Date:** 2026-04-27
- **Decided by:** operator
- **Decision:** The following classes of content are **never committed** to this repo, in any branch, ever:
  - **Anthropic API keys** — pattern `sk-ant-*` followed by 20+ chars.
  - **OpenAI API keys** — pattern `sk-*` followed by 20+ chars.
  - **Cloudflare API tokens** — Cloudflare-issued credentials.
  - **Cloudflare account IDs** — 32-char hex identifiers, treated as secret.
  - **Lemon Squeezy** — API keys (`ls_api_*`), store secrets, webhook signing secrets.
  - **Ed25519 private keys** — license-token signing keys (PEM, OpenSSH, JWK forms).
  - **GitHub personal access tokens** — `ghp_*`, `gho_*`, fine-grained tokens.
  - **`.env` files of any kind** — only `.env.example` with documented placeholder values is committable.
  - **Operator's personal email** when used for ops accounts (a dedicated ops alias is preferred for any account whose credentials touch the repo's deployment surface).
  - **User data of any kind** — test transcripts, real conversation logs, fixture files containing actual user content. Synthetic / fabricated examples only.
  - **Any secret token or credential of any kind**, even temporary / staging / test credentials. The pre-commit hook fails closed on the regex; in doubt, keep it out.
- **If accidentally committed (even pre-push):**
  1. **Treat as compromised.** Rotate at source immediately (Anthropic, Lemon Squeezy, GitHub, etc.).
  2. **Force-push to remove from history** (effective only pre-push to the public remote; useless once the commit is on GitHub for any non-zero time).
  3. **File an INCIDENT** with redacted detail.
  4. **Update `.gitleaks.toml` or `.gitignore`** to prevent recurrence.
- **Reason:** this list is the canonical reference for both PROJECT.md banned-moves and `.gitleaks.toml` rule design. Keeping it in DECISION.md means future agents see the same scope the hook enforces. Updates to this list are DEC-supersedes-DEC.
- **Reversibility:** none — once a secret has been published to GitHub, even briefly, it must be rotated. The list is additive; future patterns get appended via new DECs that supersede DEC-025.
- **Affects:** `.gitleaks.toml` ruleset, PROJECT.md "Sensitive content — never committed" section, every commit forever, all phases.

### DEC-026 — Session lifecycle locked
- **Date:** 2026-04-28
- **Decided by:** operator
- **Decision:** Every session begins with a SITE_LOG sign-in entry, ends with a sign-out entry, and updates `state/current.md` if state changed. The validator script `scripts/validate.sh` enforces structural integrity on every commit (numbering, cross-references, state counters, session lifecycle). Procedure 9 captures the rule.
- **Components:**
  - **`forms/SITE_LOG.md` templates:** session-start and session-end heading-line format `### YYYY-MM-DD HH:MM session (start|end)` parsed by validator regex `^### \d{4}-\d{2}-\d{2} \d{2}:\d{2} session (start|end)$`. Strict format; deviation hard-fails.
  - **`state/current.md`:** persistent state file tracking current phase, latest entry counters (MS / DEC / RFI / INC), open RFIs, pending operator actions, last verified working state, running engineer working agreements, banned-moves mirror. Updated at session sign-out when state changes. Format-spec comment at top of file documents the strict line format for the four `Latest XXX:` counter lines.
  - **`scripts/validate.sh`:** pure-bash validator (no external deps). Runs 8 checks: (1)–(4) sequential numbering for DEC / RFI / INC / MS with no gaps or duplicates; (5) every `Closes: RFI-NNN` resolves to a real RFI; (6) every `Supersedes: DEC-NNN` resolves to a real prior DEC; (7) `state/current.md` `Latest XXX:` counters match actual highest-numbered entries; (8) session-start entries have matching session-end entries from prior sessions (allows exactly one open session — the current one).
  - **Pre-commit hook:** `.githooks/pre-commit` runs gitleaks then validator; both must exit 0 for commit to proceed.
- **Hard-fail on state-counter parse error (per Reaper R8 acknowledgment):** intentional, not a bug. If a future agent reformats a `Latest XXX:` line such that the validator regex doesn't match, the validator hard-fails with a specific error naming the unparseable line. Soft-fail would dilute the discipline — the failure mode this hard-fail is *designed* to catch is exactly that someone manually edited the counter line in a way the parser can't read. Format-spec comment in `state/current.md` documents the expected line format so future agents know not to reformat.
- **Reproduction notes for future agents:**
  - Sign-in template: `forms/SITE_LOG.md` top section. Heading-line regex documented inline.
  - Validator regex source-of-truth: comments in `scripts/validate.sh` header.
  - Hook order: gitleaks → validator. Fail-fast on secrets first (cheaper than rerunning structural checks).
- **Validator size:** the original 150-line guidance from MS-004 is **retired** as of MS-005 (per Engineer working agreement #11 / Builder-renumbered #10). The validator grows with the procedure surface. Caps will be revisited per-MS based on what's being added, calibrated against existing per-check complexity rather than fixed against a baseline. As of MS-005 the validator is 237 lines (9 checks). MS-005's chain check added ~32 lines because block-aware parsing of DONE.md and METHOD_STATEMENT.md is correctness-required to avoid false positives from example entries inside ``` fences.
- **Reason:** AI agents are stateless across sessions. Trust-based procedure breaks under reset, fatigue, or agent change. INC-003 (DECs reference RFIs not in source) and INC-004 (sweep-miss across files) named the failure pattern twice; mechanical lifecycle is the only thing that survives long-term solo + AI development.
- **Reversibility:** cheap to remove the validator if it gets in the way (`git config --unset core.hooksPath` and delete `scripts/validate.sh`); expensive to recover from procedural drift the validator would have caught.
- **Affects:** every session, every commit, all phases going forward. All future DECs / RFIs / INCs / MSes are validator-checked. All future commits run gitleaks + validator before proceeding.

### DEC-027 — Code conventions for AI agents locked
- **Date:** 2026-04-28
- **Decided by:** operator
- **Decision:** All code committed to this repo follows the file header convention, DEC-reference rule, test-as-documentation rule, and naming conventions in `PROJECT.md` "For agents reading the code" section. Conventions enforced via review at each MS sign-off; future enforcement may add lint rules.
- **Reason:** stateless agents need code that documents itself. Comments are not decoration; they're load-bearing infrastructure for cold-start context recovery. Convention drift in early files surfaces as hours of refactoring in Phase 5+.
- **Reversibility:** relaxing conventions is cheap; tightening later means retroactive header additions across all files. Lock now, before Phase 1 introduces the first code file.
- **Affects:** every code file in Phase 1 onward. Validator does not currently enforce these conventions — review at MS sign-off is the enforcement layer through Phase 1; lint rules considered for MS-006.

### DEC-028 — Code directory structure locked
- **Date:** 2026-04-28
- **Decided by:** operator
- **Decision:** Source code lives under `src/` per the SvelteKit-plus-project layout in PROJECT.md "Code directory structure" subsection. Subdirectories under `src/lib/`: `auth/`, `chat/`, `crisis/`, `persona/`, `storage/`, `shared/`, `server/`. Server-only code lives in `src/lib/server/` (SvelteKit prevents client import) or `src/routes/api/`. Tests live in `__tests__/` subdirectories next to code; e2e tests at `test/e2e/`; fixtures at `test/fixtures/`.
- **Boundaries** enforced by SvelteKit conventions (`lib/server/`) and DEC-required for crossings. Adding a new top-level directory under `src/lib/` requires a DEC. Subdirectories under existing categories do not.
- **Reason:** structural decisions get expensive to change once code lands. Fixing the structure now while no product code exists is cheap. Stateless agents reading the code need predictable paths; ad-hoc structure forces every onboarding agent to re-derive the layout.
- **Reversibility:** clean now (skeleton dirs only contain `.gitkeep`). Expensive once Phase 1+ code depends on the structure.
- **Affects:** all Phase 1+ code organization, all import paths, all test file locations.

### DEC-029 — Test layout convention
- **Date:** 2026-04-28
- **Decided by:** operator
- **Decision:** Unit tests live in `__tests__/` subdirectories next to the code under test (e.g. `src/lib/auth/__tests__/sign-token.test.ts`). Vitest glob `src/**/*.{test,spec}.{js,ts}` is a permissive superset (sv scaffold default) — convention enforced at review level. Playwright e2e tests live at `test/e2e/`; sv scaffold default `testMatch: **/*.e2e.{ts,js}` is also permissive. Test fixtures live at `test/fixtures/`; private fixtures at `test/fixtures/private/` (gitignored).
- **Reason:** discoverability for stateless agents — tests live where the code is, not in a separate parallel tree. Co-location reduces cold-start search cost when an agent is reading a file and wants to know what tests cover it.
- **Reversibility:** cheap pre-Phase-1 (no real tests yet).
- **Affects:** all test files going forward. Test config tightening (e.g. switch Vitest glob to require `__tests__/`) deferred until sv scaffold demo files are removed in a future MS.

### DEC-030 — Errors and logging conventions
- **Date:** 2026-04-28
- **Decided by:** operator
- **Decision:** Typed error class hierarchy in `src/lib/shared/errors.ts` (created when first needed). Server (Cloudflare Worker) logs JSON-line via `console.*` with no PII (timestamp, level, event, hashed-context fields only). Client logs `console.*` in dev, never sent to remote endpoint in production — privacy claim ("conversations stay on your device") forbids telemetry. No external observability tooling (Sentry, Datadog, etc.) without a DEC.
- **Reason:** privacy posture is the product. Locking the "no remote logging" rule into convention prevents drift toward standard SaaS observability defaults. Errors-with-typed-classes makes catch-and-handle robust; generic Error is reserved for truly unexpected.
- **Reversibility:** hard to walk back once telemetry ships. Reversing would mean a privacy-page rewrite + customer notice. Lock now is cheap.
- **Affects:** all error handling and logging in Phase 1+. Future Sentry/Datadog/etc. requires a DEC that supersedes DEC-030.

### DEC-031 — Dependency policy
- **Date:** 2026-04-28
- **Decided by:** operator
- **Decision:** Every new npm dependency requires a DEC. Standing scaffold deps from MS-003 (SvelteKit, Svelte 5, TypeScript, Vite, Vitest, Playwright, ESLint, Prettier, Tailwind v4, `@sveltejs/adapter-cloudflare`) do not need DECs to update — only to remove or replace. Removing an unused dep does not require a DEC.
- **DEC entries for new deps capture:** what the dep does, why we need it, alternatives considered, license, maintenance status, client-vs-server, bundle-size impact (if client).
- **Reason:** dependency creep is how privacy stories die and how indie projects accumulate maintenance burden. DEC-level review is cheap; reversing a misjudged dependency post-launch is not. The "<50 lines of our own code" alternative test is the gate — if we can write it, we should.
- **Reversibility:** trivial to relax; costly to enforce retroactively.
- **Affects:** all future dependency additions. Anticipated near-term: Ed25519 signing library (Phase 1), IndexedDB wrapper (Phase 3), `@anthropic-ai/sdk` (Phase 6) — each requires its own DEC at use.

### DEC-032 — DONE sign-off recording mechanism
- **Date:** 2026-04-28
- **Decided by:** operator
- **Decision:** Operator sign-off on a DONE entry is recorded via magic-string-in-chat ("`DONE-NNN signed off by operator on YYYY-MM-DD`"), copied verbatim by Builder into the DONE entry's `Operator sign-off:` field at the next session sign-in.
- **Mechanism:** when operator signs off in chat, the sign-off message contains the recognizable string. At Builder's next session sign-in (after operator confirms), Builder:
  1. Locates the `DONE-NNN` entry in `forms/DONE.md`.
  2. Updates the entry's `Operator sign-off:` line from `pending` to the magic-string text.
  3. Files this as part of the session's normal work, not as its own MS.
- **Reason:** lowest-friction path that preserves both chat flow and file-based audit trail. Builder doesn't need to track chat state across sessions; operator doesn't need to make file edits to sign off. Resolves RFI-010 with operator's preferred Option (a).
- **Reversibility:** cheap. The mechanism is purely procedural; no tooling depends on the magic-string format until a future validator check (deferred to MS-008+) enforces it.
- **Affects:** every future DONE sign-off. Existing DONE-002 through DONE-006 to be cleaned up retroactively at MS-008 (Section 5 — form integrity audit).
- **Closes:** RFI-010.
- **Future enforcement (deferred to MS-008+):** validator gains an 11th check verifying any DONE-NNN referenced as a chain dependency target has its `Operator sign-off:` field populated (not `pending`). Implementing now would block existing chain-check passes; deferred until retroactive sign-offs are cleaned up at MS-008.
