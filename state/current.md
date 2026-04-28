<!--
Format-spec for the validator (per DEC-026 + R8 + MS-006 Scope G):

Two parsers in scripts/validate.sh read this file:

(a) Counter parser (check 7). Reads lines starting with "Latest XXX:" where
    XXX ∈ {MS, DEC, RFI, INC} and the rest of the line contains an "XXX-NNN"
    identifier. **Do not reformat the four "Latest" counter lines.**

(b) Phase parser (check 10, README ↔ state sync). Reads the line starting
    with "Current:" inside the "## Phase" section, extracts the first
    "Phase X status" identifier, and compares against README's "## Status"
    first non-empty line. **Do not reformat the "Current:" line** — keep it
    starting with "Current: Phase X status..." so the parser can extract
    the identifier. Reformatting either side causes the pre-commit hook to
    hard-fail with a "README Status section out of sync" message.

The validator hard-fails if a parser cannot read these lines, because
line-format drift is exactly the failure mode mechanical enforcement should
catch. If you need to add commentary, put it on a separate line.

Auto-update timestamp: the "Updated:" line below should be refreshed on every
sign-out where state changes, per Procedure 9 (session lifecycle).
-->

# UnoAi — Current State

Updated: 2026-04-28 13:30 (auto-updated at session sign-out — MS-009 first session, Sections 0+1 complete and awaiting chat sign-offs).

## Phase

Current: Phase 0b complete. Infrastructure phase in progress (MS-009). Phase 1 blocked on MS-009 close.
Last completed: MS-008 (DONE-008 signed 2026-04-28; second exercise of DEC-032 magic-string mechanism applied at MS-009 sign-in).
Next: MS-009 remaining sections (2 through 8, multi-session) → Phase 1 (landing + payment + license).

## Active MS

MS-009 in progress (pre-Phase-1 deep check, 8 sections, section-by-section sign-off via `forms/SIGN_OFF.md`). Sections 0 (SIGN_OFF.md creation + PROCEDURES.md note) and 1 (spelling & grammar) completed this session and awaiting operator chat sign-offs.

## Counters (latest of each)

Latest MS:  MS-009
Latest DEC: DEC-033
Latest RFI: RFI-010
Latest INC: INC-006

## MS chain status

- MS-001: complete (operator pre-authorised; no DONE filed — predates the DONE-required convention).
- MS-002: DONE (DONE-002, signed 2026-04-27).
- MS-003: DONE (DONE-003, signed 2026-04-27).
- MS-004: DONE (DONE-004, signed 2026-04-28).
- MS-005: DONE (DONE-005, signed 2026-04-28).
- MS-006: DONE (DONE-006, signed 2026-04-28).
- MS-007: DONE (DONE-007, signed 2026-04-28; sign-off recorded in DONE-007 entry per DEC-032 magic-string at MS-008 sign-in — first real exercise).
- MS-008: DONE (DONE-008, signed 2026-04-28; second exercise of DEC-032 magic-string mechanism applied at MS-009 sign-in).
- MS-009: in progress (pre-Phase-1 deep check, 8 sections, section-by-section sign-off via `forms/SIGN_OFF.md`; Sections 0+1 work complete this session, awaiting chat sign-offs; Sections 2-8 future sessions).
- [first Phase 1 MS]: pending; depends on MS-009.

## Open RFIs

- RFI-009: TLD selection (`unoai.com` / `.app` / other) — pending operator decision, not blocking until pre-Phase-8.

(RFI-010 closed 2026-04-28 via DEC-032 — magic-string-in-chat sign-off recording.)

## Pending operator actions

- Cloudflare Pages account creation (blocks Phase 1 deployment).
- Lemon Squeezy account + store + $9 placeholder product (blocks Phase 1 payment flow).
- Worker secret store ready for Ed25519 private key (blocks Phase 1 webhook handler).
- Domain registrar account + domain selection (deferred per RFI-009, pre-Phase-8 deadline).
- GitHub repo description update (currently still "Name is place holder").
- Optional: README self-hosting wording amendment (deferred to MS-003.5 or roll into Phase 1 prep).

## Last verified working state

2026-04-28 (MS-009 first session) — `forms/SIGN_OFF.md` created at repo root in `forms/` directory with 8-section scaffold (Section 0 + Sections 1-8); each entry has Status / Date filed / Date signed / Operator sign-off fields plus Checklist results / Findings / Notes subsections. `PROCEDURES.md` updated with one-paragraph note about SIGN_OFF.md (placement: post-Procedure-9, pre-Summary-table); procedure count stays at nine. **Section 0** (SIGN_OFF.md creation + PROCEDURES.md note) work complete, status `in progress`, awaiting operator chat sign-off. **Section 1** (spelling & grammar) work complete: cspell baseline + post-edit runs both PASS (18 files, 0 issues); 6 en-GB conversions applied across 4 files (`CONTEXT.md` ×2, `PROJECT.md` ×1, `prompts/engineer-session-start.md` ×2, `prompts/engineer-prompt-checklist.md` ×1) — all in the form `optimized → optimised`, `centralized → centralised`, `summarize → summarise`, `authorize → authorise`. Manual grammar pass found zero meaning-changing errors across the 8 in-scope prose-heavy files. Out-of-scope files (`forms/*`, `state/current.md`) still contain occasional US spellings in historical entries; deliberately left per Section 1 scope boundary. No new tooling. No validator changes. No new working agreements. Pre-commit hook chain unchanged (5 steps).

