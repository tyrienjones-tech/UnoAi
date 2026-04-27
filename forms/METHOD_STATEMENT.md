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
   - R3: restructure: top of README becomes user-facing stub ("[Marketing copy goes here in Phase 1]"); current agent-facing content moves to a section labeled "For agents working on this project" (it already is — verify the heading and ordering).
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
- **R3. README R3 restructure** moves agent-facing content below a new user-facing stub. The four "For agents" steps in current README.md (lines 7–22) and the file map (lines 23–41) need to remain agent-discoverable. Mitigation: keep all current agent content under a clearly-labeled "For agents working on this project" section heading; user-facing stub sits above it at the top. Builder will not delete agent content, only move it.
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

