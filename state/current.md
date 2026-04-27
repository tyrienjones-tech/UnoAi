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

Updated: 2026-04-28 00:55 (auto-updated at session sign-out)

## Phase

Current: Phase 0b complete + enforcement layer (Procedure 9 + validator) live. Phase 1 blocked on operator accounts.
Last completed: MS-004 (DONE-004 filed 2026-04-28, pending sign-off).
Next: Phase 1 — landing + payment + license issuance.

## Active MS

None. MS-004 close pending operator sign-off on DONE-004.

## Counters (latest of each)

Latest MS:  MS-004
Latest DEC: DEC-026
Latest RFI: RFI-009
Latest INC: INC-005

## Open RFIs

- RFI-009: TLD selection (`unoai.com` / `.app` / other) — pending operator decision, not blocking until pre-Phase-8.

## Pending operator actions

- Cloudflare Pages account creation (blocks Phase 1 deployment).
- Lemon Squeezy account + store + $9 placeholder product (blocks Phase 1 payment flow).
- Worker secret store ready for Ed25519 private key (blocks Phase 1 webhook handler).
- Domain registrar account + domain selection (deferred per RFI-009, pre-Phase-8 deadline).
- GitHub repo description update (currently still "Name is place holder").
- Optional: README self-hosting wording amendment (deferred to MS-003.5 or roll into Phase 1 prep).

## Last verified working state

2026-04-28 — MS-004 implemented session lifecycle. Validator (`scripts/validate.sh`) verified PASS on clean state. All 5 synthetic violations correctly detected (DEC numbering gap, missing-target Closes-RFI cross-reference, state counter mismatch, duplicate session-start, duplicate DEC). Pre-commit hook now runs gitleaks + validator in sequence; both must PASS. Two real validator bugs caught during E1 testing (octal leading-zero parsing, subshell variable isolation) and fixed.

2026-04-27 — DONE-003 signed. Three commits on `main`. SvelteKit scaffold runs clean (`npm run dev` = Vite 8.0.10, ready in 3.1s). Pre-commit hook live with gitleaks v8.30.1. All forms migrated under UnoAi name with role/descriptor carve-outs preserved.

## Engineer working agreements (running)

1. Verify RFI exists in source before writing `Closes: RFI-NNN` (INC-003).
2. Scope-by-section instructions cover all references, not just the named section (INC-004).
3. Capture pre-edit `wc -l` snapshots before multi-file MSes (DONE-002 lesson).
4. Don't authorise speculative prep work for Builder when "hold" is the answer.
5. Number sequentially from current state, no skip-numbering (Engineer error pattern, twice).
6. Repo-creation MSes verify remote state at create-time, not clone-time (INC-005).

## Banned moves (mirror of PROJECT.md, restated for session-start visibility)

- No code changes without an MS.
- No silent fixes outside scope.
- No commits with secrets (gitleaks-enforced).
- No Co-Authored-By Claude footers on commits.
- Persona: no permanence promises, no love claims, no substitute-for-humans framing.
