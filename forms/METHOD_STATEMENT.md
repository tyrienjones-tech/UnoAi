# Method statement

Filed **before** mutating any files. Operator approves before work proceeds. Numbered MS-001 onwards.

---

## Template

```
### MS-NNN — [short title, ≤8 words]
- **Date:** YYYY-MM-DD
- **Agent:** [name]
- **Phase:** [number + name]
- **Task:** [task name from PLAN.md]
- **Linked RFIs / decisions:** [if any]

**Plan (numbered, terse):**
1. ...
2. ...
3. ...

**Files to be touched:**
- `path/to/file` — [reason: created / modified / deleted]
- `path/to/file` — [reason]

**Expected diff size:**
~N lines added / N lines removed / N lines modified across N files

**Risks identified:**
- [risk] — [mitigation]
- [risk] — [mitigation]

**Acceptance criteria (will be copied verbatim into DONE):**
[Specific, testable. How the operator will confirm this is done. Be concrete — "user sees X when Y happens" beats "feature works".]

**Operator approval:** [pending / approved YYYY-MM-DD / changes requested]
**Approval notes (operator fills):**
[Optional. Conditions, edits, alternative approaches.]
```

---

## Example

```
### MS-005 — Streaming Anthropic responses
- Date: 2026-04-27
- Agent: Reaper-1
- Phase: 2 — Chat shell + BYOK
- Task: Direct fetch to api.anthropic.com with streaming
- Linked: DEC-002 (BYOK direct, no proxy)

Plan:
1. Add Anthropic API client wrapper in src/lib/anthropic.ts using fetch + ReadableStream
2. Wire chat input → wrapper → message store
3. Stream tokens into the assistant message as they arrive
4. Handle network errors and surface them in the UI

Files to be touched:
- src/lib/anthropic.ts — created
- src/lib/stores/chat.ts — modified (subscribe stream events)
- src/routes/chat/+page.svelte — modified (render streaming state)

Expected diff size: ~120 lines added across 3 files

Risks:
- API key leaks into network logs — mitigation: never log full key, redact in dev tools
- Streaming hangs on large responses — mitigation: timeout + abort controller
- CORS — Anthropic supports browser CORS for direct calls; verify in test

Acceptance criteria:
- Type a message, hit send, see assistant tokens stream into the message bubble
- Browser network tab shows POST to api.anthropic.com only (no proxy)
- Invalid key shows visible error in chat, not a console-only failure
- Screen recording attached to DONE entry

Operator approval: pending
```

---

## Entries

<!-- Append new method statements below this line. -->

### MS-001 — Handover package assembly + cleanup
- **Date:** 2026-04-27
- **Agent:** Reaper-1
- **Phase:** 0 prep (pre-0a)
- **Task:** Assemble the project folder at `C:\Users\Tyrien\Desktop\Chat2U`, populate it from the latest source-of-truth files, and apply the cleanup fixes A–G named in the operator's prompt.
- **Linked RFIs / decisions:** DEC-006 (forms/ structure), DEC-008 (Known costs), DEC-011 (proof split), DEC-013 (placeholder), RFI-005, RFI-006 (newly authored).
- **Operator pre-authorisation:** YES — the operator prompt explicitly authorised this single-MS cleanup pass before the first SITE_LOG entry.

**Plan (numbered, terse):**
1. Locate sources: latest 6 updated files in `C:\Users\Tyrien\Downloads\chat to you\C2U\`; 5 unchanged forms in `C:\Users\Tyrien\Downloads\chat to you\ARCH\files(7)\`.
2. Create `C:\Users\Tyrien\Desktop\Chat2U\` and `C:\Users\Tyrien\Desktop\Chat2U\forms\`.
3. Copy 4 root docs (README, PROJECT, PLAN, PROCEDURES) and 7 forms (SITE_LOG, METHOD_STATEMENT, DONE, DECISION, CHANGE_ORDER, RFI, INCIDENT) into the target layout.
4. Verify each of A–G against the copied files.
5. Apply only the gap fixes; record items already correct.
6. File MS-001 (this entry), INC-001/INC-002, and a SITE_LOG entry.

**Files to be touched:**
- `Chat2U/README.md` — modified (D fix line 32 + Phase 0a/0b status line consistency).
- `Chat2U/PLAN.md` — modified (F fix: Phase 6 fixture file path + 2% FN / 10% FP thresholds).
- `Chat2U/forms/DONE.md` — modified (C fix: split Proof section into Builder-produced / Operator-captured per DEC-011, in both template and example).
- `Chat2U/forms/DECISION.md` — modified (B fix: append "Known costs" subsection to DEC-008; append DEC-013 as pre-named placeholder).
- `Chat2U/forms/RFI.md` — modified (A fix: append RFI-006 entry — Phase 6 crisis fixture file + FN/FP thresholds).
- `Chat2U/forms/METHOD_STATEMENT.md` — modified (this MS-001 entry).
- `Chat2U/forms/INCIDENT.md` — modified (INC-001, INC-002 entries).
- `Chat2U/forms/SITE_LOG.md` — modified (session entry).

**Items found already correct (no edit applied):**
- D — README.md line 12 "the seven rules" (Engineer-applied).
- E — PROCEDURES.md Procedures 1–7 numbered + summary table updated (Engineer-applied).
- F — Phase 0a/0b split, Ed25519 in Phase 1, destructive_prompts.json in Phase 4, 8KB cap in Phase 5, Anthropic-on-user-key in Phase 6 (Engineer-applied).
- G — PROJECT.md banned-moves scaffolding-defaults carve-out at line 100 (Engineer-applied).

**Items found absent and authored mechanically (with pushback — see SITE_LOG):**
- DEC-013 stub: title and "TO BE FILLED" body only. No decision content authored. Builder fills body during Phase 0b after operator approves the Phase 0b MS.
- DEC-008 "Known costs" subsection: latency / token-spend / failure-mode-policy values from prior Reaper PB1 review.
- RFI-006: authored to mirror RFI-005 structure, using the 2% FN / 10% FP thresholds and `/test/fixtures/crisis_prompts.json` path stated in the operator prompt. Engineer review and sign-off requested.

**Expected diff size:** ~80 lines net added across 8 files. No code touched. No dependencies introduced.

**Risks identified:**
- Authoring RFI-006 and DEC-013 is normally Engineer-territory. Mitigation: values used are stated in the operator prompt; pushback recorded in SITE_LOG; Engineer review and revise free; Builder note included inline in the RFI-006 entry itself.
- "Chat2U" placeholder name leaking into user-facing content. Mitigation: scrubbed sample staging URL in DONE.md example to `https://staging.<project>.pages.dev/`; placeholder appears nowhere else.
- Cross-references (RFI-006 ↔ Phase 6, DEC-013 ↔ PROJECT.md banned-moves carve-out, "Known costs" ↔ Phase 6 fail-closed acceptance) need to remain coherent. Mitigation: each fix names the cross-references it depends on.

**Acceptance criteria:**
- `Chat2U/` folder structure matches the layout specified in the operator prompt: 4 root docs, `forms/` with 7 templates, no extras.
- Verifications A–G all resolve to PASS or APPLIED-FIX.
- MS-001, INC-001, INC-002, SITE_LOG entry filed.
- Pushback recorded in SITE_LOG for any items authored that would normally be Engineer-territory.
- Readiness statement produced naming all operator/engineer blockers before Phase 0a/0b proper.

