<!--
Format-spec for the validator (per DEC-026 + R8):

The validator script (scripts/validate.sh) parses the four "Latest" counter
lines below using strict regex. **Do not reformat these lines.** The expected
format for each is a literal "Latest XXX:" prefix followed by an XXX-NNN
identifier. The validator will hard-fail if a counter line cannot be parsed,
because line-format drift is exactly the failure mode mechanical enforcement
should catch. If you need to add commentary, put it on a separate line.

Auto-update timestamp: the "Updated:" line below should be refreshed on every
sign-out where state changes, per Procedure 9 (session lifecycle).
-->

# UnoAi — Current State

Updated: 2026-04-28 01:45 (auto-updated at session sign-out)

## Phase

Current: Phase 0b complete. Infrastructure phase in progress (MS-005). Phase 1 blocked on MS-006.
Last completed: MS-004 (DONE-004 signed 2026-04-28).
Next: MS-006 (code structure + dev tooling) → Phase 1 (landing + payment + license).

## Active MS

MS-005 in progress (chain validator check + code conventions for AI agents + README markdown fixes).

## Counters (latest of each)

Latest MS:  MS-005
Latest DEC: DEC-027
Latest RFI: RFI-010
Latest INC: INC-006

## MS chain status

- MS-001: complete (operator pre-authorised; no DONE filed — predates the DONE-required convention).
- MS-002: DONE (DONE-002, signed 2026-04-27).
- MS-003: DONE (DONE-003, signed 2026-04-27).
- MS-004: DONE (DONE-004, signed 2026-04-28).
- MS-005: in progress.
- MS-006: pending; depends on MS-005 (code structure + dev tooling, scope TBD).

## Open RFIs

- RFI-009: TLD selection (`unoai.com` / `.app` / other) — pending operator decision, not blocking until pre-Phase-8.
- RFI-010: DONE sign-off recording mechanism — engineer's lean (a) magic-string-in-chat-then-copy-into-file. Deferred to MS-006 design.

## Pending operator actions

- Cloudflare Pages account creation (blocks Phase 1 deployment).
- Lemon Squeezy account + store + $9 placeholder product (blocks Phase 1 payment flow).
- Worker secret store ready for Ed25519 private key (blocks Phase 1 webhook handler).
- Domain registrar account + domain selection (deferred per RFI-009, pre-Phase-8 deadline).
- GitHub repo description update (currently still "Name is place holder").
- Optional: README self-hosting wording amendment (deferred to MS-003.5 or roll into Phase 1 prep).

## Last verified working state

2026-04-28 (MS-005) — Validator gained 9th check (MS chain dependency). Both branches verified via synthetic tests: target-missing ("MS-099 does not exist") and target-undone ("MS-001 exists but is not yet DONE"). PROJECT.md "For agents reading the code" section added (DEC-027). README markdown fixes landed (`## Self-hosting` heading restored, Status line current). Validator is 237 lines, 9 checks; the 150-line guidance from MS-004 is retired per working agreement #10. INC-006 captured the MS-004 enforcement-gap pattern; RFI-010 filed for the DONE sign-off recording mechanism (deferred to MS-006).

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

## Banned moves (mirror of PROJECT.md, restated for session-start visibility)

- No code changes without an MS.
- No silent fixes outside scope.
- No commits with secrets (gitleaks-enforced).
- No Co-Authored-By Claude footers on commits.
- Persona: no permanence promises, no love claims, no substitute-for-humans framing.