2026-04-28 (MS-008) — `GLOSSARY.md` landed at repo root with ~50 alphabetical entries (operator-supplied content + Builder-drafted entries for Vitest / synthetic test / validator size budget per Open-Item-1 RFI resolution). `cspell` v10.0.0 installed as devDependency, `.cspell.json` configured (en-GB + 50+ project terms in dictionary), wired into pre-commit hook as 5th step (gitleaks → validator → Prettier → ESLint → cspell). First-run cleanup: 159 issues across 15 files initially → 0 issues after dictionary additions + bulk US→UK fixes (per Scope B5 bulk-conversion authority). Synthetic violation test (B6) confirmed cspell BLOCKS commits with definitively-misspelled content (`asdfqwerty`); revert + clean run passes. Note: `teh` is in cspell's default dictionary (treated as valid in some company-name dictionary), so the synthetic test used a less-ambiguous typo. Procedure 3 "Proof division" updated for doc-only-MS work-type-conditional operator-capture (per Scope C). DEC-033 filed. RFI-010 closure (from MS-007) carried over. Working agreements #14 refined to three-tier (git ls-remote / API endpoint / never-HTML), #15 added (glossary scope must be grep-evidence-based), #16 added (approval messages need actual content not placeholders).

2026-04-28 (MS-007) — Agent onboarding infrastructure landed. `prompts/engineer-session-start.md` (operator-pasted prompt for fresh Engineer sessions, references Anthropic-environment doctrine paths) + `prompts/engineer-prompt-checklist.md` (mechanical fix for working-agreement #5/#10/#11 drift, scope-noted to prompt-writing only) + `CONTEXT.md` (agent-onboarding-focused, distinct from PROJECT.md and README.md) + cross-references to `prompts/engineer-session-start.md` from README and PROJECT.md. PROCEDURES.md Procedure 1 gained Engineer-role addendum about reading the prompt-checklist before drafting prompts. RFI-010 closed via DEC-032 (DONE sign-off recording = magic-string-in-chat copied verbatim by Builder at next sign-in). DONE.md template annotated with the magic-string format. Validator script header documents the deferred 11th check (DONE sign-off enforcement) — implementation deferred to MS-009+ until DONE-002..006 retroactive cleanup completes. No validator code changes; no synthetic tests (working agreement #8 applies only when tooling is added).

2026-04-28 (MS-006) — Validator gained 10th check (README ↔ state sync). Synthetic test verified: state's "Current: Phase 99 in progress" is correctly caught against README's "Phase 0b complete". Final clean run PASS. Validator is 277 lines, 10 checks. Pre-commit hook chain extended to 4 steps: gitleaks → validator → Prettier (staged) → ESLint (staged); all four enforce on every commit. ESLint naming-convention rule landed with 0 false positives on existing scaffold. PROJECT.md "For agents reading the code" gained 4 new subsections (Code directory structure, Test layout, Errors and logging, Dependency policy). `.env.example` placeholder file landed with gitleaks rule capture-group fix so placeholder values pass cleanly. Skeleton dirs created under `src/lib/` for Phase 1+ work. DEC-028..031 filed (directory structure, test layout, errors+logging, dependency policy).

2026-04-28 (MS-005) — Validator gained 9th check (MS chain dependency). Both branches verified via synthetic tests: target-missing ("MS-099 does not exist") and target-undone ("MS-001 exists but is not yet DONE"). PROJECT.md "For agents reading the code" section added (DEC-027). README markdown fixes landed (`## Self-hosting` heading restored, Status line current). Validator was 237 lines at MS-005 close, 9 checks; the 150-line guidance from MS-004 is retired per working agreement #10. INC-006 captured the MS-004 enforcement-gap pattern; RFI-010 filed for the DONE sign-off recording mechanism (deferred to MS-007).

2026-04-28 (MS-004) — Session lifecycle live. Validator (`scripts/validate.sh`) verified PASS on clean state. All 5 synthetic violations correctly detected. Pre-commit hook runs gitleaks + validator in sequence; both must PASS. Two real validator bugs caught during E1 testing (octal leading-zero parsing, subshell variable isolation) and fixed.

2026-04-27 (MS-003) — DONE-003 signed. Three commits on `main`. SvelteKit scaffold runs clean (`npm run dev` = Vite 8.0.10, ready in 3.1s). Pre-commit hook live with gitleaks v8.30.1. All forms migrated under UnoAi name with role/descriptor carve-outs preserved.

## Engineer working agreements (running)

1. Verify RFI exists in source before writing `Closes: RFI-NNN` (INC-003).
2. Scope-by-section instructions cover all references, not just the named section (INC-004).
3. Capture pre-edit `wc -l` snapshots before multi-file MSes (DONE-002 lesson).
4. Don't authorise speculative prep work for Builder when "hold" is the answer.
5. Number sequentially from current state, no skip-numbering (Engineer error pattern, twice).
6. Repo-creation MSes verify remote state at create-time, not clone-time (INC-005).
7. Bash budgets are smell-checks not hard limits. When a budget overrun is caused by operator-required documentation or correctness fixes for bugs caught in test, the budget is wrong, not the script (DONE-004).
8. Tooling that enforces discipline must be tested against synthetic violations before shipping. Untested validators are worse than no validator — they create false confidence (DONE-004).
9. DONE sign-offs require mechanical verification of new tooling, not visual inspection. If a check was specced, the sign-off must include "ran the check against a synthetic violation, confirmed FAIL." Visual inspection of the script's presence is not sufficient (INC-006).
10. Bash budget caps for the validator are calibrated against the existing per-check complexity, not the new check's complexity. New checks that require new parsing primitives (block tracking, multi-file walks, structured parsing) will exceed the per-check budget by 2–3× and that's expected. Future budgets should be set at "current size + estimated new check size" rather than fixed caps (MS-005 RFI on validator size). **Numbering note:** operator wrote "#11" when introducing this; Builder renumbered to next-sequential **#10** per discipline #5. Operator can correct at DONE-005 sign-off if the skip was intentional.
11. Engineer prompts to Builder reflect committed file state, not chat-discussion state. References to prior "H1, H2, H2a" or similar inline-discussion labels are valid in chat but should not be replicated in prompts to Builder unless those labels also exist in committed files. When referencing prior decisions, cite the DEC/MS/INC number, not the chat-message annotation (DONE-005 sign-off).
12. When Engineer's external verification of repo state disagrees with Builder's report, the Engineer's tooling is the more likely failure point. HTML caches at GitHub, fetcher caches in the Engineer environment, and CDN edge caches all stale at multi-hour intervals. Builder running git locally against a known remote URL is the more reliable source of truth. When discrepancies appear, Engineer verifies via the API endpoint or `git ls-remote`, not by re-fetching HTML (DONE-006 sign-off, post-stale-cache incident).
13. Engineer pushback framing matters. "What state is the repo actually in?" is a neutral verification question. "Did Reaper's report land correctly?" is a question that implies fault before evidence. The first framing produces diagnostic responses; the second produces defensive ones. Future verification should default to neutral framing (DONE-006 sign-off).
14. **(refined 2026-04-28 at DONE-007 sign-off)** For DONE sign-off verification within ~60 seconds of a Builder push, prefer `git ls-remote origin refs/heads/main` (queries remote directly via git protocol, no HTTP cache layer). For verification beyond ~1 minute post-push, the API endpoint (`api.github.com/repos/.../git/refs/heads/main`) is sufficient. HTML repo pages should never be the verification source — they cache at multi-hour intervals. (Refinement followed the post-mortem on DONE-007 sign-off where API returned stale data within its 60s `max-age` cache window; original DONE-006-era wording defaulted to API-over-HTML, which was directionally correct but missed the API's own cache layer.)
15. Glossary, dictionary, and convention-list scopes that claim "cover all project terms" or "consistent across the repo" must be derived from grep/file-walk evidence, not from Engineer's memory of recent work. Memory-based coverage in a 7+ MS project produces ~80% coverage with the gaps in places Engineer hasn't recently touched (MS-008 post-mortem on glossary coverage gaps + en-GB premise that grep falsified).
16. Approval messages that contain placeholders for Engineer-drafted content must include the actual content inline, not "[paste from above]" references. Builder cannot resolve self-referential placeholders. If content exists in the chat thread but not in the approval message itself, Builder cannot use it. Engineer prompt-writing checklist item 5 (references resolve to committed files) extends to: "all content the prompt references must be present in the prompt itself." (MS-008 approval message contained two unfilled `[paste...]` placeholders that Builder caught + paused for clarification before applying.)

## Banned moves (mirror of PROJECT.md, restated for session-start visibility)

- No code changes without an MS.
- No silent fixes outside scope.
- No commits with secrets (gitleaks-enforced).
- No Co-Authored-By Claude footers on commits.
- Persona: no permanence promises, no love claims, no substitute-for-humans framing.