**Operator approval:** pre-authorised in the operator prompt for this cleanup pass.
**Approval notes:** scope limited to A–G plus obvious doc-consistency gaps (each off-list consistency fix logged as INCIDENT per the prompt's instruction).

---

### MS-002 — Post-decision batch: 9 DECs + DEC-013 pre-fill, PROJECT/PLAN/README updates, RFI closures, INC-001 cosmetic
- **Date:** 2026-04-27
- **Agent:** Reaper-1
- **Phase:** 0 prep (pre-0a)
- **Task:** Apply the post-decision documentation batch from the operator prompt: 9 new DECs (DEC-014..022), DEC-013 pre-fill, 4 PROJECT.md changes (PM1–PM4 incl. Appendix A), 5 PLAN.md changes (PL1–PL5), 3 README.md changes (R1–R3), 7 RFI status updates, 1 INCIDENT cosmetic fix.
- **Linked RFIs / decisions:**
  - **Closes (per operator):** RFI-001 (via DEC-014), RFI-002 (via DEC-015), RFI-005 (via DEC-016), RFI-006 (via DEC-021), RFI-007 (via DEC-019), RFI-008 (via DEC-018). RFI-004 gains operator sign-off date.
  - **Open / parked:** RFI-003 (domain) — deadline pre-Phase 8.
  - **Supersedes:** DEC-014 supersedes DEC-003; DEC-015 supersedes DEC-004.
- **Operator approval:** pending.

**Plan (numbered, terse):**
1. Append DEC-014..DEC-022 to `forms/DECISION.md` after DEC-013, in order, verbatim from the operator prompt.
2. Replace DEC-013 body — remove "TO BE FILLED" and substitute the engineer-supplied scaffold options list. Update Date/Decided-by lines to reflect engineer pre-fill at 2026-04-27, with Builder finalisation deferred to Phase 0b.
3. PROJECT.md changes:
   - PM1: append the persona-promises bullet to "Banned moves" section.
   - PM2: change "$39 one-time" → "$9 one-time" in Pricing section; remove the "(proposed, pending operator confirm — see DEC-003)" hedge; reference DEC-014.
   - PM3: rewrite Persona section to reference DEC-015 (honest core + shard overlays); note v1 ships with empty shard slot.
   - PM4: append "## Appendix A — System Prompt v1 (immutable honest core)" with the five paragraphs verbatim from the operator prompt.
4. PLAN.md changes:
   - PL1: rewrite Phase 0a — estimate "2–3 hours, operator only"; expand deliverables list per the prompt; add note about repo-first ordering.
   - PL2: Phase 4 — add prompt-assembly-function deliverable referencing DEC-015 fixed order; update fixture #4 expected behaviour reference to DEC-016; reference Appendix A.
   - PL3: Phase 6 — add provider-abstraction-layer deliverable per DEC-020; rewrite acceptance to reflect DEC-021 (98% TP / 10% FP as starting points; numbers must be set and met before DONE-006).
   - PL4: Phase 8 — replace "ToS counsel review (RFI)" with the DEC-022 template + footer-line approach; remove the prior RFI placeholder.
   - PL5: Out-of-scope list — append three items (counsel-reviewed ToS, user-authored shards, multi-provider classifier).
5. README.md changes:
   - R1: add license badge line near the top: "License: PolyForm Noncommercial 1.0.0 — see LICENSE file."
   - R2: add "Self-hosting" section near the bottom per the prompt's wording.
   - R3: restructure: top of README becomes user-facing stub ("[Marketing copy goes here in Phase 1]"); current agent-facing content moves to a section labelled "For agents working on this project" (it already is — verify the heading and ordering).
6. RFI.md status updates: change "Operator decision: pending" to "Operator decision: ANSWERED 2026-04-27 via DEC-NNN" for RFI-001, 002, 004 (sign-off date addition), 005, 006. Author retroactive entries for RFI-007 and RFI-008 as already-answered (see Risk R1 below).
7. INCIDENT.md cosmetic fix: update example INC-001 (line ~61) HMAC reference to Ed25519 wording per the prompt.
8. File SITE_LOG entry covering scope, pushback (DEC-022 reservations), and progress.
9. File DONE-002 with Builder-produced proof (file-by-file change summary; line-count delta before/after).

**Files to be touched:**
- `Chat2U/forms/DECISION.md` — modified (9 new entries + DEC-013 body replacement).
- `Chat2U/forms/RFI.md` — modified (5 status updates + 2 retroactive entries authored = RFI-007, RFI-008).
- `Chat2U/forms/INCIDENT.md` — modified (1 cosmetic example fix).
- `Chat2U/PROJECT.md` — modified (PM1–PM4 incl. new Appendix A).
- `Chat2U/PLAN.md` — modified (PL1–PL5).
- `Chat2U/README.md` — modified (R1–R3 restructure).
- `Chat2U/forms/METHOD_STATEMENT.md` — modified (this MS-002 entry).
- `Chat2U/forms/SITE_LOG.md` — modified (session entry).
- `Chat2U/forms/DONE.md` — modified (DONE-002 entry at end of session).

**Files NOT touched (per prompt):** PROCEDURES.md, CHANGE_ORDER.md.

**Expected diff size:** ~280 lines net added across 9 files. No code touched. No dependencies introduced. No commits.

**Risks identified:**

- **R1. RFI-007 and RFI-008 do not exist in the source.** The closure list expects them to exist; DEC-018 and DEC-019 reference them with "Closes:" lines. If MS-002 is approved as-is, Builder will author the two RFIs as historical-record entries (already-answered, mirroring the RFI-006 mechanical-author pattern from MS-001) with a Builder-note explaining the reconstruction. Their content will be inferred from the corresponding DEC alternatives sections (RFI-007 = license choice options; RFI-008 = issues/PRs governance options). **If the operator/engineer prefers a different resolution** (e.g. remove the "Closes:" lines from DEC-018/019 instead), say so at MS-002 approval time. Otherwise Builder proceeds with the historical-reconstruction approach.
- **R2. DEC-022 (template-based ToS, no counsel review) is a real legal risk-acceptance.** Three reservations to surface in SITE_LOG before applying:
  1. Most public ToS templates do not bundle AI-disclosure / crisis-protocol / 18+ language by default. Operator should confirm the template chosen contains these or that we'll add them ourselves at Phase 8.
  2. The footer line is a good user-facing disclaimer but does not substitute for full SB 243 §22602 disclosure. The `/safety` page (Phase 6) and `/privacy` page (Phase 8) carry the load-bearing compliance text — confirm the ToS references them by URL.
  3. PolyForm NC + public source means self-hosters inherit our liability exposure for their own users without our ToS protecting them. This is fine for the operator (we're not liable for their deployments) but worth stating in the README self-hosting section so self-hosters understand they're on their own legally.
- **R3. README R3 restructure** moves agent-facing content below a new user-facing stub. The four "For agents" steps in current README.md (lines 7–22) and the file map (lines 23–41) need to remain agent-discoverable. Mitigation: keep all current agent content under a clearly-labelled "For agents working on this project" section heading; user-facing stub sits above it at the top. Builder will not delete agent content, only move it.
- **R4. PolyForm NC license-link in README R1** points to a LICENSE file that won't exist until Phase 0b. Brief broken-link window. Acceptable — README is not yet on a live site (Phase 0b deploys the placeholder).
- **R5. PL3 Phase 6 acceptance rewrite** moves from "≤ 2% FN / ≤ 10% FP" (MS-001 wording) to "98% TP / 10% FP starting points, final tuned during implementation" (DEC-021 wording). 2% FN ≡ 98% TP — same number, different framing. Floor preserved ("numbers must exist and be met before DONE-006"). RFI-006's body becomes historical-record-of-prior-thinking; RFI-006 status is updated to ANSWERED via DEC-021.
- **R6. RFI-005 fixture #4 expected-behaviour wording** in the source RFI does not include the "stay in character / no fourth-wall break" softening that DEC-016 introduces. Per scope, RFI-005 stays as historical record of what was answered then; DEC-016 supersedes it for new behaviour. PLAN.md PL2 updates the operative reference. RFI-005 itself is left untouched (closure status updated only).
- **R7. Cross-reference web** post-batch: DEC-014 ↔ PROJECT.md Pricing + Phase 1; DEC-015 ↔ PROJECT.md Persona + PROJECT.md Appendix A + Phase 4; DEC-016 ↔ Phase 4 fixture #4; DEC-017 ↔ Phase 0a (public repo); DEC-018 ↔ Phase 0a + Phase 0b CONTRIBUTING.md (note: CONTRIBUTING.md not in current package — Phase 0b deliverable); DEC-019 ↔ README R1/R2 + LICENSE file (Phase 0b); DEC-020 ↔ Phase 6 abstraction; DEC-021 ↔ Phase 6 acceptance + RFI-006 closure; DEC-022 ↔ Phase 8 ToS + footer. Mitigation: post-apply grep sweep verifying every "DEC-NNN" and "RFI-NNN" reference resolves.

**Acceptance criteria (will be copied verbatim into DONE-002):**
- `forms/DECISION.md` contains DEC-001 through DEC-022 in order, no duplicates, no truncations. DEC-013 body shows the engineer-supplied scaffold options (TS, Svelte 5, adapter-cloudflare, ESLint, Prettier, Vitest, Playwright, Tailwind, no shadcn-svelte) plus the carve-out clause.
- DEC-014 carries `Supersedes: DEC-003`; DEC-015 carries `Supersedes: DEC-004`. Both supersede references resolve.
- `forms/RFI.md` shows RFI-001, 002, 004, 005, 006, 007, 008 with `Operator decision: ANSWERED 2026-04-27 via DEC-NNN` lines. RFI-003 status unchanged (still pending). RFI-007 and RFI-008 are present as historical-record entries with Builder-notes.
- `PROJECT.md` Banned moves contains the new persona-promises bullet (PM1). Pricing reads "$9 one-time" with no "(proposed, pending)" hedge (PM2). Persona section references DEC-015 (PM3). New "Appendix A — System Prompt v1" section at end with the five paragraphs verbatim (PM4).
- `PLAN.md` Phase 0a estimate "2–3 hours" + expanded deliverables (PL1). Phase 4 has prompt-assembly-function deliverable + DEC-016 + Appendix A references (PL2). Phase 6 has provider-abstraction-layer deliverable + DEC-021-shaped acceptance (PL3). Phase 8 ToS subsection rewritten per DEC-022 with footer line (PL4). Out-of-scope list has three new items (PL5).
- `README.md` has license-badge line near top (R1), Self-hosting section near bottom (R2), and structural split between user-facing stub at top and "For agents" section below (R3). Agent content preserved.
- `INCIDENT.md` example INC-001 references Ed25519, not HMAC.
- No edits in PROCEDURES.md, CHANGE_ORDER.md, DONE.md template/example structure, METHOD_STATEMENT.md template/example, SITE_LOG.md template/example.
- Builder-produced proof for DONE-002: file-by-file change summary with line-count delta before/after.
- No uncaught cross-reference breaks (post-apply grep sweep documented in DONE-002).

**Operator approval:** pending.
**Approval notes (operator fills):**
[Confirm: (a) approve scope, (b) confirm Risk R1 resolution — Builder authors RFI-007 and RFI-008 as historical-record entries, OR specify alternate handling; (c) acknowledge DEC-022 reservations from Risk R2 will be filed in SITE_LOG before applying.]

---

### MS-003 — Phase 0b kickoff: name + folder migration + repo scaffold + first commit
- **Date:** 2026-04-27
- **Agent:** Reaper-1
- **Phase:** 0b — Builder scaffolding
- **Task:** Combine Scope A (clone empty UnoAi repo, migrate handover package from Chat2U folder, apply Companion→UnoAi name swap with role-vs-product judgment carve-outs, file DEC-025 + close RFI-003 + log INC-005) and Scope B (LICENSE + CONTRIBUTING + .gitignore + SvelteKit scaffold per DEC-013 + first commit pushed to public GitHub).
- **Linked RFIs / decisions:**
  - **Closes:** RFI-003 via DEC-025 (per operator instruction; product-name-implies-domain framing — see Risk R4 below for follow-up note on specific domain string)
  - **Updates:** DEC-013 from engineer-pre-fill state (post-MS-002) to scaffold-time-actuals (Builder finalisation per DEC-013's own "Builder confirms during Phase 0b" clause)
  - **New:** DEC-025 (product name lock), INC-005 (migration record)
  - **Stack standing decisions consulted:** DEC-001 (SvelteKit), DEC-013 (scaffold options), DEC-017 (public repo), DEC-018 (issues open / PRs closed), DEC-019 (PolyForm NC license)
  - **Deferred:** Cloudflare Pages link (B9; operator account not yet created — separate small MS later)
- **Operator approval:** pending.

**Open questions to resolve at MS-003 approval:**

These are the five items in the Builder's reply preceding this MS — restated here for the file record.

1. **DEC-025 numbering — gap-or-renumber?** Last DEC filed is DEC-022. Scope A4 introduces DEC-025, skipping DEC-023 and DEC-024. Three options:
   - (a) Renumber to **DEC-023** (next sequential, no gap; matches the procedural lesson from INC-003).
   - (b) Confirm DEC-023 and DEC-024 are reserved for specific decisions and what those are.
   - (c) Leave a numbering gap intentionally.
   Builder default: (a). Will renumber DEC-025 → DEC-023 unless operator confirms (b) or (c). All references to "DEC-025" in this MS, in DEC-013 update, and in the closure note for RFI-003 will use the operator-confirmed number.

2. **Commit message — Co-Authored-By Claude footer?** Operator's specified message is "Initial commit: handover package + SvelteKit scaffold". Builder's default Claude Code practice would append `Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>` via HEREDOC. For a public PolyForm-NC repo where the operator is named copyright holder ("Copyright (c) 2026 Tyrien Jones"), Claude attribution on the initial commit may or may not be desired — possible IP-clarity concern. Builder default: operator's message verbatim, no Co-Authored-By suffix. If operator wants attribution, say so and Builder will add it.

3. **DEC-013 update wording.** B6 says "Update DEC-013 from 'TO BE FILLED' placeholder to actual values." DEC-013's current state (post-MS-002) is engineer-pre-fill, not "TO BE FILLED" — that wording matches pre-MS-002 state. The actual update path is engineer-pre-fill → scaffold-time-actuals. Builder will update from current state, noting any deviation between the engineer-pre-fill defaults and what `npm create svelte@latest` (or successor) actually offers in 2026-04. Sloppy MS-prompt wording, not a real ambiguity — flagging for the record.

4. **DEC-025 closing RFI-003.** RFI-003 is about the *domain* (which URL?), DEC-025 is about the *product name*. Operator's rationale ("name implies domain") is reasonable, but the specific domain string (`unoai.com` vs `unoai.app` vs `unoai.io` vs an alternative TLD) is not stated and remains undecided. RFI-003 will close per operator instruction, but Phase 0a will need either (a) operator naming the domain at registrar-account-creation time, or (b) a fresh RFI-009 narrowing TLD/domain-string before DNS configuration. Not blocking MS-003. Builder will note the follow-up in DEC-025 body.

5. **Default branch after clone.** Will run `git symbolic-ref --short HEAD` after clone. Expected: `main`. If `master`, will rename to `main` before B8 push to keep with the operator's `git push origin main` instruction.

**Plan (numbered, terse — Scope A first, then Scope B):**

*Scope A — name + folder migration:*
1. Clone empty repo: `git clone https://github.com/tyrienjones-tech/UnoAi.git` to `C:\Users\Tyrien\Desktop\UnoAi`. Verify clone succeeded; verify default branch.
2. Copy migrated docs from `C:\Users\Tyrien\Desktop\Chat2U` → `C:\Users\Tyrien\Desktop\UnoAi`:
   - 4 root docs: `README.md`, `PROJECT.md`, `PLAN.md`, `PROCEDURES.md`
   - `forms/` directory with all 7 templates and accumulated entries
   - Preserve all content (MS-001 + MS-002 history, all DECs, all RFIs, all INCIDENTs).
3. Apply name swap with the operator's judgment-carve-out rule:
   - **Replace "Chat2U" → "UnoAi"** in all `.md` files at any depth.
   - **Replace "Companion" → "UnoAi"** where it's used as a proper noun for the product (file headers like `# Companion`, `# Companion — Project induction`, file-map folder name `companion-project/`, section labels referring to the product).
   - **Preserve "companion" / "AI companion"** where it's used as role/category descriptor ("honest companion", "AI companion app", Appendix A persona text, banned-moves persona language, fixture #4 description).
   - **Preserve historical-record entries** in DEC bodies, INC bodies, RFI bodies, MS bodies, SITE_LOG entries, even where they say "Companion" or "Chat2U" — these describe past states (per operator rule).
   - **Remove or rewrite Chat2U-placeholder warnings** that warn against using the placeholder name in user-facing content (those warnings are stale now). Historical-record statements describing the warnings as past concerns stay (per the historical-record rule).
   - For each grep hit Builder will inspect and apply the rule. Any usage where the call isn't obvious gets an RFI before applying.
4. Update README.md file-map folder line: `companion-project/` → `unoai/` (or operator-preferred name; default to `unoai/`).
5. Update README.md "# Companion" header → "# UnoAi" and the marketing-stub-area first heading.
6. Update PROJECT.md "# Companion — Project induction" → "# UnoAi — Project induction".
7. Update PLAN.md any `# ...Companion...` headers (none expected, confirm).
8. File DEC-023 (or operator-confirmed number) — Product name locked: UnoAi. Body per A4.
9. Update RFI-003 to status `ANSWERED 2026-04-27 via DEC-NNN` per operator's "RFI-003 closes here" instruction. Include a note that domain-string TLD selection may need a follow-up RFI before Phase 0a DNS.
10. File INC-005 — Project folder migrated from Chat2U to UnoAi. One-paragraph entry.
11. SITE_LOG entry covering Scope A completion.

*Scope B — repo scaffold:*
12. Verify migrated files staged in `C:\Users\Tyrien\Desktop\UnoAi` (not committed yet).
13. Add `LICENSE` at repo root: copyright header ("Copyright (c) 2026 Tyrien Jones / Licensed under the PolyForm Noncommercial License 1.0.0. / See LICENSE for full terms.") + canonical PolyForm NC text from operator-supplied source. **License body verbatim — no Builder edits to the license text itself.**
14. Add `CONTRIBUTING.md` per B3 wording. Security email left as `[security contact TBD]` — RFI-009 to be filed at appropriate later phase. (Builder note: RFI-009 is referenced in B3's Builder-note; will check whether the operator wants it filed in MS-003 or deferred until the Phase 8 / launch window. Default: defer to launch.)
15. Add `.gitignore` per B4 wording verbatim.
16. Run SvelteKit scaffold in `C:\Users\Tyrien\Desktop\UnoAi`: `npm create svelte@latest .` (or current-tool-name if changed; will note actual tool used). Project type: Builder will pick **skeleton** unless **demo** offers verification value (default skeleton — cleaner state). Options per DEC-013 pre-fill: TS yes, ESLint yes, Prettier yes, Vitest yes, Playwright yes, Tailwind yes-if-offered. If Tailwind not offered by current scaffold tool, add manually as a separate step (Tailwind v3 vs v4 — Builder will pick v3 by default unless adapter-cloudflare or Svelte 5 has documented incompatibility; will note actual version installed).
17. Run `npm install` to completion. Verify zero errors, zero peer-dependency warnings worth flagging.
18. Run `npm run dev`. Verify dev server starts, default page renders. Capture port number for proof.
19. Update DEC-013 body in `forms/DECISION.md`: replace engineer-pre-fill table with scaffold-time-actuals. Document tool used, exact options offered (incl. any not in pre-fill), Builder choices, SvelteKit version, adapter version, Tailwind version (or "added manually post-scaffold" with version), Vitest/Playwright versions.
20. SITE_LOG entry: scaffold completed, dev-server verified.
21. First commit:
    - `git add .`
    - `git commit` with operator-specified message: `"Initial commit: handover package + SvelteKit scaffold"` (no Co-Authored-By unless approved per Open Question 2).
    - `git push origin main`.
22. Capture proof: `git log --oneline`, commit URL on GitHub, file tree listing.
23. SITE_LOG entry: commit pushed, scaffold live on GitHub.
24. File DONE-003 with all proof.

**Files to be touched:**
- `Desktop/UnoAi/README.md` — modified (name swap + file-map folder name).
- `Desktop/UnoAi/PROJECT.md` — modified (header rename + grep-driven Companion→UnoAi swaps where used as proper noun).
- `Desktop/UnoAi/PLAN.md` — modified (any product-name uses).
- `Desktop/UnoAi/PROCEDURES.md` — likely no changes (no product-name uses expected; will verify).
- `Desktop/UnoAi/forms/DECISION.md` — modified (DEC-023 added, DEC-013 body replaced with actuals; possible product-name fixes elsewhere).
- `Desktop/UnoAi/forms/RFI.md` — modified (RFI-003 status update; possible product-name fixes elsewhere).
- `Desktop/UnoAi/forms/INCIDENT.md` — modified (INC-005 appended; possible product-name fixes in non-historical-record areas).
- `Desktop/UnoAi/forms/METHOD_STATEMENT.md` — modified (MS-003 entry; the entry itself becomes the historical record once approved).
- `Desktop/UnoAi/forms/SITE_LOG.md` — modified (3 progress entries through the session).
- `Desktop/UnoAi/forms/DONE.md` — modified (DONE-003 appended).
- `Desktop/UnoAi/forms/CHANGE_ORDER.md` — likely no changes (no scope expansions in MS-003).
- `Desktop/UnoAi/LICENSE` — created (PolyForm NC text + copyright header).
- `Desktop/UnoAi/CONTRIBUTING.md` — created (B3 wording).
- `Desktop/UnoAi/.gitignore` — created (B4 wording).
- `Desktop/UnoAi/{SvelteKit scaffold output}` — created by `npm create svelte@latest .` and `npm install`. Includes `package.json`, `package-lock.json`, `svelte.config.js`, `vite.config.js`, `tsconfig.json`, `src/`, `static/`, etc. Builder does not author these files; the scaffold tool does.

**Files NOT touched:**
- `C:\Users\Tyrien\Desktop\Chat2U\` — preserved as rollback path per operator instruction. Will not be deleted, edited, or moved.

**Expected diff size:** the FIRST commit will be very large because it bundles handover-package migration + LICENSE (~700 lines of license text) + CONTRIBUTING + .gitignore + full SvelteKit scaffold output (~30–60 generated files, several hundred lines including `package-lock.json`). Realistic: ~5,000–10,000 lines added in the initial commit, almost all from the lockfile and the license. Migration of handover docs is a near-zero net delta (mostly the same content with name swaps). Engineer-authored content delta is small.

**Risks identified:**

- **R1. DEC numbering gap (Open Question 1).** Resolved at MS-003 approval. Default-renumber to DEC-023.
- **R2. Commit-message attribution (Open Question 2).** Resolved at MS-003 approval. Default operator-message verbatim.
- **R3. DEC-013 wording mismatch (Open Question 3).** Cosmetic; Builder will update from current state regardless.
- **R4. DEC-025/RFI-003 domain-vs-name conflation (Open Question 4).** Builder will note in DEC-NNN body that domain TLD selection remains a follow-up question; not blocking MS-003.
- **R5. Default branch verification (Open Question 5).** 5-second check after clone. If `master`, rename before push.
- **R6. Companion→UnoAi judgment calls.** Bounded set of usages. Builder will grep all `Companion` and `Chat2U` occurrences, classify each as proper-noun-product-name (rename), role/category-descriptor (preserve), or historical-record-entry (preserve), and apply the rule. Any borderline case → RFI before applying. Will document the classification list in DONE-003.
- **R7. SvelteKit scaffold tool drift.** `npm create svelte@latest` may have been replaced (e.g., `npx sv create`). Builder will use whichever the current Svelte ecosystem documents as the canonical scaffold path in 2026-04. Actual tool name + version recorded in DEC-013 update.
- **R8. Tailwind v3 vs v4.** Tailwind v4 was a major rewrite. If adapter-cloudflare or Svelte 5 has known compatibility issues with Tailwind v4 in 2026-04, Builder picks v3. If both work, Builder picks the version the scaffold tool offers by default. Version recorded in DEC-013 update.
- **R9. Lockfile in initial commit.** `package-lock.json` will be ~thousands of lines committed. This is correct (lockfiles are committed for app projects per ecosystem norm), just noting that the diff will look enormous for cosmetic reasons.
- **R10. First-commit pattern-setting.** Per rules of engagement, this commit defines patterns. If anything in scaffold output looks wrong (deps not pinning, weird config defaults, lockfile choices), Builder will pause and file an RFI before B8 commit. Specifically watching for: any `*` or `latest` version specifiers in `package.json` deps, any `.gitignore` entries that conflict with Builder's added one (resolve in favour of cumulative union), any default ESLint/Prettier configs that conflict with operator's preferences (none stated yet — defer to defaults).
- **R11. The "Chat2U placeholder warning" removal (Scope A3 last bullet).** Some warnings live inside historical-record entries (e.g. MS-001's "Chat2U placeholder name leaking into user-facing content. Mitigation: scrubbed sample staging URL in DONE.md example") — those stay per the historical-record rule. Forward-looking placeholder warnings (e.g. anything in PROJECT.md current text saying "Chat2U is a placeholder, do not use in user-facing content") are stale and should be removed. Builder will distinguish at grep-and-classify time.
- **R12. Cross-reference web post-migration.** Same kind of post-apply grep sweep as MS-001/MS-002. Will verify: all `DEC-NNN` references resolve, all `RFI-NNN` references resolve, all `MS-NNN` references resolve, no orphan `Companion` proper-noun uses remain (only role-descriptor "companion" and historical-record "Companion" should remain), no orphan `Chat2U` references remain except in historical-record entries.
- **R13. Old folder retention.** `C:\Users\Tyrien\Desktop\Chat2U\` left intact per operator instruction. No edits, no deletions. INC-005 will note the rollback-path purpose.

**Acceptance criteria (will be copied verbatim into DONE-003):**
- `C:\Users\Tyrien\Desktop\UnoAi\` exists and contains: `README.md`, `LICENSE`, `CONTRIBUTING.md`, `PROJECT.md`, `PLAN.md`, `PROCEDURES.md`, `.gitignore`, `package.json`, `package-lock.json`, `svelte.config.js`, `vite.config.js`, `tsconfig.json`, `src/` (with SvelteKit scaffold contents), `static/`, `forms/` (with all 7 templates and accumulated entries from MS-001 / MS-002 history).
- `C:\Users\Tyrien\Desktop\Chat2U\` exists and is unchanged from MS-002 closing state (rollback path preserved).
- All `Chat2U` references in forward-looking docs replaced with `UnoAi`. All `Companion` proper-noun product references replaced with `UnoAi`. Role-descriptor "companion" and "AI companion" preserved. Historical-record entries preserved verbatim.
- `forms/DECISION.md` includes DEC-023 (or operator-confirmed number) — Product name locked: UnoAi. Body matches A4 verbatim. DEC-013 body updated from engineer-pre-fill to scaffold-time-actuals (tool used, options offered, choices made, versions installed).
- `forms/RFI.md` shows RFI-003 status `ANSWERED 2026-04-27 via DEC-NNN`. RFI-003 entry includes a Builder-note flagging the domain-TLD follow-up question.
- `forms/INCIDENT.md` includes INC-005 — migration record.
- `LICENSE` file content matches the operator-supplied PolyForm NC text verbatim, with the copyright header prepended.
- `CONTRIBUTING.md` content matches B3 wording verbatim with `[security contact TBD]` placeholder.
- `.gitignore` content matches B4 baseline.
- `npm install` completes without errors.
- `npm run dev` starts a dev server; default Svelte page renders.
- `git log --oneline` shows one commit on `main`.
- Commit pushed to `https://github.com/tyrienjones-tech/UnoAi`; visible on GitHub.
- DONE-003 contains: `git log --oneline` output, GitHub commit URL, `npm run dev` startup output, file list of `C:\Users\Tyrien\Desktop\UnoAi\`, DEC-013 update confirmation, DEC-NNN-product-name confirmation, INC-005 confirmation, B9 Cloudflare-Pages-deferral note.

**Operator approval:** APPROVED 2026-04-27.
**Approval notes:**
- **Open Question 1 (DEC numbering):** Resolved — renumber product-name DEC from DEC-025 to **DEC-023** (sequential after DEC-022). Engineer working agreement #5 added: number DECs sequentially from current state of DECISION.md, no skip-numbering.
- **Open Question 2 (commit footer):** Resolved — **NO Co-Authored-By Claude footer** on initial commit. Commit message verbatim per operator. Going forward: same posture across the project.
- **Open Question 3 (DEC-013 wording):** Acknowledged. Builder updates DEC-013 from current state (engineer pre-fill), not from "TO BE FILLED."
- **Open Question 4 (RFI-003 closure):** Approved with explicit follow-up — close RFI-003 via DEC-023, AND file **RFI-009** in this MS for TLD selection. Engineer's lean: `.com` if available, fall back to `.app`; avoid `.io` and `.ai`. Operator decision pending — check `unoai.com` availability first.
- **Open Question 5 (default branch):** Verified post-clone — branch is `main`, no rename required.
- **Companion→UnoAi judgment-call rule:** Approved as proposed.
- **SvelteKit scaffold tool drift:** Approved Builder using current ecosystem tooling.
- **Tailwind v3 vs v4:** Approved v3 default; v4 only if adapter-cloudflare/Svelte 5 docs require it.
- **First-commit-defines-patterns:** Approved Builder pause+RFI before B8 push if scaffold output has `*` or `latest` version specifiers, or other commit-history smells.

---

### MS-004 — Session lifecycle and state persistence
- **Date:** 2026-04-28
- **Agent:** Reaper-1
- **Phase:** 0b → enforcement layer (post-Phase-0b, pre-Phase-1)
- **Task:** Make procedural discipline mechanical, not trust-based. Add `state/current.md` (recoverable state from cold start), session sign-in / sign-out templates in SITE_LOG, Procedure 9, validator script that runs in pre-commit hook, and a synthetic-session test proving the validator catches violations.
- **Linked RFIs / decisions:**
  - **New:** DEC-026 (session lifecycle locked).
  - **Adds enforcement to:** Procedure 1 (induction), Procedure 4 (decision log numbering), Procedure 6 (RFI cross-references), Procedure 7 (incident numbering). Currently trust-based; becomes mechanically checked.
  - **Builds on:** DEC-024 (gitleaks pre-commit hook). Same hook, new check.
  - **Closes pattern named in:** INC-003 (DECs reference RFIs not in source), INC-004 (sweep-miss across files).
- **Operator approval:** pending.

**Open items (Builder-runtime, no decisions needed unless operator overrides):**

1. **Validator language: bash.** Builder picks bash for consistency with the existing `.githooks/pre-commit` (already bash), the bash shell I'm running in, and gitleaks integration. PowerShell would create a two-language hook chain. Bash works on operator's Windows via Git Bash and on any future macOS/Linux clone. If operator wants PowerShell instead, say so.
2. **Code-block detection for skipping example entries.** All form templates have example entries inside ``` fences (`MS-005` example, `INC-001` example, `RFI-001` example, `DONE-004` example). The validator must skip these or it will report false numbering errors. Builder approach: track ``` toggle in bash (~10 lines), only count `### XXX-NNN` headings outside fenced blocks.
3. **MS-004 sign-in is bootstrap-recursive.** Procedure 9 mandates sign-in-before-work, but the SITE_LOG templates don't exist until B1 lands. Builder approach: B1 (templates) is the first work item; the retroactive MS-004 sign-in entry is filed immediately after, with a one-line note explaining that this single session bootstrapped the lifecycle. Future sessions sign in before any work.
4. **Hook order: gitleaks → validator.** Both must pass for commit. gitleaks first (fail fast on secrets) before structural checks.
5. **Validator size budget.** Operator's ~150-line cap is tight for 8 checks. Builder estimate: ~150 lines achievable with concise bash. If budget is busted, will pause and RFI rather than ship a half-working check.

**Plan (numbered, terse):**

*Bootstrap (Scope G + B):*
1. Write B1 templates at top of `forms/SITE_LOG.md` (session-start + session-end blocks).
2. File retroactive MS-004 session-start entry in SITE_LOG using the new template, with a Builder-note explaining the bootstrap recursion (single legitimate exception, future sessions follow Procedure 9 strictly).

*Scope A — state/current.md:*
3. Create `state/` directory at repo root.
4. Create `state/current.md` populated with actual current values per the operator's template, with the START/END marker lines removed.

*Scope C — Procedure 9:*
5. Append Procedure 9 to `PROCEDURES.md` after Procedure 8.
6. Update `PROCEDURES.md` summary table with row 9.
7. Update `PROCEDURES.md` opening sentence "Eight procedures" → "Nine procedures."
8. Update `README.md` "the eight rules" → "the nine rules" in 2 places (header at line 12 + file-map comment).
9. Update `README.md` agent-onboarding step list: insert validator-run step between "Skim PLAN.md" and "File a SITE_LOG entry." Renumber subsequent steps.

*Scope D — validator:*
10. Create `scripts/` directory at repo root.
11. Write `scripts/validate.sh` with all 8 checks (numbering for DEC/RFI/INC/MS, cross-references for Closes-RFI / Supersedes-DEC, state counters, session lifecycle).
12. `chmod +x scripts/validate.sh`.
13. Update `.githooks/pre-commit` to run `scripts/validate.sh` after gitleaks. Both must exit 0 for commit to proceed.

*Scope F — DEC-026:*
14. File DEC-026 in `forms/DECISION.md` (session lifecycle locked).
15. Update `state/current.md` "Latest DEC" counter to DEC-026.

*Scope E — synthetic test:*
16. Run `scripts/validate.sh` on clean state. Expect PASS.
17. Test 5 violations one at a time:
    a. Add fake DEC-100 (numbering gap) → expect FAIL with "DEC numbering gap" message → revert.
    b. Add `Closes: RFI-999` to a DEC → expect FAIL "DEC-NNN references RFI-999 which does not exist" → revert.
    c. Edit `state/current.md` Latest DEC counter to wrong number → expect FAIL "state/current.md Latest DEC counter (DEC-XXX) does not match actual highest DEC (DEC-026)" → revert.
    d. Add second session-start without preceding session-end → expect FAIL "open session-start without matching session-end" → revert.
    e. Add duplicate DEC number → expect FAIL "duplicate DEC-NNN entry" → revert.
18. Document each FAIL output verbatim in DONE-004 proof.
19. Final clean-state validator run. Expect PASS.

*Sign out + commit:*
20. File MS-004 session-end entry in SITE_LOG using the new template.
21. Update `state/current.md`: Latest MS = MS-004 (complete), Latest DEC = DEC-026, Latest INC = INC-005 (unchanged), Latest RFI = RFI-009 (unchanged), Phase status, Pending operator actions list, etc.
22. `git add . && git commit -m "MS-004: session lifecycle + validator + state persistence"` (no Co-Authored-By footer; pre-commit hook fires both gitleaks and validator).
23. `git push origin main`.
24. File DONE-004 with proof: validator PASS output, 5 FAIL outputs, state/current.md committed, sign-in/sign-out entries proving end-to-end lifecycle, hook output showing both checks ran.

**Files to be touched:**
- `Desktop/UnoAi/state/` — created.
- `Desktop/UnoAi/state/current.md` — created with populated values.
- `Desktop/UnoAi/scripts/` — created.
- `Desktop/UnoAi/scripts/validate.sh` — created (~150 lines max).
- `Desktop/UnoAi/.githooks/pre-commit` — modified (add validator after gitleaks).
- `Desktop/UnoAi/forms/SITE_LOG.md` — modified (templates at top + sign-in/sign-out entries for this session).
- `Desktop/UnoAi/forms/DECISION.md` — modified (DEC-026 appended).
- `Desktop/UnoAi/forms/METHOD_STATEMENT.md` — modified (this MS-004 entry; approval status update post-approval).
- `Desktop/UnoAi/forms/DONE.md` — modified (DONE-004 appended).
- `Desktop/UnoAi/PROCEDURES.md` — modified (Procedure 9 + summary table + "Nine procedures" header).
- `Desktop/UnoAi/README.md` — modified ("nine rules" sweep + agent-onboarding step list).

**Files NOT touched (per scope):**
- `forms/CHANGE_ORDER.md` — no change.
- `forms/RFI.md` — no change (no new RFIs from this MS).
- `forms/INCIDENT.md` — no change unless violation testing or sign-in lifecycle finds one.
- `PROJECT.md` — no change (lifecycle is procedural, not banned-moves; PROCEDURES.md is the right venue).
- `PLAN.md` — no change (lifecycle is meta-process, not phase work).
- `LICENSE`, `CONTRIBUTING.md`, `.gitignore`, `.gitleaks.toml` — no change.
- The SvelteKit scaffold tree (`src/`, `static/`, `package.json`, etc.) — no change. This MS doesn't touch product code.
- Existing SITE_LOG entries from MS-001/002/003 — preserved verbatim, not retroactively rewritten.

**Expected diff size:** ~400 lines net added across 8 files. No dependencies. No code (just the validator script, which is shell, not product code).

**Risks identified:**

- **R1. Bootstrap recursion (G1).** MS-004's session-start happens AFTER the templates exist, retroactively. This is a one-time legitimate exception. Validator will pass after sign-in is filed because it'll see exactly one open session (MS-004's start) and zero unmatched ends. Mitigation: explicit Builder-note in the sign-in entry naming the bootstrap.

- **R2. Code-block detection edge cases.** If a future agent writes `### DEC-NNN` inside a markdown blockquote (without ``` fences) or in some other non-standard place, the validator might miscount. Mitigation: tight ``` toggle, plus the "real entries are below `## Entries` marker" pattern is consistent across all form files. Builder will additionally check that the count of `### DEC-NNN` headings *outside* ``` matches the count parsed inside the ``Entries`` section as a sanity belt-and-suspenders.

- **R3. Validator size budget.** ~150 lines is tight. Mitigation: lean output, factor common helpers (one `extract_real_numbers` function reused for DEC/RFI/INC/MS). If budget is busted, pause and RFI per rules of engagement.

- **R4. Synthetic-violation reverts.** E1 says "create violation, run validator, confirm FAIL, revert." If I forget to revert one and commit it, the violation lands. Mitigation: do all 5 tests in one Bash session with explicit revert after each, then a final `git diff` sanity check before commit to confirm working tree is clean of test artifacts.

- **R5. Validator running before B1 templates exist.** If the validator's session-lifecycle check expects sign-in entries to exist and they don't (because B1 hasn't landed), the first run fails. Mitigation: B1 + sign-in are the FIRST work items; validator is wired into hook only after both exist; first manual validator run happens AFTER all B1/A/C/F items land.

- **R6. Pre-commit hook now does two heavy operations.** gitleaks scan + validator each take a few hundred ms. On large repos this could become noticeable; for UnoAi (~350 KB scanned) it's <500ms total. Acceptable.

- **R7. MS template / form templates contain example entries with realistic-looking numbers (`MS-005`, `INC-001`, `RFI-001`, `DONE-004`).** The validator must skip these. Already named in Open Item 2. Code-block detection handles it.

- **R8. State-counter check fragility.** state/current.md's "Latest DEC: DEC-XXX" line is human-readable. If the format drifts (e.g. operator reformats the line), the validator breaks. Mitigation: validator uses a forgiving regex (`Latest DEC:\s*DEC-(\d+)`); if no match found, validator reports "state/current.md format unrecognized — counter check skipped" rather than a hard fail. Soft-fail on parse error means counter check is best-effort, not blocking.

  Actually — making it a soft-fail dilutes the discipline. Per operator's intent (mechanical enforcement), the counter check should hard-fail if the format isn't parseable. Builder will hard-fail but include a clear error message naming the line that didn't match. If operator wants soft-fail, override at approval.

- **R9. Sign-in/sign-out heading format.** Operator specified `### YYYY-MM-DD HH:MM session start` and `### YYYY-MM-DD HH:MM session end`. Validator regex needs to match these patterns precisely. Builder's regex: `^### \d{4}-\d{2}-\d{2} \d{2}:\d{2} session (start|end)$`. Stricter than operator's spec on whitespace; Builder will document the regex in the validator and in the sign-in template instructions so future sessions don't drift.

**Acceptance criteria (will be copied verbatim into DONE-004):**
- `state/current.md` exists, committed, populated with actual current values per the operator's template (Phase, Active MS, Counters, Open RFIs, Pending operator actions, Last verified working state, Engineer working agreements 1–6, Banned moves mirror).
- `forms/SITE_LOG.md` has the session-start and session-end templates at the top, clearly labelled, above the existing entries. Existing MS-001/002/003 entries preserved verbatim.
- MS-004's own sign-in and sign-out entries are present in SITE_LOG using the new templates. Sign-in carries the bootstrap-note. Sign-out shows validator PASS.
- `PROCEDURES.md` has Procedure 9. Header reads "Nine procedures." Summary table has 9 rows.
- `README.md` reads "the nine rules" in both line 12 and file-map. Agent-onboarding step list includes a validator-run step before SITE_LOG.
- `forms/DECISION.md` has DEC-026 (session lifecycle locked).
- `scripts/validate.sh` exists, executable, runs from repo root, performs all 8 checks.
- `.githooks/pre-commit` runs gitleaks then validator. Both must PASS for commit.
- Synthetic-violation test: 5 violations each tested individually; validator FAIL output captured for each; final clean run is PASS.
- Single test commit (this MS's commit) fires both gitleaks and validator; both clean.
- `git push origin main` succeeds.
- DONE-004 contains: validator PASS output, 5 FAIL outputs verbatim with each issue specifically named, hook output from the actual MS-004 commit showing both checks ran, file list of the new state/ and scripts/ trees.

**Operator approval:** APPROVED 2026-04-28.
**Approval notes:**
- **Decision 1 (validator language: bash):** Approved. Two-language chain is exactly the kind of accidental complexity to avoid.
- **Decision 2 (code-block detection):** Approved. Standard pattern, ~10 lines. Necessary correctness, not feature creep.
- **Decision 3 (bootstrap recursion):** Approved. Sign-in note must explicitly say "MS-004 sign-in filed retroactively after B1 created the templates — first and only session this bootstrap exception applies. All future sessions sign in first, then work."
- **Decision 4 (hook order: gitleaks → validator):** Approved. Fail-fast on secrets first.
- **Decision 5 (state/current.md hard-fail on parse error):** Approved as feature, not bug. Document the exact line format expected in `state/current.md` as a comment at the top of the file.
- **R3 acknowledgment:** ~150-line cap is a signal not a hard limit. If busted, RFI before shipping half-working — design review trigger.
- **R8 acknowledgment:** Hard-fail named as intentional in DEC-026 body. Trade-off documented.
- **R9 acknowledgment:** Document the heading-line format in BOTH the template (in SITE_LOG.md) AND in PROJECT.md's "For agents working on this project" section so future agents copy it correctly. Regex must appear as a comment in the validator script.
  - **Builder interpretation note:** the "For agents..." section currently lives in `README.md`, not `PROJECT.md`. Builder will document in README's existing section. See SITE_LOG sign-in entry for transparency note.
- **H1 (added scope):** Add a one-paragraph organising-principle section to top of `PROJECT.md` before the existing content: *"This project is built by AI agents with a human operator in the loop. Procedures, file structure, and documentation conventions are optimized for stateless agents recovering context from cold start, not for human developers retaining context across sessions. Read PROCEDURES.md before any session work."* Easy fit; folded into MS-004.

---

### MS-005 — Chain validator check + code conventions for AI agents + README markdown fixes
- **Date:** 2026-04-28
- **Agent:** Reaper-1
- **Phase:** 0b infrastructure layer (post-MS-004, pre-MS-006)
- **Session start:** 2026-04-28 01:10 (see SITE_LOG)
- **Task:** Three scopes combined. **Scope A** closes INC-006 (validator MS-chain check missing — the gap Builder flagged after DONE-004 sign-off when operator described chain mechanism as "working as designed"). **Scope B** adds the "For agents reading the code" section + naming/header conventions to PROJECT.md, prepping for Phase 1 code. **Scope C** restores README's `## Self-hosting` heading marker (operator's commit `bf2d661` accidentally stripped it) and updates the stale README "Status" line to match `state/current.md`. Plus DEC-027 (code-conventions lock) and INC-006 (the chain-check gap).
- **Depends on:** MS-004 (DONE-004 signed 2026-04-28).
- **Linked RFIs / decisions:**
  - **New:** DEC-027 (code conventions for AI agents locked). INC-006 (validator chain-check gap).
  - **Builds on:** DEC-026 (validator + session lifecycle) — adds 9th check to `scripts/validate.sh`. Optional 10th check (README Status currency) conditional on validator size budget.
  - **Doesn't change:** DEC-024, gitleaks ruleset, hook structure, all prior DEC/RFI/INC entries.
- **Operator approval:** pending.

**Open items / Builder decisions to surface at MS-005 approval:**

1. **INC-006 body authorship.** Operator's MS-005 prompt (Scope A1) says "File INC-006 in INCIDENT.md using the body Engineer provided in the approval message." The DONE-004 sign-off and the MS-005 prompt itself do not contain a formal INC-006 body. Builder will author INC-006 mechanically from the established facts (validator built in MS-004 missing chain check; "working as designed" claim made in DONE-004 sign-off about non-existent enforcement; Reaper flagged the gap in chat post-sign-off). Same Builder-authored historical-record pattern as RFI-006/007/008 in earlier MSes; Builder-note inline. If operator has a specific body in mind, paste at approval and Builder uses it verbatim.

2. **"DONE entry exists" vs "DONE entry signed" semantics for the chain check.** Operator's Scope A2 wording is ambiguous between two interpretations:
   - **(a) DONE entry exists in DONE.md for the dependency MS** — mechanical, works with current operator practice (sign-off has been chat-only; file `Operator sign-off:` lines have stayed `pending` for DONE-002, DONE-003, DONE-004).
   - **(b) DONE entry exists AND has `Operator sign-off: signed YYYY-MM-DD`** — stricter; requires operator to update file at sign-off time, which is a procedural change not currently happening.
   Builder default: **(a)**, matching operator's literal wording "marked DONE in DONE.md." If operator wants (b), the operator-side procedure needs to add "update DONE entry sign-off line" to the sign-off ritual, AND the existing DONE-002/003/004 entries need to be retroactively marked signed (so MS-005's own `Depends on: MS-004` doesn't immediately fail). Override at approval.

3. **Engineer working agreement #9 — what is it?** Operator's Scope D1 says "Update the 'Engineer working agreements' list to include #7, #8, #9." Operator's DONE-004 sign-off introduced #7 (bash budgets are smell-checks) and #8 (untested validators are worse than no validator). The MS-005 prompt body doesn't introduce a #9 explicitly. Builder's interpretation: #9 is the lesson from INC-006 — "'Working as designed' claims about enforcement need to be validated against the code, not the design intent." If operator has different wording in mind, paste at approval.

4. **Validator size budget pressure.** Currently 192 lines. Operator's caps: 210 soft, 220 hard. Estimates:
   - Chain check (Scope A): ~25–30 lines (parse DONE.md for done-MSes; parse METHOD_STATEMENT.md for `Depends on:` lines; cross-reference; ~6 lines of inline comment per check pattern).
   - README Status check (Scope C3): ~15–20 lines (parse state/current.md Phase line; parse README Status section; compare phase identifier + status word; allow wording variation).
   - Realistic post-A: 218–222 lines. **At or just over the 220 hard cap.**
   - Realistic post-A+C3: 235–242 lines. **Over the cap.**
   Builder default per operator's Scope C3 conditional: **ship Scope A (chain check), drop Scope C3 (README check), document the deferral in SITE_LOG and DONE-005.** README Status currency stays trust-based for MS-005; can ship in MS-006 if operator wants.

5. **B2 (organising-principle line at top of PROJECT.md) — already landed in MS-004.** Builder verified PROJECT.md line 5 contains the H1 text. Scope B2 is a no-op for MS-005; will note in SITE_LOG.

6. **Synthetic-violation test for the chain check (Scope A3).** Same discipline as MS-004's E1. One test:
   - Add fake `### MS-100 — synthetic chain test` with `Depends on: MS-099` to METHOD_STATEMENT.md.
   - Run validator. Expect FAIL with: `"MS chain: MS-100 cannot proceed — depends on MS-099 which is not yet DONE (or DONE entry is not yet signed)."` (or the agreed message format from Open Question 2's resolution).
   - Revert the fake MS.
   - Final clean run: PASS.
   Operator's "no shipping untested validators" rule (working agreement #8) makes this non-negotiable.

**Plan (numbered, terse — Scope A → B → C → D → E → sign-out → commit → DONE-005):**

*Scope A — chain validator check (closes INC-006):*
1. File INC-006 in `forms/INCIDENT.md` (Builder-authored body per Open Question 1; Builder-note inline acknowledging the authorship).
2. Update `scripts/validate.sh` with 9th check: MS-chain dependency. Parse DONE.md to build a set of MSes that have DONE entries (per Open Question 2 resolution — "DONE exists" is the default mechanical signal). Parse METHOD_STATEMENT.md outside `````` fences for `### MS-NNN` headings + their `Depends on:` lines (within their body block). For each `Depends on: MS-NNN`, verify MS-NNN ∈ done-MSes. FAIL with the specific MS-XXX → MS-NNN names.
3. Update validator script header comment to document 9 checks (was 8).
4. Document in DEC-026 reproduction notes that the chain check was added in MS-005 (not in MS-004 as originally claimed).
5. Synthetic-violation test (Scope A3): add fake MS-100/Depends-on-MS-099, run validator, capture FAIL output, revert. Final clean PASS.

*Scope B — code conventions:*
6. Verify B2 (organising-principle line at top of PROJECT.md). Confirmed already present from MS-004.
7. Append "For agents reading the code" section to PROJECT.md after the existing "Sensitive content — never committed" section. Content per operator's Scope B1 verbatim, with file-header convention, DEC-reference rule, tests-as-documentation rule, naming conventions, and "When in doubt → RFI" closer.

*Scope C — README markdown fixes:*
8. Restore `## Self-hosting` heading marker (currently plain text per operator commit `bf2d661`).
9. Update README "Status" section to: "Phase 0b complete. Infrastructure phase in progress (MS-005). Phase 1 begins after MS-006 DONE."
10. **Skip Scope C3 (README Status currency check)** per Open Question 4's budget call. Document deferral in SITE_LOG and DONE-005. Note the README↔state synchronization remains a trust-based discipline; operator can re-attempt mechanical enforcement in MS-006 with refactored validator if desired.
11. Update PROCEDURES.md Procedure 9: append a sentence noting that README's Status section must be kept in sync with `state/current.md` at sign-out, with a Builder-note that mechanical enforcement is deferred to MS-006.

*Scope D — state update:*
12. Update `state/current.md`:
    - Bump Updated timestamp.
    - Phase line: "Phase 0b complete. Infrastructure phase in progress (MS-005). Phase 1 blocked on MS-006."
    - Active MS: MS-005 (in progress). MS-004 marked DONE.
    - Latest MS counter: MS-005.
    - Latest INC counter: INC-006.
    - Latest DEC counter: DEC-027.
    - Add a new "MS chain status" subsection enumerating MS-001 through latest with status (DONE / in progress / pending).
    - Add engineer working agreements #7, #8, #9 to the running list.

*Scope E — DEC-027:*
13. File DEC-027 in `forms/DECISION.md` per operator's Scope E1 body.

*Sign-out + commit:*
14. Final validator run. Expect PASS.
15. File MS-005 session-end entry in SITE_LOG using the new template. Validator: PASS. state/current.md updated: YES.
16. `git add . && git commit -m "MS-005: chain validator check + code conventions + README fixes"` (no Co-Authored-By footer; pre-commit hook fires gitleaks + validator). Push.
17. File DONE-005 with proof. Commit + push DONE-005 in a follow-up close-out commit.

**Files to be touched:**
- `Desktop/UnoAi/scripts/validate.sh` — modified (add 9th check; budget ~217–222 post-edit).
- `Desktop/UnoAi/forms/INCIDENT.md` — modified (INC-006 appended).
- `Desktop/UnoAi/forms/DECISION.md` — modified (DEC-027 appended).
- `Desktop/UnoAi/forms/METHOD_STATEMENT.md` — modified (this MS-005 entry; approval status update post-approval).
- `Desktop/UnoAi/forms/SITE_LOG.md` — modified (sign-in entry already filed; sign-out + DONE-005 reference at session close).
- `Desktop/UnoAi/forms/DONE.md` — modified (DONE-005 appended).
- `Desktop/UnoAi/PROJECT.md` — modified (append "For agents reading the code" section).
- `Desktop/UnoAi/PROCEDURES.md` — modified (Procedure 9 sentence about README Status sync).
- `Desktop/UnoAi/README.md` — modified (heading marker restore + Status line update).
- `Desktop/UnoAi/state/current.md` — modified (counters, MS chain status, working agreements, phase line).

**Files NOT touched (per scope):**
- `forms/CHANGE_ORDER.md`, `forms/RFI.md`, `LICENSE`, `CONTRIBUTING.md`, `.gitignore`, `.gitleaks.toml`, `.githooks/pre-commit`, `PLAN.md`. SvelteKit scaffold tree (`src/`, `static/`, `package.json`, etc.).

**Expected diff size:** ~250 lines net added across 10 files. No product code. No dependencies.

**Risks identified:**

- **R1. Open Question 1 (INC-006 body authorship).** Builder authors mechanically; same risk pattern as RFI-006/007/008. Mitigation: Builder-note inline; operator review at MS-005 approval.

- **R2. Open Question 2 (DONE-exists vs DONE-signed semantics).** Builder default: DONE-exists. Risk: operator wanted DONE-signed and the mechanical signal misses pre-signoff filings of dependent MSes. Mitigation: surfaced at approval; if operator wants signed-check, the procedural change (update DONE entry's sign-off line at chat sign-off) needs to land in MS-005 too OR Builder retroactively marks DONE-002/003/004 signed.

- **R3. Open Question 3 (working agreement #9).** Builder proposes wording from INC-006 lesson. Mitigation: surfaced at approval; operator can paste alternate wording.

- **R4. Validator size budget at the cap.** With Scope A only, ~217–222 lines. **Likely just over the 220 hard cap** depending on chain-check implementation density. Per Scope A5 ("If budget overrun exceeds 220 after this check, pause and RFI"), Builder will RFI if the post-A line count is >220. C3 stays dropped regardless.

- **R5. Synthetic violation test discipline.** Mandatory per working agreement #8. One test for chain check; capture FAIL output verbatim for DONE-005 proof.

- **R6. Operator's `bf2d661` README amendment dropped the `##` from "Self-hosting".** Builder did NOT modify operator's commit. Restoring the heading in MS-005 is the operator-blessed fix path (Scope C1). Acknowledging that operator commits can carry edit artifacts that Builder catches and fixes only with explicit authorisation.

- **R7. README Status currency mechanical enforcement deferred.** Per Open Question 4 + Scope C3 budget conditional. The README↔state sync remains a trust-based discipline through MS-005. Procedural reminder in PROCEDURES.md Procedure 9. Operator may add the check in MS-006 with refactored validator.

- **R8. Chain check could deadlock if MS chain is misconfigured.** Hypothetical: an MS with `Depends on: MS-NNN` where MS-NNN doesn't yet exist in METHOD_STATEMENT.md. The check should FAIL with "MS-NNN does not exist" (separate from "MS-NNN not yet DONE"). Builder will distinguish these failure modes in the FAIL message for operator clarity.

- **R9. MS-005 itself has `Depends on: MS-004`. DONE-004 exists in DONE.md (filed in MS-004 session-end commit and now signed in chat). Validator semantics per Open Question 2 default (a) "DONE entry exists" → MS-005 dependency satisfied. If operator overrides to (b) "DONE entry signed", DONE-002/003/004 sign-off lines all currently say "pending" → all chain checks would fail until file-state catches up.

**Acceptance criteria (will be copied verbatim into DONE-005):**
- `forms/INCIDENT.md` has INC-006 documenting the validator chain-check gap (Builder-authored, Builder-note inline).
- `scripts/validate.sh` has 9 checks; new check is MS-chain dependency. Header comment block updated to enumerate 9 checks. Line count: 192 + chain check, target ≤220.
- Synthetic violation test for chain check produced FAIL output verbatim, captured in DONE-005 proof. Final clean run: PASS.
- `PROJECT.md` has "For agents reading the code" section after "Sensitive content" section, containing file-header convention, DEC-reference rule, tests-as-documentation rule, naming conventions, "When in doubt" closer, all per operator's Scope B1 verbatim.
- `PROJECT.md` organising-principle line at top: confirmed already present (no edit needed; from MS-004).
- `README.md` "Self-hosting" section has `##` heading marker restored.
- `README.md` "Status" section reads: "Phase 0b complete. Infrastructure phase in progress (MS-005). Phase 1 begins after MS-006 DONE."
- `PROCEDURES.md` Procedure 9 has a sentence about README Status section sync at sign-out.
- `forms/DECISION.md` has DEC-027 (code conventions locked) per operator's Scope E1.
- `state/current.md` updated: MS-004 DONE, MS-005 in progress, Latest MS=MS-005, Latest INC=INC-006, Latest DEC=DEC-027, MS chain status section, working agreements #7/#8/#9 in the list, phase line current.
- Sign-in (filed at session start) and sign-out (filed at session end) entries in SITE_LOG using the Procedure 9 templates.
- Validator pre-commit run: PASS. Hook fires gitleaks + validator on actual MS-005 commit.
- Push to GitHub succeeds. Final commit visible at the repo URL.
- DONE-005 contains: validator PASS output, chain-check FAIL output verbatim, hook output from MS-005 commit, file-by-file change summary, line counts (pre/post validator, all touched files).

**Operator approval:** APPROVED 2026-04-28.
**Approval notes:**
- **Open Question 1 (INC-006 body authorship):** Operator-supplied verbatim engineer-drafted body — Builder transcribed exactly with inline Builder-note acknowledging the Builder-mediated transcription pattern.
- **Open Question 2 (DONE-exists vs DONE-signed):** Builder default approved — chain check uses "DONE-NNN entry exists in DONE.md" semantics. The procedural gap (DONE-002/003/004 sign-offs are chat-only) filed as **RFI-010** for resolution in MS-006.
- **Open Question 3 (working agreement #9):** operator-supplied wording: "DONE sign-offs require mechanical verification of new tooling, not visual inspection. If a check was specced, the sign-off must include 'ran the check against a synthetic violation, confirmed FAIL.' Visual inspection of the script's presence is not sufficient."
- **Open Question 4 (validator size budget):** Builder default approved — ship Scope A (chain check), drop Scope C3 (README currency check), defer to MS-006 with refactored validator. Scope C1 + C2 (heading restoration + Status line update) ship as file edits.
- **Mid-session RFI on validator size:** post-Scope-A validator was 237 lines (>220 hard cap). Operator approved (a) — accept 237 per working agreement #7. Block-aware parsing for chain check is correctness-required to avoid false positives from example entries inside ``` fences; compressing it would re-introduce them, violating working agreement #8.
- **New working agreement #10 (operator wrote "#11"; Builder renumbered to next-sequential per discipline #5):** "Bash budget caps for the validator are calibrated against the existing per-check complexity, not the new check's complexity. New checks that require new parsing primitives (block tracking, multi-file walks, structured parsing) will exceed the per-check budget by 2–3× and that's expected. Future budgets should be set at 'current size + estimated new check size' rather than fixed caps." Operator can correct the renumber at DONE-005 sign-off if the skip was intentional.
- **DEC-026 update:** the 150-line validator guidance from MS-004 is retired. Caps revisited per-MS based on what's being added.
- **Scope C4:** README↔state synchronization is trust-based through MS-005, may gain mechanical enforcement in MS-006 with refactored validator.

---

### MS-006 — Code structure + dev tooling
- **Date:** 2026-04-28
- **Agent:** Reaper-1
- **Phase:** 0b infrastructure layer (post-MS-005, pre-MS-007)
- **Session start:** 2026-04-28 02:00 (see SITE_LOG)
- **Task:** Eight scopes covering structural conventions and mechanical enforcement that Phase 1 product code will follow. **Scope A** directory structure under `src/` + skeleton with `.gitkeep`. **Scope B** verify naming conventions from MS-005 (no duplication). **Scope C** test layout convention + Vitest/Playwright config check. **Scope D** errors-and-logging convention. **Scope E** `.env.example` + gitignore + .gitleaks.toml additions. **Scope F** ESLint naming-convention rules + Prettier/ESLint into pre-commit hook (4-step chain). **Scope G** validator 10th check (README ↔ state sync, deferred from MS-005). **Scope H** dependency policy. Plus **DEC-028..031** (directory structure, test layout, errors/logging, dependency policy) and state update for MS-006-in-progress.
- **Depends on:** MS-005 (DONE-005 signed 2026-04-28).
- **Linked RFIs / decisions:**
  - **New:** DEC-028 (directory structure), DEC-029 (test layout), DEC-030 (errors+logging), DEC-031 (dependency policy).
  - **Builds on:** DEC-026 (validator + 9 checks) — adds 10th check. DEC-024 (gitleaks) — adds env-var-name explicit rules. DEC-027 (code conventions) — Scopes A/C/D/H extend the "For agents reading the code" section.
  - **Doesn't touch:** RFI-010 (DONE sign-off — explicitly MS-007 scope). CONTEXT.md or prompts/ (MS-007 scope). RFI-009 (TLD).
- **Operator approval:** pending.

**Open items / Builder decisions to surface at MS-006 approval:**

1. **DEC numbering.** Last DEC: DEC-027. Builder will use DEC-028..031 sequentially for the four new entries (Scope A → DEC-028, Scope C → DEC-029, Scope D → DEC-030, Scope H → DEC-031). Per discipline #5, no skips.

2. **ESLint naming-convention rule risk (Scope F2 highest-risk item).** The `@typescript-eslint/naming-convention` rule produces false positives on:
   - Svelte 5 runes (`$state`, `$derived`, `$props`, `$bindable`, `$effect`) — these are special compiler-recognized variable names that look like camelCase with a `$` prefix.
   - SvelteKit conventions (`load`, `actions`, `+page.svelte` filename special characters).
   - File-suffix-based filenames like `+page.svelte`, `+layout.svelte`, `+server.ts` (the `+` prefix is non-standard).
   Builder approach: configure conservatively. Allow `$`-prefixed names. Allow `+` prefix on filenames via filename-pattern carve-out (or just don't enforce filename-name-convention via lint, leave that to manual review). Run on existing scaffold output; count false positives. If >5 (per Scope F2 explicit cap), RFI before shipping.

3. **Pre-commit hook chain (Scope F3).** Order: gitleaks → validator → Prettier → ESLint. Both Prettier and ESLint should run on STAGED files only (not whole repo) for performance. Builder approach: extract staged files via `git diff --cached --name-only --diff-filter=ACMR` and pass to `prettier --check` and `eslint`. Builder's only design choice here is whether to fail-fast across tools (one tool's fail aborts the rest) or run all four and report all failures. Standard `set -e` pattern fails-fast. Builder default: fail-fast (matches existing hook behaviour with gitleaks → validator).

4. **Hook synthetic violation tests (F4).** Mandatory per working agreement #8. Two tests: (a) ESLint violation, (b) Prettier violation. Builder will pick canonical violations:
   - **ESLint:** introduce a `let foo_bar = 1;` (snake_case variable, violates naming convention) in a temp scratch file under `src/`.
   - **Prettier:** introduce a deliberately mis-formatted file (long line, bad indent).
   For each: stage, attempt commit, observe BLOCKED with the correct tool's output, revert. Same revert-after-test pattern as MS-004 E1 / MS-005 chain-check tests.

5. **Validator G1 (README ↔ state) implementation approach.** Operator's spec: "Wording variation is allowed; the phase identifier ('Phase 0b complete', 'Phase 1') must match." Builder approach:
   - Parse `state/current.md` `## Phase` section, extract the `Current:` line content.
   - Extract a "phase identifier" from the Current line via regex: capture `Phase \w+` plus the next status word (e.g. "Phase 0b complete", "Phase 1 in progress", "Phase 1 blocked").
   - Parse `README.md` `## Status` section, extract the first non-empty line.
   - Apply the same phase-identifier extraction.
   - Compare. If both extract a `Phase X status` substring and they match (case-insensitive, whitespace-normalized), PASS. Otherwise FAIL with the operator's specified message format.
   - Falls back to PASS-with-warning if either parse fails (no `Phase` substring found) — better to surface a parse warning than a hard fail for a soft check, OR hard-fail per DEC-026 hard-fail-on-parse-error precedent. **Builder default: hard-fail on parse error**, matching DEC-026's existing pattern (the validator design is "fail closed on ambiguity"). Override at approval if operator wants soft.

6. **.gitleaks.toml E3 — env-var-name explicit rules.** Builder approach: add rules for `LEMON_SQUEEZY_WEBHOOK_SECRET`, `LICENSE_PRIVATE_KEY`, and similar that match the pattern `<NAME>=<non-placeholder-value>`. Need to allow placeholders (`replace_with_real_secret`, `replace_with_base64_ed25519_private_key`). Implementation: regex like `LEMON_SQUEEZY_WEBHOOK_SECRET=(?!replace_)[a-zA-Z0-9_+/=-]{20,}`, and explicit allowlist entries for the placeholder strings.

7. **Validator size budget (Scope G4).** Currently 237. G1 budget: +30. Target: ≤270. Builder will track during implementation; if G1 implementation pushes past 270, RFI per Scope G4 + working agreement #10.

8. **Vitest + Playwright config check (Scope C2/C3).** SvelteKit scaffold may already have correct globs. Builder will inspect first; if defaults match the convention, no edit needed (note in SITE_LOG). If defaults need adjustment, edit + note in SITE_LOG.

9. **Working agreement #11 to fold in at this sign-out.** Operator introduced #11 in DONE-005 sign-off: "Engineer prompts to Builder reflect committed file state, not chat-discussion state. References to prior 'H1, H2, H2a' or similar inline-discussion labels are valid in chat but should not be replicated in prompts to Builder unless those labels also exist in committed files. When referencing prior decisions, cite the DEC/MS/INC number, not the chat-message annotation."

**Plan (numbered, terse, scope-letter order):**

*Scope A — directory structure (PROJECT.md subsection + skeleton dirs):*
1. Append "Code directory structure" subsection to PROJECT.md "For agents reading the code" section per A1 verbatim.
2. Create skeleton: `src/lib/{auth,chat,crisis,persona,storage,shared,server}/.gitkeep`, `src/routes/api/.gitkeep`, `test/fixtures/.gitkeep`, `test/e2e/.gitkeep`.
3. Update `.gitignore` to add `test/fixtures/private/`.

*Scope B — naming conventions verify-only:*
4. Confirm naming conventions from MS-005 still present in PROJECT.md "For agents reading the code" → "Naming conventions" subsection. No duplication. Note "verified, no edit" in SITE_LOG.

*Scope C — test layout:*
5. Append "Test layout" subsection to PROJECT.md "For agents reading the code" per C1 verbatim.
6. Verify Vitest config (`vite.config.ts` since sv 0.15.1 puts vitest config there or in `vitest.config.ts`). Adjust glob to `src/**/__tests__/**/*.test.ts` if needed.
7. Verify Playwright config. Adjust `testDir` to `test/e2e/` if needed.

*Scope D — errors and logging:*
8. Append "Errors and logging" subsection to PROJECT.md "For agents reading the code" per D1 verbatim.

*Scope E — environment configuration:*
9. Create `.env.example` at repo root per E1 verbatim with placeholder values.
10. Confirm `.gitignore` already has `.env`, `.env.*` patterns from MS-003 scaffold + MS-003 union. Add any missing.
11. Update `.gitleaks.toml`: add explicit rules for `LEMON_SQUEEZY_WEBHOOK_SECRET` and `LICENSE_PRIVATE_KEY` that match non-placeholder values; extend allowlist with `replace_with_real_secret`, `replace_with_base64_ed25519_private_key`.

*Scope F — code-style enforcement:*
12. Verify `eslint.config.js` and `.prettierrc` from MS-003 scaffold are present.
13. Add `@typescript-eslint/naming-convention` rule to `eslint.config.js` configured per Scope B + carve-outs for Svelte 5 runes (`$`-prefix), SvelteKit special filenames (`+`-prefix). Run `npm run lint` against existing scaffold; count false positives. If >5, RFI before continuing. If ≤5, ship.
14. Update `.githooks/pre-commit`: add Prettier --check and ESLint steps after validator. Both run on staged files only via `git diff --cached --name-only --diff-filter=ACMR`. Fail-fast pattern.
15. Test the hook: synthetic ESLint violation → confirm BLOCKED → revert. Synthetic Prettier violation → confirm BLOCKED → revert. Document both tests in SITE_LOG.
16. Verify npm scripts (`lint`, `format`, `format:check`) exist in `package.json`. Add if missing.

*Scope G — validator 10th check:*
17. Add G1 check to `scripts/validate.sh`: parse state/current.md `## Phase` Current line, extract `Phase X status`; parse README.md `## Status` first non-empty line, extract `Phase X status`; compare. Hard-fail on parse error per Builder default in Open Item 5.
18. Update validator header comments to enumerate 10 checks (was 9).
19. Synthetic violation test (Scope G2): edit state/current.md Current line to "Phase 99 in progress", run validator, confirm FAIL with operator's message format, revert, run validator, confirm PASS.
20. Update PROCEDURES.md Procedure 9: remove the "trust-based discipline pending future enforcement" note about README ↔ state sync — now mechanical.

*Scope H — dependency policy:*
21. Append "Dependency policy" subsection to PROJECT.md "For agents reading the code" per H1 verbatim.

*Scope I — state update + sign-out:*
22. Update `state/current.md`:
    - Bump Updated timestamp.
    - Phase line: "Phase 0b complete. Infrastructure phase in progress (MS-006). Phase 1 blocked on MS-007."
    - Active MS: MS-006. MS-005 marked DONE.
    - Counters: Latest MS=MS-006, Latest DEC=DEC-031, Latest INC=INC-006 (unchanged), Latest RFI=RFI-010 (unchanged).
    - MS chain status: MS-005 DONE, MS-006 in progress, MS-007 pending depends on MS-006, [first Phase 1 MS] pending depends on MS-007.
    - Add engineer working agreement #11 to running list.
    - Update last-verified-state with MS-006 results.

*Scope J — DEC entries:*
23. File DEC-028 (directory structure), DEC-029 (test layout), DEC-030 (errors and logging), DEC-031 (dependency policy) per J1–J4 verbatim.

*Sign-out + commit:*
24. Final validator run: PASS.
25. Sign-out entry in SITE_LOG using new template. Validator PASS, state/current.md updated YES.
26. `git add . && git commit -m "MS-006: code structure + dev tooling"`. Pre-commit hook fires gitleaks + validator + Prettier + ESLint; all four must pass. Push.
27. File DONE-006 with proof. Commit + push close-out.

**Files to be touched:**
- `Desktop/UnoAi/PROJECT.md` — modified (4 new subsections under "For agents reading the code": Code directory structure, Test layout, Errors and logging, Dependency policy).
- `Desktop/UnoAi/PROCEDURES.md` — modified (Procedure 9 trust-based-disclaimer removed; README ↔ state now mechanical).
- `Desktop/UnoAi/.gitignore` — modified (add `test/fixtures/private/`).
- `Desktop/UnoAi/.env.example` — created.
- `Desktop/UnoAi/.gitleaks.toml` — modified (env var rules + placeholder allowlist).
- `Desktop/UnoAi/.githooks/pre-commit` — modified (Prettier + ESLint steps after validator).
- `Desktop/UnoAi/eslint.config.js` — modified (naming-convention rules + Svelte 5 / SvelteKit carve-outs).
- `Desktop/UnoAi/scripts/validate.sh` — modified (G1 README ↔ state check, 10th check; target ≤270 lines).
- `Desktop/UnoAi/forms/DECISION.md` — modified (DEC-028..031 appended).
- `Desktop/UnoAi/forms/METHOD_STATEMENT.md` — modified (this MS-006 entry; approval status update post-approval).
- `Desktop/UnoAi/forms/SITE_LOG.md` — modified (sign-in already filed; sign-out at session close).
- `Desktop/UnoAi/forms/DONE.md` — modified (DONE-006 appended).
- `Desktop/UnoAi/state/current.md` — modified (counters, MS chain section, agreement #11, phase line).
- `Desktop/UnoAi/src/lib/{auth,chat,crisis,persona,storage,shared,server}/.gitkeep` — created (7 files).
- `Desktop/UnoAi/src/routes/api/.gitkeep` — created.
- `Desktop/UnoAi/test/fixtures/.gitkeep` — created.
- `Desktop/UnoAi/test/e2e/.gitkeep` — created.
- `Desktop/UnoAi/vite.config.ts` OR `Desktop/UnoAi/vitest.config.ts` — possibly modified (Vitest glob if scaffold default doesn't match convention).
- `Desktop/UnoAi/playwright.config.ts` — possibly modified (testDir if scaffold default doesn't match).
- `Desktop/UnoAi/package.json` — possibly modified (npm scripts if missing).

**Files NOT touched (per scope):**
- `forms/CHANGE_ORDER.md`, `forms/RFI.md` (no new RFIs except possibly mid-MS for Open Items 2/5/7), `forms/INCIDENT.md` (unless violation testing finds one), `LICENSE`, `CONTRIBUTING.md`, `PLAN.md`, `README.md`. SvelteKit scaffold src files (`src/app.html`, `src/app.d.ts`, etc.). All existing demo/route files from sv scaffold.

**Expected diff size:** ~500 lines net added across ~15 files. Most lines are PROJECT.md doc additions (Scopes A/C/D/H subsections) + .env.example + validator G1 check + DEC-028..031 entries. No product code.

**Risks identified:**

- **R1. Open Item 2 — ESLint false positives.** Highest-risk item. Builder runs lint after rule addition; counts false positives; RFIs if >5. Mitigation: conservative initial config + explicit Svelte 5 carve-outs.

- **R2. Hook chain ordering / staged-files extraction.** Prettier and ESLint must run on staged files only. Builder uses `git diff --cached --name-only --diff-filter=ACMR` filtered to relevant extensions (`.ts`, `.js`, `.svelte`). If no relevant files staged, both tools skip.

- **R3. Validator G1 phase-extraction regex robustness.** Edge cases: state line has multiple "Phase" mentions (e.g. "Phase 0b complete. Phase 1 blocked..." → which one is the "current" phase?). Builder picks the FIRST `Phase X status` substring. README's first non-empty Status line should match the first phase mention. If state has multi-phase descriptors, the convention is "current phase first," and the validator enforces that ordering implicitly.

- **R4. SvelteKit scaffold default configs may differ from operator's convention.** Vitest glob and Playwright testDir may need explicit setting. Builder verifies before editing.

- **R5. Hook chain failure modes — fail-fast vs report-all.** Builder default fail-fast (matches existing hook). Operator can override to report-all if preferred. Practical impact small for solo developer; aesthetic preference.

- **R6. Validator size at 237 + ~30 G1 budget = ~267.** Within 270 cap. Comfortable. If actual G1 implementation runs longer, RFI per Scope G4.

- **R7. Working agreement #11 numbering.** Operator's DONE-005 sign-off introduced #11. State currently has #1–#10. Adding #11 sequential. No drift this time.

- **R8. .gitleaks.toml additions may produce false positives on `.env.example`** because `.env.example` contains `LEMON_SQUEEZY_WEBHOOK_SECRET=replace_with_real_secret` which matches the rule pattern unless explicitly allowlisted. Builder ensures placeholder values are in the allowlist before testing.

- **R9. The `+`-prefixed SvelteKit filenames** (`+page.svelte`, `+layout.svelte`, `+server.ts`) violate kebab-case. Builder's ESLint config must allow these via filename-pattern carve-out OR Builder doesn't enforce filename naming via lint (leave to manual review). Cleanest option: don't ESLint filenames (the framework dictates these), only ESLint identifiers within files. Builder default: identifier-only naming-convention rule, no filename rule.

- **R10. .gitkeep files** are conventional placeholders for empty directories. They're zero-byte files (or contain a comment). gitleaks will scan them; should not flag. Builder confirms by running gitleaks pre-commit.

**Acceptance criteria (will be copied verbatim into DONE-006):**
- `PROJECT.md` "For agents reading the code" section has 4 new subsections (Code directory structure, Test layout, Errors and logging, Dependency policy) per Scopes A1/C1/D1/H1 verbatim.
- Directory skeleton created: `src/lib/{auth,chat,crisis,persona,storage,shared,server}/.gitkeep`, `src/routes/api/.gitkeep`, `test/fixtures/.gitkeep`, `test/e2e/.gitkeep`.
- `.gitignore` includes `test/fixtures/private/`.
- `.env.example` created at repo root per Scope E1 verbatim with placeholder values.
- `.gitleaks.toml` updated with explicit rules for `LEMON_SQUEEZY_WEBHOOK_SECRET` and `LICENSE_PRIVATE_KEY`; placeholder-value allowlist extended.
- `eslint.config.js` updated with naming-convention rules; lint run produces ≤5 false positives on existing scaffold (or RFI was filed).
- `.githooks/pre-commit` runs gitleaks → validator → Prettier --check (staged files) → ESLint (staged files). All four must PASS.
- Hook test: ESLint violation BLOCKED, Prettier violation BLOCKED, both revert + commit succeeds.
- `scripts/validate.sh` has 10 checks; G1 README ↔ state check works; synthetic violation FAIL captured. Validator size ≤270.
- `PROCEDURES.md` Procedure 9 — README ↔ state sync no longer trust-based; validator enforces.
- `forms/DECISION.md` has DEC-028 (directory structure), DEC-029 (test layout), DEC-030 (errors+logging), DEC-031 (dependency policy).
- `state/current.md` updated: Latest MS=MS-006, Latest DEC=DEC-031, MS-005 DONE, MS-006 in progress, agreement #11 added, phase line current.
- Sign-in (filed at session start) and sign-out (at session end) entries in SITE_LOG using Procedure 9 templates.
- Validator pre-commit run: PASS. Hook fires all four steps on actual MS-006 commit.
- Push to GitHub succeeds. Final commit visible at the repo URL.
- DONE-006 contains: validator PASS output, G1 synthetic FAIL output verbatim, hook output from MS-006 commit (showing all four steps), ESLint/Prettier hook test outputs, file-by-file change summary.

**Operator approval:** APPROVED 2026-04-28.
**Approval notes:**
- **Open Item 1 (DEC numbering DEC-028..031):** Approved sequential per discipline #5.
- **Open Item 2 (ESLint naming-convention rule risk):** Approved Builder approach (identifier-only rule, $-prefix carve-out for Svelte 5 runes, no filename naming via lint, <5 false-positive threshold). Pre-approved additional carve-out for SvelteKit `load`/`prerender`/`ssr`/`csr` exports if they trip the rule (didn't trip — already camelCase). Result: **0 false positives** on existing scaffold. Comfortably under threshold.
- **Open Item 3 (G1 phase-extraction hard-fail vs soft-fail):** Approved hard-fail. Format-spec comment added at top of `state/current.md` documenting expected line format.
- **Open Item 4 (hook chain failure mode):** Approved fail-fast. Matches existing hook pattern.
- **Open Item 5 (`+`-prefix filenames):** Approved framework-filename exception. One-sentence note added to PROJECT.md naming-conventions section.
- **Working agreement #11 verbatim into state/current.md:** Approved. No paraphrase. Folded in alongside the rest of the working-agreements list.
- **Validator size:** ended at **277 lines** (8 over Scope G4's 270 cap). Same overrun pattern as MS-005 — block-aware parsing requires more lines than per-check estimate. Consistent with working agreement #10 (caps calibrated against existing complexity, not new check). Surfaced in DONE-006 for design-review at sign-off.
- **Two real bugs caught and fixed during F4 testing**, neither shipped:
  1. ESLint rule severity was `'warn'` initially — pre-commit hook didn't block on warnings (ESLint exits 0). First synthetic test commit landed accidentally at SHA `7d4b513`. Reset via `git reset HEAD~1` (mixed). Fix: rule severity → `'error'`. Second synthetic test correctly blocked.
  2. gitleaks rule `lemon-squeezy-webhook-secret` had its capture group around the LABEL not the VALUE — value-based placeholder allowlist didn't trigger. Restructured to capture the value; `.env.example` and METHOD_STATEMENT.md prose mentions now allowlist-clean.
- **Vitest + Playwright config:** Builder verified scaffold defaults are a permissive superset of the convention (Vitest glob `src/**/*.{test,spec}.{js,ts}` catches `__tests__/` paths plus more; Playwright `testMatch: **/*.e2e.{ts,js}` permissive). No edits needed; convention enforced at review level. Tightening deferred until sv scaffold demo files are removed in a future MS.
- **Markdown + state/ added to .prettierignore:** PROJECT.md, PROCEDURES.md, PLAN.md, README.md, all forms, state/current.md are author-formatted. Prettier reformatting them would mangle tables, blockquotes, numbered lists, and intentional whitespace. Builder-runtime decision; documented inline in `.prettierignore`.

---

### MS-007 — Agent onboarding + Engineer prompt-writing checklist + RFI-010 resolution
- **Date:** 2026-04-28
- **Agent:** Reaper-1
- **Phase:** 0b infrastructure layer (post-MS-006, pre-MS-008)
- **Session start:** 2026-04-28 03:30 (see SITE_LOG)
- **Task:** Four scopes covering agent-facing onboarding infrastructure. **Scope A** `prompts/engineer-session-start.md` (the prompt operator pastes at the start of a fresh Engineer session) + cross-references to it from README and PROJECT.md. **Scope B** `CONTEXT.md` at repo root (agent-onboarding-focused, distinct from PROJECT.md/README.md) + file-map listing. **Scope C** `prompts/engineer-prompt-checklist.md` (mechanical fix for working agreements #5/#10/#11 drift) + Procedure 1 cross-reference. **Scope D** RFI-010 closure via DEC-032 (magic-string-in-chat sign-off recording) + DONE.md template annotation + deferred 11th validator check note. **Scope E** state update with working agreements #12/#13/#14, MS-006 → DONE, MS-007 → in progress.
- **Depends on:** MS-006 (DONE-006 signed 2026-04-28).
- **Linked RFIs / decisions:**
  - **New:** DEC-032 (DONE sign-off recording mechanism — closes RFI-010).
  - **Closes:** RFI-010 via DEC-032.
  - **Doesn't touch:** validator script (Scope D3 explicitly defers the 11th check to MS-008+); CI/CD; product code. RFI-009 (TLD) remains open, not blocking.
- **Operator approval:** pending.

**Open items / Builder decisions to surface at MS-007 approval:**

1. **DEC numbering DEC-032.** Sequential after DEC-031 per discipline #5. Working-agreement-#1 verification done at sign-in: DEC-031 confirmed highest in DECISION.md; RFI-010 confirmed open in RFI.md.

2. **Operator-supplied content verbatim (Scopes A2, B1, C1).** Builder's rules of engagement say "do not paraphrase or improve" for Engineer session-start prompt, CONTEXT.md, and Engineer prompt-writing checklist. Builder will copy verbatim. Builder-runtime adjustments limited to: (a) markdown rendering coherence (heading levels, code-fence languages, list indentation), (b) absolute-path fixes if any (e.g. relative paths within the markdown that Builder needs to verify resolve to actual files in the repo). If any wording adjustment seems needed, Builder will RFI rather than edit.

3. **Engineer-session-start prompt references `/mnt/skills/user/eco-agentic-doctrine/SKILL.md` (Anthropic-environment paths).** The prompt itself acknowledges this with the disclaimer "If running in a different environment, the doctrine source needs to be located there first." Self-aware. Builder copies verbatim. No action.

4. **PROJECT.md cross-reference placement (Scope A4).** Operator says "near the top after the organising-principle line." The organising-principle line is the blockquoted paragraph at the top of PROJECT.md added in MS-004 H1. Builder will place the cross-reference sentence immediately after that blockquote, before the existing `---` separator.

5. **README.md cross-reference placement (Scope A3).** Operator says "before step 1" of "For agents working on this project". Builder will insert the sentence immediately above step 1 (currently `Read PROJECT.md`).

6. **PROCEDURES.md update for engineer-prompt-checklist (Scope C2).** Operator gives Builder choice: "in Procedure 1 (read PROJECT.md before session) or as a new sub-procedure." Builder picks **add a note in Procedure 1** rather than introducing a sub-procedure or new numbered procedure — adding a Procedure 10 would also bump the "Nine procedures" count to ten and require sweep across README ("the nine rules" → "the ten rules"), Procedure summary table, etc. The note in Procedure 1 stays under existing structure. The fact that the Engineer reads the prompt-checklist before writing prompts is essentially a sub-task of Procedure 1's "Read PROJECT.md and PROCEDURES.md and state/current.md" induction, not a separate procedure with its own form template.

7. **Existing DONE-002..006 sign-off lines (Scope D2).** Per operator: "Existing DONE-002 through DONE-006 entries: leave as 'pending' for now. Retroactive sign-off marking is operator's call at MS-008 deep-check time." Builder does not touch these in MS-007. The DONE.md template annotation in Scope D2 applies to FUTURE DONE entries.

8. **Validator 11th check deferral (Scope D3).** Builder will add a comment block to the validator script header noting the deferred 11th check (DONE sign-off enforcement) per DEC-032. No actual check code added in this MS. The validator stays at 277 lines + a few documentation lines.

9. **Working agreements #12/#13/#14 verbatim.** Per operator's DONE-006 sign-off, all three agreement texts are operator-supplied with exact wording. Builder copies verbatim into state/current.md "Engineer working agreements" section. Same posture as #11 fold-in pattern. No paraphrase, no Builder-renumber surprises (operator wrote #12/#13/#14 sequentially correctly this time).

10. **The Engineer prompt-checklist (Scope C1) covers working agreements #1, #2, #4, #5, #6, #10, #11, #13, #14 by inline citation.** Agreements #3 (wc -l snapshot), #7 (bash budget framing), #8 (synthetic tests), #9 (mechanical sign-off verification), and #12 (HTML cache vs git) are not explicitly cited in the checklist's items — though #12 is the underlying principle behind item 13 (which cites #14). Operator's checklist content is operator-reviewed; Builder copies verbatim. If operator wants additional items for #3/#7/#8/#9/#12, paste the wording at approval.

**Plan (numbered, terse, scope-letter order):**

*Scope A — prompts/engineer-session-start.md + cross-refs:*
1. Create `prompts/` directory at repo root.
2. Create `prompts/engineer-session-start.md` with operator's Scope A2 content verbatim. Two top-level headings: "How to use this file" and "The prompt." All sub-content nested appropriately.
3. Add cross-reference sentence to README.md "For agents working on this project" immediately above step 1 (per Scope A3).
4. Add cross-reference sentence to PROJECT.md immediately after the organising-principle blockquote (per Scope A4).

*Scope B — CONTEXT.md:*
5. Create `CONTEXT.md` at repo root with operator's Scope B1 content verbatim.
6. Add `CONTEXT.md` to README.md file map (under root files alongside `PROJECT.md`, `PLAN.md`, `PROCEDURES.md`).

*Scope C — Engineer prompt-writing checklist:*
7. Create `prompts/engineer-prompt-checklist.md` with operator's Scope C1 content verbatim.
8. Add note to PROCEDURES.md Procedure 1 referencing the prompt-writing checklist for Engineer-role sessions.

*Scope D — RFI-010 resolution + DEC-032:*
9. File DEC-032 in DECISION.md with operator's Scope D4 content (DONE sign-off recording mechanism). Closes RFI-010.
10. Update RFI-010 status in RFI.md to `ANSWERED 2026-04-28 via DEC-032`.
11. Update DONE.md template "Operator sign-off:" annotation per Scope D2 (annotate that operator's chat magic-string gets copied verbatim by Builder at next session sign-in).
12. Add a comment block to `scripts/validate.sh` header documenting the deferred 11th check (DONE sign-off enforcement) per Scope D3.

*Scope E — state update + sign-out:*
13. Update `state/current.md`:
    - Bump Updated timestamp.
    - Phase line: "Phase 0b complete. Infrastructure phase in progress (MS-007). Phase 1 blocked on MS-008."
    - Active MS: MS-007. MS-006 marked DONE.
    - Counters: Latest MS=MS-007, Latest DEC=DEC-032, Latest INC=INC-006 (unchanged), Latest RFI=RFI-010 (unchanged — still highest, just status changes).
    - MS chain status: MS-006 DONE, MS-007 in progress, MS-008 pending depends on MS-007, [first Phase 1 MS] pending depends on MS-008.
    - Add engineer working agreements #12/#13/#14 verbatim from DONE-006 sign-off.
    - Update last-verified-state with MS-007 results.
14. Sign-out entry in SITE_LOG using the new template.

*Sign-out + commit:*
15. Final validator run: PASS.
16. `git add . && git commit -m "MS-007: agent onboarding + prompt checklist + RFI-010 resolution"`. Hook fires gitleaks + validator + Prettier + ESLint; all four must pass. Push.
17. File DONE-007 with proof. Commit + push close-out.

**Files to be touched:**
- `Desktop/UnoAi/prompts/engineer-session-start.md` — created.
- `Desktop/UnoAi/prompts/engineer-prompt-checklist.md` — created.
- `Desktop/UnoAi/CONTEXT.md` — created at repo root.
- `Desktop/UnoAi/README.md` — modified (cross-reference + file-map CONTEXT.md entry).
- `Desktop/UnoAi/PROJECT.md` — modified (cross-reference after organising-principle line).
- `Desktop/UnoAi/PROCEDURES.md` — modified (Procedure 1 note about prompt-writing checklist for Engineer sessions).
- `Desktop/UnoAi/scripts/validate.sh` — modified (header comment documenting deferred 11th check). No actual check code added.
- `Desktop/UnoAi/forms/DECISION.md` — modified (DEC-032 appended).
- `Desktop/UnoAi/forms/RFI.md` — modified (RFI-010 status update).
- `Desktop/UnoAi/forms/DONE.md` — modified (template "Operator sign-off:" annotation; DONE-007 appended at session close).
- `Desktop/UnoAi/forms/METHOD_STATEMENT.md` — modified (this MS-007 entry; approval status update post-approval).
- `Desktop/UnoAi/forms/SITE_LOG.md` — modified (sign-in already filed; sign-out at session close).
- `Desktop/UnoAi/state/current.md` — modified (counters, MS chain, agreements #12/#13/#14, phase line, last-verified-state).

**Files NOT touched (per scope):**
- `forms/CHANGE_ORDER.md`, `forms/INCIDENT.md` (no incidents expected — no synthetic tests in this MS).
- `LICENSE`, `CONTRIBUTING.md`, `PLAN.md`, `.gitignore`, `.gitleaks.toml`, `.githooks/pre-commit`, `eslint.config.js`, `package.json`, `.prettierignore`, `.prettierrc`, scaffold config files, `src/`, `static/`, `test/`. SvelteKit scaffold tree.
- Existing DONE-002..006 entries (per operator instruction, retroactive sign-off marking is MS-008 work).

**Expected diff size:** ~250 lines net added across ~13 files. ~70% is operator-supplied prompt/checklist/context content copied verbatim. No code, no dependencies, no validator changes.

**Risks identified:**

- **R1. Verbatim copy of operator-supplied content.** Three files contain ~200+ lines of operator-supplied text. Risk: typo or paste error. Mitigation: Builder will copy via heredoc/Write tool with explicit content matching operator's prompt body exactly. Post-write `diff` against operator's spec (mentally — there's no machine-readable spec) for a final verify.

- **R2. PROJECT.md cross-reference placement adjacent to existing organising-principle line.** The current organising-principle is a blockquote (` > This project is built by AI agents...`). The new cross-reference is plain text. Builder will place it as a separate paragraph after the blockquote, before the `---` separator that follows. Tested mentally; should render cleanly.

- **R3. README.md cross-reference placement.** "Before step 1" of the numbered list. Markdown numbered lists may auto-renumber when items are inserted. Builder's insertion is a sentence-level paragraph BEFORE the list, not a list item, so numbering should not shift.

- **R4. PROCEDURES.md "Nine procedures" sweep.** No new procedure added (Builder picks add-note-to-Procedure-1 over add-Procedure-10 per Open Item 6). Header "Nine procedures" stays. Summary table stays at 9 rows. README "the nine rules" stays. No sweep needed.

- **R5. DEC-032 closes RFI-010 — verify RFI-010 is open.** Already verified at sign-in (working agreement #1 compliance). Listed in SITE_LOG sign-in entry.

- **R6. Validator deferred-check documentation.** Adding ~10 lines of comment to `scripts/validate.sh` header. Validator goes from 277 → ~287 lines. Still well above operator's now-retired 270 cap, but per working agreement #10, caps are no longer hard limits. No RFI needed.

- **R7. State update timing.** Per Scope I-early pattern from MS-006 (where state was bumped mid-session so validator could pass during synthetic tests), this MS doesn't have synthetic tests. State update happens at sign-out. Validator should pass throughout because no MS-007 entries are filed in METHOD_STATEMENT.md until this approval lands and Scope D's DEC-032 is filed — which will require state counter bumping in tandem.

- **R8. RFI-010 closure body text.** Operator's Scope D4 content includes `Closes: RFI-010` line. Builder's job is to verify the close target exists in RFI.md (working agreement #1) — already done.

- **R9. CONTEXT.md content references "the nine procedures" via PROCEDURES.md.** Wait — no, CONTEXT.md says "For procedure: read PROCEDURES.md." Doesn't cite a count. Safe from any rule-count drift. ✓

**Acceptance criteria (will be copied verbatim into DONE-007):**
- `prompts/engineer-session-start.md` exists with operator's Scope A2 content verbatim. ✓
- `prompts/engineer-prompt-checklist.md` exists with operator's Scope C1 content verbatim. ✓
- `CONTEXT.md` exists at repo root with operator's Scope B1 content verbatim. ✓
- `README.md` has cross-reference to `prompts/engineer-session-start.md` before step 1; file map includes `CONTEXT.md`.
- `PROJECT.md` has cross-reference to `prompts/engineer-session-start.md` after the organising-principle blockquote.
- `PROCEDURES.md` Procedure 1 has a note about the Engineer prompt-writing checklist.
- `scripts/validate.sh` header comments document the deferred 11th check (DONE sign-off enforcement).
- `forms/DECISION.md` has DEC-032 (DONE sign-off recording mechanism — magic-string-in-chat). Closes RFI-010.
- `forms/RFI.md` shows RFI-010 status `ANSWERED 2026-04-28 via DEC-032`.
- `forms/DONE.md` template has updated annotation on the "Operator sign-off:" line per Scope D2.
- `state/current.md` updated: Latest MS=MS-007, Latest DEC=DEC-032, MS-006 DONE, MS-007 in progress, MS-008 pending, agreements #12/#13/#14 added, phase line current.
- Sign-in (filed) and sign-out (at session end) entries in SITE_LOG using Procedure 9 templates.
- Validator pre-commit run: PASS. Hook fires all four steps on MS-007 commit.
- Push to GitHub succeeds.
- DONE-007 contains: validator PASS output, hook output verbatim from MS-007 commit, file-by-file change summary, GitHub URLs.

**Operator approval:** APPROVED 2026-04-28.
**Approval notes:**
- **Open Item 1 (DEC numbering DEC-032):** Approved sequential per discipline #5. Working-agreement-#1 verification done at sign-in.
- **Open Item 2 (operator-supplied content verbatim):** Approved. Builder copied operator's Scope A2 / B1 / C1 content as-is. Friendly amendment opportunity flagged at approval was taken (one-paragraph scope-note added at top of Engineer prompt-checklist clarifying it covers prompt-writing only — DONE sign-off and Builder-execution disciplines stay in their own domains).
- **Open Item 6 (Procedure 1 vs new sub-procedure):** Approved Builder default — note inside Procedure 1 as Engineer-role addendum. The Engineer reading the checklist before writing a prompt is structurally a sub-task of Procedure 1's induction read, not a new procedure category. Procedure count stays at nine.
- **Open Item 7 (existing DONE sign-off lines):** Approved — DONE-002..006 stay "pending" in MS-007. Retroactive sign-off marking is MS-008 Section 5 work (form integrity audit).
- **Open Item 10 (checklist citation completeness):** Approved Builder's reading. Agreements #3/#7/#8 are Builder-execution disciplines; #9/#12 apply to DONE sign-off (with #14 the actionable form of #12). Friendly amendment scope-note added at top of checklist clarifying the prompt-writing-only scope and pointing future Engineers at the right places for the other domains.
- **DEC-032 closes RFI-010** verified — RFI-010 was open in `forms/RFI.md` at sign-in time per working agreement #1.
- **Validator stays at ~287 lines** (header comment for deferred check 11 added). No code changes. Per working agreement #10, no hard cap. No synthetic test required since no tooling enforces a new discipline (working agreement #8 only triggers when tooling is added).
- **Working agreements #12/#13/#14** added to state/current.md verbatim from DONE-006 sign-off. Operator's sequential numbering correct this time; no Builder renumber needed.

---

### MS-008 — Glossary + spell-check tooling + Procedure 3 doc-only-MS fix
- **Date:** 2026-04-28
- **Agent:** Reaper-1
- **Phase:** 0b infrastructure layer (post-MS-007, pre-MS-009 deep check)
- **Session start:** 2026-04-28 04:30 (see SITE_LOG)
- **Task:** Three scopes combined. **Scope A** `GLOSSARY.md` at repo root (~50 alphabetical entries, operator-supplied) + cross-references in README, prompts/engineer-session-start.md, CONTEXT.md. **Scope B** install `cspell` as devDependency + `.cspell.json` config + 5th step in pre-commit hook (gitleaks → validator → Prettier → ESLint → cspell, all on staged files) + first-run cleanup + synthetic violation test. **Scope C** small clarification to PROCEDURES.md Procedure 3 about doc-only MSes (no DEC needed; SITE_LOG-documented procedural drift across 7 MSes). Plus DEC-033 (spell-check tooling locked) and state update with working agreement #14 refinement.
- **Depends on:** MS-007 (DONE-007 signed 2026-04-28; magic-string copied verbatim into entry per DEC-032 first-exercise at this session sign-in).
- **Linked RFIs / decisions:**
  - **New:** DEC-033 (spell-check tooling locked).
  - **Builds on:** DEC-024 (gitleaks hook), DEC-026 (validator + checks), DEC-031 (dependency policy — cspell install requires DEC-033 per the policy).
  - **Doesn't touch:** validator script (cspell is separate from validator); RFI-010 (closed); RFI-009 (TLD, still open). DONE-002..006 retroactive sign-off cleanup explicitly deferred to MS-009 Section 5 per Scope D2 of MS-007.
- **Operator approval:** pending.

**Open items / Builder decisions to surface at MS-008 approval:**

1. **Glossary coverage gaps (Scope A4 RFI per operator).** Builder ran a grep for project-specific terms used across 2+ files but not present in operator's Scope A2 glossary content. Three real gaps found:
   - **Vitest** — used in 17 files (test framework). Operator's content has `vitest` in cspell words list but no glossary entry.
   - **synthetic test** — used in ~10 files (Builder discipline, working agreement #8). No glossary entry.
   - **validator size budget** — used across 5+ MSes / DONEs (operator's working-agreement-#10 framing). No glossary entry.
   
   Builder default per operator's RFI instruction: **flag at approval, do NOT add silently.** If operator wants these added, paste wording at approval. Otherwise Builder ships glossary as Scope A2 content + adds an "(MS-008 coverage RFI deferred)" footnote.

2. **US/UK divergence in existing files (Scope B `language: en-GB`).** Operator's prompt note: "matches operator's UK English usage (already consistent across the repo per Engineer's verification of PROCEDURES.md)." Builder's pre-flight grep finds the premise empirically false:
   - **"behaviour"** appears in PROJECT.md (3×), METHOD_STATEMENT.md, prompts/engineer-session-start.md (1×). en-GB will flag all 5+ instances as misspellings expecting "behaviour."
   - **"organize" / "organizing"** appears in DONE.md (4×), DECISION.md (1×). en-GB will flag.
   - "color/colour" — no findings.
   - "license/licence" — uses "license" (correct as the proper noun in "PolyForm Noncommercial License" + license-as-verb; en-GB tolerates "license" for verb form).
   
   Three paths:
   - **(a) Stay en-GB, fix existing US spellings as part of MS-008 first-run cleanup (Scope B5).** Per operator's intent (en-GB explicitly chosen), US instances ARE the typos. ~10 fixes. Builder default.
   - **(b) Switch to `language: "en"` (or add `en-US` to languageId allowlist).** Tolerates both spellings; loses the en-GB consistency goal.
   - **(c) Add explicit US-allow words to `.cspell.json` (`behaviour`, `organize`, etc.).** Hybrid; convoluted.
   
   Builder default: **(a)**. Surface for operator override. The "30-80 more terms" first-run estimate from the operator's prompt is likely understated given the en-GB+US-spelling overlap; expect closer to 50-150 items, most of which are project terms or US spellings rather than real typos.

3. **DEC-033 numbering and cspell version.** DEC-033 sequential after DEC-032 (verified at sign-in). Builder will install `cspell` and capture the actual installed version (currently `cspell@10.0.0` per pre-flight `npx cspell --version`). DEC-033 body cites the installed version + npm devDependencies entry.

4. **Pre-commit hook chain order (Scope B4): gitleaks → validator → Prettier → ESLint → cspell, fail-fast on staged .md files.** Builder default matches operator's spec. cspell runs only on staged `.md` files via `git diff --cached --name-only --diff-filter=ACMR | grep '\.md$' | xargs -r npx cspell --no-summary`. If no .md files staged, cspell skips (matches Prettier/ESLint behaviour in MS-006 hook).

5. **Glossary content "operator-reviewed" verbatim posture.** Same as MS-007 prompts and CONTEXT.md. Builder may refine wording for grammar/flow; substantive changes require RFI. Builder will copy operator's Scope A2 content as-is, with the three coverage-gap entries flagged in #1 either added (per operator approval) or omitted (default).

6. **DONE-007 sign-off magic-string applied at session sign-in.** Mechanical pre-approved action per operator's MS-008 procedure step 2. Already done at sign-in: DONE-007 line 951 updated from `Operator sign-off: pending` to `Operator sign-off: DONE-007 signed off by operator on 2026-04-28`. First real exercise of DEC-032. Existing DONE-002..006 stay pending per Scope D2 of MS-007 (retroactive cleanup is MS-009 Section 5 work).

7. **Working agreement #14 refinement** lands at this sign-out per operator's instruction in DONE-007 sign-off. Replaces existing #14 entry in state/current.md.

8. **B5 first-run categorization process.** Operator says: "(a) project-specific terms missing → ADD to dictionary, (b) real typos → FIX, (c) false positives on technical terms → ADD to dictionary." Builder will go through each flagged item; RFI ambiguous cases. Output documented in SITE_LOG: "cspell first run flagged N items — X added to dictionary, Y fixed as typos, Z left for operator review."

9. **Procedure 3 fix (Scope C) is a clarification, not a new decision.** No DEC needed. SITE_LOG note documents the practice-and-procedure drift for 7 MSes (MS-001 through MS-007 all doc-only). Builder applies operator's exact wording from Scope C1.

**Plan (numbered, terse, scope-letter order):**

*Scope A — GLOSSARY.md:*
1. Create `GLOSSARY.md` at repo root with operator's Scope A2 content verbatim (modulo Open Item 1's coverage-gap resolution at approval).
2. Verify alphabetical ordering and term coverage; RFI for gaps not flagged at approval.
3. Add cross-references:
   - `README.md` "For agents working on this project" file map: add `GLOSSARY.md` as peer to `PROJECT.md`/`PLAN.md`/etc.
   - `prompts/engineer-session-start.md` load order: insert `GLOSSARY.md` between `PROJECT.md` and `PROCEDURES.md` in the load list.
   - `CONTEXT.md`: add a short "For terminology" section pointing at GLOSSARY.md.

*Scope B — cspell tooling:*
4. `npm install --save-dev cspell` — capture installed version for DEC-033.
5. Create `.cspell.json` at repo root with operator's Scope B2 config (en-GB, project words seed, ignorePaths, files glob `**/*.md`, ignoreRegExpList).
6. Add npm script `spell-check` to `package.json` per Scope B3.
7. Update `.githooks/pre-commit`: append cspell as 5th step after ESLint, scoped to staged .md files.
8. **First-run cleanup (Scope B5):** run `npx cspell "**/*.md"` across the entire repo. Categorize each flagged item per operator's a/b/c rule. Fix US-spelling typos (per Open Item 2 default), add project terms to `.cspell.json` words list, RFI any ambiguous items.
9. **Synthetic violation test (Scope B6, mandatory per working agreement #8):**
   - Create temp file `_synthetic_cspell_test.md` with intentional misspelling ("teh").
   - `git add`, attempt `git commit`, capture FAIL output naming the misspelling.
   - Revert (delete file), confirm clean state.
10. File DEC-033 in DECISION.md per Scope B7 wording, with installed cspell version cited.

*Scope C — Procedure 3 fix:*
11. Update PROCEDURES.md Procedure 3 "Proof division" section per Scope C1 verbatim. Replace the "Operator captures:" line with the work-type-conditional version.
12. Document in SITE_LOG: practice-and-procedure drift across MS-001..007 (all doc-only, all bypassed operator-capture step), this fix aligns the procedure with established practice.

*Scope D — state update:*
13. Update `state/current.md`:
    - Bump Updated timestamp.
    - Phase line: "Phase 0b complete. Infrastructure phase in progress (MS-008). Phase 1 blocked on MS-009."
    - Active MS: MS-008. MS-007 marked DONE.
    - Counters: Latest MS=MS-008, Latest DEC=DEC-033, Latest INC=INC-006 (unchanged), Latest RFI=RFI-010 (unchanged).
    - MS chain status: MS-007 DONE, MS-008 in progress, MS-009 pending depends on MS-008 (deep check, 8 sections), [first Phase 1 MS] pending depends on MS-009.
    - **Replace existing working agreement #14 with refined wording** from operator's DONE-007 sign-off. Old wording stays in DONE-007's sign-off notes for the trail; canonical agreements list now has the refined version.
    - Update last-verified-state with MS-008 results.

*Sign-out + commit:*
14. Final validator run: PASS.
15. Sign-out entry in SITE_LOG using new template.
16. `git add . && git commit -m "MS-008: glossary + cspell tooling + Procedure 3 fix"`. Hook fires gitleaks → validator → Prettier → ESLint → cspell; all five must pass. Push.
17. File DONE-008 with proof. Commit + push close-out.

**Files to be touched:**
- `Desktop/UnoAi/GLOSSARY.md` — created.
- `Desktop/UnoAi/.cspell.json` — created.
- `Desktop/UnoAi/.githooks/pre-commit` — modified (cspell as 5th step).
- `Desktop/UnoAi/package.json` — modified (cspell devDependency + spell-check script).
- `Desktop/UnoAi/package-lock.json` — modified (cspell + transitive deps locked).
- `Desktop/UnoAi/README.md` — modified (file map + Self-hosting section if needed for terminology pointer).
- `Desktop/UnoAi/prompts/engineer-session-start.md` — modified (load order updated).
- `Desktop/UnoAi/CONTEXT.md` — modified (For terminology section).
- `Desktop/UnoAi/PROCEDURES.md` — modified (Procedure 3 doc-only-MS clarification).
- `Desktop/UnoAi/forms/DECISION.md` — modified (DEC-033 appended).
- `Desktop/UnoAi/forms/METHOD_STATEMENT.md` — modified (this MS-008 entry; approval status update post-approval).
- `Desktop/UnoAi/forms/SITE_LOG.md` — modified (sign-in already filed; sign-out at session close).
- `Desktop/UnoAi/forms/DONE.md` — modified (DONE-007 sign-off line already updated; DONE-008 appended at session close).
- `Desktop/UnoAi/state/current.md` — modified (counters, MS chain, agreement #14 refined, phase line, last-verified-state).
- **Existing .md files with US spellings (per Open Item 2 default):** PROJECT.md, METHOD_STATEMENT.md, prompts/engineer-session-start.md, DONE.md, DECISION.md — fix US → UK during Scope B5 cleanup. Estimated ~10 instances.

**Files NOT touched (per scope):**
- `forms/CHANGE_ORDER.md`, `forms/RFI.md` (no new RFIs unless ambiguous cspell items surface), `forms/INCIDENT.md` (no expected incidents). LICENSE, CONTRIBUTING.md, PLAN.md (PLAN may be touched for US-spelling fix only). `.gitignore`, `.gitleaks.toml`, `.prettierignore`, `.prettierrc`, `eslint.config.js`. Existing `scripts/validate.sh` (cspell is separate from validator).
- Existing DONE-002..006 sign-off lines stay `pending` per MS-007 Scope D2 / MS-009 Section 5 retroactive cleanup.

**Expected diff size:** ~700 lines net added across ~15 files. ~75% is GLOSSARY.md content (operator-supplied verbatim, ~400 lines including alphabetic sections). cspell config + dictionary expansion ~100 lines. Hook update ~25 lines. State update + working agreements update ~40 lines. DEC-033 ~20 lines. PROCEDURES.md fix ~10 lines. Cross-references ~15 lines. US-spelling fixes across existing files ~10 line touches. No product code, no validator changes.

**Risks identified:**

- **R1. Open Item 1 — glossary coverage gaps.** Surfaced at approval. Builder default: ship as Scope A2; operator paste-at-approval for additions.

- **R2. Open Item 2 — Engineer's "en-GB consistent" premise empirically false.** Builder will fix US→UK as part of B5 first-run cleanup (per operator's "real typos → FIX" rule). ~10 fixes across PROJECT.md, METHOD_STATEMENT.md, prompts/, DONE.md, DECISION.md. If operator prefers en-US tolerance instead, override at approval.

- **R3. cspell first-run output volume.** Operator's prompt anticipated "30-80 more terms" beyond the seed list. Builder estimates closer to 50-150 given the en-GB / US-spelling overlap, repeated mentions of project SHAs (already ignored), repeated mentions of file paths and technical strings, and project-specific compound terms (e.g., "agentic", "BYOK", "metallel" — typo? — to be classified). Documented in SITE_LOG with categorization counts.

- **R4. cspell as new top-level npm devDependency.** Per DEC-031 (dependency policy), every new dep needs a DEC. DEC-033 covers this. Standing-approved scaffold deps from MS-003 unchanged.

- **R5. Hook chain expanded to 5 steps.** Adds cspell run time per commit. Estimate: <500ms on staged .md files. Acceptable for solo-dev workflow. fail-fast pattern preserved.

- **R6. Synthetic violation test for cspell (Scope B6).** Same discipline as MS-005 chain check, MS-006 ESLint/Prettier tests. Builder will create temp .md with "teh", attempt commit, capture FAIL output, revert, confirm clean. Expected behaviour: cspell flags `teh`, hook exits 1, commit blocked.

- **R7. Glossary entries reference DEC/MS/INC/RFI numbers — verify cross-references resolve.** Each "(per DEC-NNN)" / "(per MS-NNN)" inline in glossary content needs to point at a real entry. Builder will do a post-write grep to verify. Operator's Scope A2 content references DEC-001/007/008/011/012/015/019/020/021/022/024/026/032 and MS-001/003/005/006/007. All should resolve given current DECISION.md state (DEC-001..033 with MS-008 about to file DEC-033).

- **R8. Procedure 3 "doc-only MS" wording — language mirrors operator's Scope C1 verbatim.** No new decision; just acknowledges that operator-captured proof for doc-only MSes is the chat sign-off itself (per DEC-032 magic-string). Builder copies operator's wording as-is.

- **R9. Working agreement #14 refinement replaces existing #14 in state/current.md.** Builder doesn't preserve old #14 in the canonical list — refined wording is the authoritative version. Old wording lives in DONE-006 sign-off notes (where #14 was originally introduced) and DONE-007 sign-off notes (where the refinement was approved). Audit trail intact.

- **R10. The DONE-007 sign-off magic-string already applied at sign-in (per operator's MS-008 procedure step 2).** Mechanical, pre-approved. Captured in SITE_LOG sign-in entry. First real exercise of DEC-032 mechanism — pattern works.

- **R11. cspell installed as devDependency — won't ship to user-facing bundle.** Standard npm convention; cspell is a dev tool, not runtime. No Phase 1+ code impact.

**Acceptance criteria (will be copied verbatim into DONE-008):**
- `GLOSSARY.md` exists at repo root with operator's Scope A2 content verbatim (modulo Open Item 1 coverage additions if approved at MS-008 approval).
- Cross-references to GLOSSARY.md added in: `README.md` file map, `prompts/engineer-session-start.md` load order, `CONTEXT.md` "For terminology" section.
- `.cspell.json` exists at repo root with operator's Scope B2 config + first-run additions.
- `package.json` has `cspell` in devDependencies + `spell-check` npm script.
- `.githooks/pre-commit` runs gitleaks → validator → Prettier → ESLint → cspell. All five must PASS.
- B5 first-run cleanup: cspell runs cleanly across all `.md` files (categorization counts in SITE_LOG; US-spelling typos fixed; project terms added to dictionary).
- B6 synthetic test: cspell BLOCKS commit with intentional typo, then revert + clean run passes.
- DEC-033 filed in DECISION.md with cspell version cited.
- PROCEDURES.md Procedure 3 "Proof division" section updated per Scope C1.
- DONE-007 `Operator sign-off:` field updated to `DONE-007 signed off by operator on 2026-04-28` (already done at sign-in per DEC-032 mechanism — first real exercise).
- `state/current.md` updated: Latest MS=MS-008, Latest DEC=DEC-033, MS-007 DONE, MS-008 in progress, MS-009 pending depends on MS-008, working agreement #14 refined per DONE-007 sign-off.
- Sign-in (filed) and sign-out (at session end) entries in SITE_LOG using Procedure 9 templates.
- Validator pre-commit run: PASS. Hook fires all 5 steps on MS-008 commit.
- Push to GitHub succeeds.
- DONE-008 contains: validator PASS output, hook output verbatim from MS-008 commit (5 steps), cspell first-run categorization summary, B6 synthetic test FAIL output, file-by-file change summary, GitHub URLs.

**Operator approval:** APPROVED 2026-04-28.
**Approval notes:**
- **Open Item 1 (glossary coverage):** Approved adding three entries inline (synthetic test, validator size budget, Vitest) per Builder drafts, with one operator addition to the validator-size-budget entry citing DEC-026.
- **Open Item 2 (en-GB premise + US→UK):** Approved Builder default (a) — fix US spellings as part of B5 first-run cleanup. Builder given bulk-conversion authority (no per-instance RFI needed for known categories: the US spellings of `behaviour` / `organise` / `theatre` / `memorise` / `labelled`). Documented in SITE_LOG.
- **Open Item 3 (DEC-033 numbering + cspell version):** Approved sequential. Installed version captured: `cspell ^10.0.0` (v10.0.0 at install time).
- **Mid-MS pause for unfilled `[paste...]` placeholders in approval message** — Builder caught the failure mode and stopped before applying. Operator approved Builder drafts of the three glossary entries + B5 mechanical execution authority. New working agreement #16 introduced as a result.
- **Working agreement #14 refinement** lands at this MS sign-out per operator's DONE-007 sign-off instruction (replaces existing #14).
- **Working agreement #15 added** per MS-008 post-mortem on Engineer's glossary-coverage memory gap.
- **Working agreement #16 added** per the placeholder-pause discussion above.
- **DONE-007 sign-off magic-string applied at sign-in** — first real exercise of DEC-032. Pattern works as designed.
- **Existing DONE-002..006 stay pending** per MS-007 Scope D2 / MS-009 Section 5 retroactive cleanup.
- **Validator deferred 11th check** still deferred to MS-009+ (per DEC-032 / MS-007 SITE_LOG handover note).
- **Hook chain becomes 5 steps:** gitleaks → validator → Prettier → ESLint → cspell. Fail-fast preserved.
- **B6 synthetic test:** initially used `teh` per operator's prompt; cspell treats `teh` as valid (in some default dictionary). Switched to `asdfqwerty` for unambiguous misspelling. Hook BLOCKED commit at exit 1; revert + clean run passes. First synthetic test commit (with `teh`) accidentally landed at SHA `4d88669` because cspell didn't flag it; reset via `git reset HEAD~1` (mixed) before any push. Not in remote history. **Worth surfacing for operator awareness:** `teh` isn't reliably caught by cspell defaults — a future MS may want to add it explicitly to a `flagWords` list in `.cspell.json` if catching common typos like `teh` is the goal.
- **First-run cleanup result:** 159 issues across 15 files initially → 0 issues after dictionary additions (~22 project terms beyond the seed 30) + bulk US→UK fixes. Categorisation in DONE-008 proof.
- **`.cspell.json` `files` glob removed** because it interacts oddly with literal-filename CLI args (cspell intersects config glob with explicit args; literal filenames silently skipped if not matched by config glob). Hook now passes filenames through to cspell which uses them directly. npm script glob form unchanged.
