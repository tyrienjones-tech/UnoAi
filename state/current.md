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

Updated: 2026-04-28 23:30 (auto-updated at session sign-out — INSP-002 filing session: external review consolidation + INC-007 + INC-008 + INC-009 + RFI-013 + RFI-014; MS-009 Section 3 chat sign-off applied at sign-in; Sections 4-8 deferred to subsequent sessions).

## Phase

Current: Phase 0b complete. Infrastructure phase in progress (MS-009). Phase 1 blocked on MS-009 close.
Last completed: MS-008 (DONE-008 signed 2026-04-28; second exercise of DEC-032 magic-string mechanism applied at MS-009 sign-in).
Next: MS-009 remaining sections (2 through 8, multi-session) → Phase 1 (landing + payment + license).

## Active MS

MS-009 in progress (pre-Phase-1 deep check, 8 sections, section-by-section sign-off via `forms/SIGN_OFF.md`). Sections 0-3 signed off (Section 3 magic-string applied at this session's sign-in per DEC-032 sixth exercise / fourth on SIGN_OFF.md surface); Sections 4-8 pending in subsequent sessions.

## Counters (latest of each)

Latest MS:  MS-009
Latest DEC: DEC-033
Latest RFI: RFI-014
Latest INC: INC-009
Latest INSP: INSP-002

## MS chain status

- MS-001: complete (operator pre-authorised; no DONE filed — predates the DONE-required convention).
- MS-002: DONE (DONE-002, signed 2026-04-27).
- MS-003: DONE (DONE-003, signed 2026-04-27).
- MS-004: DONE (DONE-004, signed 2026-04-28).
- MS-005: DONE (DONE-005, signed 2026-04-28).
- MS-006: DONE (DONE-006, signed 2026-04-28).
- MS-007: DONE (DONE-007, signed 2026-04-28; sign-off recorded in DONE-007 entry per DEC-032 magic-string at MS-008 sign-in — first real exercise).
- MS-008: DONE (DONE-008, signed 2026-04-28; second exercise of DEC-032 magic-string mechanism applied at MS-009 sign-in).
- MS-009: in progress (pre-Phase-1 deep check, 8 sections, section-by-section sign-off via `forms/SIGN_OFF.md`; Sections 0-3 signed off 2026-04-28 — third through sixth exercises of DEC-032 magic-string mechanism; Sections 4-8 pending in subsequent sessions).
- MS-010: pending; depends on MS-009 (security cluster from INSP-001 findings: HIGH-1 + MEDIUM-1..5 + INC-007 backfill + doctrine to docs/).
- INSP-002: pending; depends on MS-010 (verify MS-010 closed findings; cleaner friction surface for second inspection cycle).
- MS-011: pending; depends on INSP-002 (working agreements consolidation: 20+ entries → ~10-12 distinct rules).
- [first Phase 1 MS]: pending; depends on MS-011.

## Open RFIs

- RFI-009: TLD selection (`unoai.com` / `.app` / other) — pending operator decision, not blocking until pre-Phase-8.
- RFI-011: validator check 10 design tightness (working as designed but narrow scope; tighten, accept, or replace?) — pending Engineer scoping into MS-010 / MS-011, not blocking. Filed at MS-009 Section 3.
- RFI-012: banned moves divergence between `PROJECT.md` and `state/current.md` (state/current.md not actually a mirror; direction of reconciliation TBD) — pending Engineer direction, not blocking. Filed at MS-009 Section 3.
- RFI-013: Cloudflare Pages → Workers migration timing (stay on Pages for v1 vs migrate before v1 deploy; Engineer's lean: migrate before v1 deploy) — pending operator decision, blocks Phase 1 first deploy. Filed at INSP-002.
- RFI-014: email delivery mechanism for license tokens (LS confirmation email vs separate service like Resend/Postmark; Engineer has no lean) — pending operator decision, blocks Phase 1 webhook handler implementation. Filed at INSP-002.

(RFI-010 closed 2026-04-28 via DEC-032 — magic-string-in-chat sign-off recording.)

## Pending operator actions

- Cloudflare Pages account creation (blocks Phase 1 deployment).
- Lemon Squeezy account + store + $9 placeholder product (blocks Phase 1 payment flow).
- Worker secret store ready for Ed25519 private key (blocks Phase 1 webhook handler).
- Domain registrar account + domain selection (deferred per RFI-009, pre-Phase-8 deadline).
- GitHub repo description update (currently still "Name is place holder").
- Optional: README self-hosting wording amendment (deferred to MS-003.5 or roll into Phase 1 prep).

## Last verified working state

2026-04-28 (INSP-002 filing session — Builder) — Section 3 sign-off magic-string applied at sign-in (DEC-032 sixth exercise, fourth on SIGN_OFF.md surface). Push state verified clean (`git ls-remote origin refs/heads/main` returned `16a70c9` matching local main). Pre-session and mid-session validators PASS at HEAD `16a70c9` (289 lines unchanged). **INC-007** filed (operator personal email caught in INSP-001 by gitleaks — long-deferred from Inspector handover note 3 / MS-009 Section 5; resolved in same commit per operator's Option-A direction after Builder pause-at-blocker on the INC-008-without-INC-007 sequence gap). **INC-008** filed (Engineer verification miss in INSP-002 action plan PDF v1.0 — same family as working agreements #19 + #20; named MS-011 working-agreement candidate #21 by Engineer for verify-before-asserting principle). **INC-009** filed (Engineer heading-level transcription drift across the INSP-002 session prompt — H2 used for all five new entries when INCIDENT.md and RFI.md convention is H3; Builder caught at validator FAIL pre-commit, operator authorised mechanical H2→H3 conversion for the four INC/RFI entries while INSP-002 retained H2 per INSPECTION.md convention; named MS-011 working-agreement candidate for "verify form-specific conventions before drafting numbered entries"; sub-case of the broader "verify before asserting" principle). **INSP-002** filed (external review consolidation — security + supply chain + architecture + procedural drift; 0 CRITICAL, 0 new HIGH, 8 MEDIUM, 5 LOW, 4 INFO; supplements but does not supersede INSP-001; recommends INSP-003 after MS-010). **RFI-013** filed (Cloudflare Pages → Workers migration timing; Engineer's lean: migrate before v1 deploy; blocks Phase 1 first deploy). **RFI-014** filed (email delivery mechanism for license tokens; Engineer has no lean; blocks Phase 1 webhook handler). MS-009 Sections 4-8 still pending in subsequent sessions; this session deliberately ended at the INSP-002 + INC-007 + INC-008 + INC-009 + RFI-013 + RFI-014 boundary per the prompt's rules of engagement. Validator PASS at sign-out (counters reflect Latest INC = INC-009, Latest RFI = RFI-014, Latest INSP = INSP-002; check_sequential clean across DEC/RFI/INC/MS).

2026-04-28 (MS-009 second session — Section 3) — Section 2 sign-off magic-string applied at sign-in (DEC-032 fifth exercise, third on SIGN_OFF.md surface); working agreements #17-#20 added to running list (cross-environment paths; explicit-approval; path-verification; new-agent-role first-session friction — all four traceable to INSP-001 first-inspection lessons). MS chain status updated for post-INSP-001 sequence (MS-009 → MS-010 (security cluster from INSP-001) → INSP-002 → MS-011 (working-agreements consolidation) → first Phase 1 MS). Section 3 (documentation accuracy) work complete: `PROCEDURES.md:67` DONE-001-onwards italicised footnote added explaining the MS-001 carve-out (closes Section 2 carry-forward Finding #1); `README.md:85` Status section updated to current-state phrasing (`Phase 0b complete. Infrastructure phase in progress (MS-009). Phase 1 begins after MS-009 → MS-010 → INSP-002 → MS-011.` — closes Section 2 carry-forward Finding #2 + INSP-001 LOW-3); `README.md:63` `.githooks/` parenthetical updated to include `cspell` as 5th hook step; `README.md:52-79` file map updated to add `forms/SIGN_OFF.md`, `forms/INSPECTION.md`, `.cspell.json` (tree connectors adjusted; INSPECTION.md becomes new last entry under `forms/`). RFI-011 filed (validator check 10 design tightness — Engineer to scope into MS-010 / MS-011); RFI-012 filed (banned moves divergence between PROJECT.md and state/current.md — Engineer to direct reconciliation; state/current.md banned moves header NOT modified in Section 3 per the section's audit-not-fix posture). All current-state stale-reference scans clean (`Chat2U`, `$39`, count drift across procedure / validator-check / hook-step / "X rules" — zero current-state hits); all seven MS-005 / MS-006-named "For agents reading the code" subsections present in PROJECT.md (plus 2 bonus). Validator PASS at sign-out (HEAD will be the close-out commit; validator at 289 lines unchanged — no validator code change in this section). Section 3 SIGN_OFF.md entry filed `Status: in progress`, awaiting operator chat sign-off; Section 4 (state integrity) is next session's work, not this session's.

2026-04-28 (INSP-001, Inspector audit) — pre-Phase-1 readiness audit filed at `forms/INSPECTION.md` (new form, created with header by Inspector this session). Validator PASS at session start (HEAD `586d6d0`) and PASS at session end (post-INSPECTION.md creation; new form is invisible to validator's check 1-10 surface). gitleaks clean across 508 KB of working-tree content. Audit posture: 0 CRITICAL, 1 HIGH (`CONTRIBUTING.md` security-contact placeholder), 5 MEDIUM (hook activation opt-in, hook/validator tamper-detection, --no-verify bypass, npm supply-chain monitoring, doctrine in-repo placement), 5 LOW (.gitleaks.toml self-reference, two operator email identities in commit history, README phase-content staleness already on Section 3 list, no CI, playwright install). All findings include recommendations; Engineer drafts MSes for action. Recommended next inspection: INSP-002 post-Phase-1 product code. **Procedural deviation noted in INSP-001 itself:** Inspector wrote INSP-001 counter and this last-verified-state line to working tree but did not commit `state/current.md` (left for Builder to fold in at MS-009 Section 2 close-out, because Builder's MS-009 Section 2 in-progress edits to the MS chain status section made selective staging non-trivial without destructive operations Inspector wasn't authorised to use).

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
17. Engineer prompts to agent roles operating in different environments must not assume environment-specific paths. /mnt/skills/..., working folder paths, and other environment-bound references resolve in Engineer's chat session but not necessarily in Builder's terminal session, Inspector's terminal session, or future agent roles' sessions. Cross-environment references must be repo-relative or chat-pasted.
18. Each procedural step requires explicit written approval, even when prior approvals appear to imply it. Pre-conditions (access scope, doctrine load, dependency files) are not the same as the work approval itself. Builder/Inspector wait for the explicit "proceed" or "approved" instruction; Engineer must give it explicitly, not by implication.
19. Engineer must verify exact filesystem paths before naming them in agent prompts. "Where the repo lives" assumptions based on prior context are likely wrong; verify against the actual prior session's path before referencing it.
20. When introducing a new agent role (Inspector, future others), the role's procedural setup will reveal Engineer assumptions about access, paths, and tooling that don't survive contact with the agent's environment. Plan for the first session to surface 2-4 such friction points; treat them as expected, not as failures. The role becomes operational only after these are resolved.

## Banned moves (mirror of PROJECT.md, restated for session-start visibility)

- No code changes without an MS.
- No silent fixes outside scope.
- No commits with secrets (gitleaks-enforced).
- No Co-Authored-By Claude footers on commits.
- Persona: no permanence promises, no love claims, no substitute-for-humans framing.
