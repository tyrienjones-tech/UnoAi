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

Updated: 2026-04-28 04:00 (auto-updated at session sign-out)

## Phase

Current: Phase 0b complete. Infrastructure phase in progress (MS-007). Phase 1 blocked on MS-008.
Last completed: MS-006 (DONE-006 signed 2026-04-28).
Next: MS-008 (pre-Phase-1 deep check, 8 sections) → Phase 1 (landing + payment + license).

## Active MS

MS-007 in progress (agent onboarding + Engineer prompt-writing checklist + RFI-010 resolution).

## Counters (latest of each)

Latest MS:  MS-007
Latest DEC: DEC-032
Latest RFI: RFI-010
Latest INC: INC-006

## MS chain status

- MS-001: complete (operator pre-authorised; no DONE filed — predates the DONE-required convention).
- MS-002: DONE (DONE-002, signed 2026-04-27).
- MS-003: DONE (DONE-003, signed 2026-04-27).
- MS-004: DONE (DONE-004, signed 2026-04-28).
- MS-005: DONE (DONE-005, signed 2026-04-28).
- MS-006: DONE (DONE-006, signed 2026-04-28).
- MS-007: in progress.
- MS-008: pending; depends on MS-007 (pre-Phase-1 deep check, 8 sections, section-by-section sign-off model).
- [first Phase 1 MS]: pending; depends on MS-008.

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

2026-04-28 (MS-007) — Agent onboarding infrastructure landed. `prompts/engineer-session-start.md` (operator-pasted prompt for fresh Engineer sessions, references Anthropic-environment doctrine paths) + `prompts/engineer-prompt-checklist.md` (mechanical fix for working-agreement #5/#10/#11 drift, scope-noted to prompt-writing only) + `CONTEXT.md` (agent-onboarding-focused, distinct from PROJECT.md and README.md) + cross-references to `prompts/engineer-session-start.md` from README and PROJECT.md. PROCEDURES.md Procedure 1 gained Engineer-role addendum about reading the prompt-checklist before drafting prompts. RFI-010 closed via DEC-032 (DONE sign-off recording = magic-string-in-chat copied verbatim by Builder at next sign-in). DONE.md template annotated with the magic-string format. Validator script header documents the deferred 11th check (DONE sign-off enforcement) — implementation deferred to MS-008+ until DONE-002..006 retroactive cleanup completes. No validator code changes; no synthetic tests (working agreement #8 applies only when tooling is added).

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
14. For DONE sign-offs going forward, Engineer's verification should default to API endpoints (`api.github.com/repos/.../git/refs/heads/main`) rather than HTML pages, until cache behavior on the HTML side is better understood. Reaper's `git` output in DONE reports remains primary; API verification is secondary corroboration (DONE-006 sign-off).

## Banned moves (mirror of PROJECT.md, restated for session-start visibility)

- No code changes without an MS.
- No silent fixes outside scope.
- No commits with secrets (gitleaks-enforced).
- No Co-Authored-By Claude footers on commits.
- Persona: no permanence promises, no love claims, no substitute-for-humans framing.
