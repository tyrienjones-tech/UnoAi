# Sign-off log

This file tracks **section-by-section sign-offs** for MSes that use a section-gated execution model. Currently only MS-009 (pre-Phase-1 deep check) uses this form. Future MSes may opt in if their scope is large enough that a single chat sign-off at DONE-time would lose granularity.

**Why this form exists** — for a multi-section MS, signing off the whole thing at once collapses too much detail. A failure in Section 5 might invalidate Sections 6-8 work. Section-by-section sign-off catches problems at the section boundary, before downstream sections build on bad state.

**Format** — each section gets its own entry with checklist results, findings, and an `Operator sign-off:` field populated from operator's chat magic-string at next session sign-in (per DEC-032 mechanism, extended from DONE-form to SIGN_OFF-form).

**Magic-string format:** `Section N signed off by operator on YYYY-MM-DD.`

**Cross-section ordering:** sections must be completed in order. Section N+1 cannot begin before Section N's `Operator sign-off:` is populated. Builder enforces this by reading SIGN_OFF.md at session sign-in to determine which section is current.

**Validator interaction:** SIGN_OFF.md is not subject to the validator's numbering checks (those apply to DEC/RFI/INC/MS only). Section ordering is enforced procedurally, not mechanically. Future MS may add a validator check if section-gated MSes become routine.

---

## MS-009 Section 0 — `forms/SIGN_OFF.md` creation + PROCEDURES.md note

Status: in progress
Date filed: 2026-04-28
Date signed: pending
Operator sign-off: pending

### Checklist results

- [x] `forms/SIGN_OFF.md` created at repo root in `forms/` directory.
- [x] Header explains purpose, format, magic-string, ordering rule, validator interaction.
- [x] Eight section entries scaffolded per Scope 0.1 template (Section 0 + Sections 1-8).
- [x] `PROCEDURES.md` updated with one-paragraph note about SIGN_OFF.md (placement: post-Procedure-9, pre-Summary-table). Procedure count stays at nine; SIGN_OFF.md is a form used by section-gated MSes, not a new procedure category.

### Findings

Section 0 is the bootstrap section — its purpose is to create the form that subsequent sections write into. By definition the bootstrap pattern means Section 0 itself signs off into the file it just created. Same recursive-bootstrap pattern as MS-004's session-lifetime templates.

Validator and pre-commit hook unaffected. No new tooling. No DEC needed (Section 0 is procedural scaffolding, not a decision).

### Notes

- The "**Magic-string format:** `Section N signed off by operator on YYYY-MM-DD.`" line in this file's header is a deliberate prose mention of the format, not a placeholder. Builder will not interpret it as a stale or applied sign-off when reading SIGN_OFF.md to determine the current section — the per-section `Operator sign-off:` field is the source of truth for section status.
- Section 0 sign-off in chat unlocks Section 1.

---

## MS-009 Section 1 — Spelling & grammar

Status: in progress
Date filed: 2026-04-28
Date signed: pending
Operator sign-off: pending

### Checklist results

- [x] **1.1 cspell baseline run** on the full repo — PASS. 18 .md files checked, 0 issues. (Clean baseline carried over from MS-008 close-out; re-confirmed at Section 1 start before manual pass began.)
- [x] **1.2 cspell post-edit run** after manual grammar pass conversions — PASS. 18 files, 0 issues.
- [x] **1.3 Manual grammar pass on 8 prose-heavy files** — complete:
  - [x] `README.md`
  - [x] `PROJECT.md`
  - [x] `PLAN.md`
  - [x] `PROCEDURES.md`
  - [x] `CONTEXT.md`
  - [x] `GLOSSARY.md`
  - [x] `prompts/engineer-session-start.md`
  - [x] `prompts/engineer-prompt-checklist.md`
- [x] **1.4 Pass criteria met:**
  - Zero spell-check failures on full repo run (18 files, 0 issues)
  - Zero grammar errors that change meaning (none found across the 8 in-scope files)
  - Dialect consistent (en-GB throughout the in-scope files after 6 conversions applied — see Findings)

### Findings

**Six en-GB conversions applied** across 4 files (the other 4 in-scope files were already clean):

| File | Line | Before | After |
|---|---|---|---|
| `CONTEXT.md` | 22 | `engagement-optimized` | `engagement-optimised` |
| `CONTEXT.md` | 24 | `centralized` | `centralised` |
| `PROJECT.md` | 5 | `optimized` (organising-principle blockquote) | `optimised` |
| `prompts/engineer-session-start.md` | 29 | `optimize` (doctrine-loading paragraph) | `optimise` |
| `prompts/engineer-session-start.md` | 65 | `summarize` ("summarize the doctrine") | `summarise` |
| `prompts/engineer-prompt-checklist.md` | 37 | `authorize` (item 11 banned-prep-work line) | `authorise` |

**No meaning-changing grammar errors found** across the 8 in-scope files. Dialect is now uniformly en-GB throughout these files (consistent with `behaviour` / `organise` / `theatre` / `memorise` already established at MS-008 bulk-conversion authority).

**`license` usage intentionally retained** — proper noun in "PolyForm Noncommercial License" (canonical product name) and the verb form is tolerated in en-GB; consistent with MS-008 line-1008 finding ("license/licence — uses 'license'") and not subject to conversion.

### Notes

- **Cross-grep approach** used to verify dialect coverage: ran four word-boundary regex passes across the 8 in-scope files — one for the s-form-versus-z-form verb family, one for the colour/favour/honour family, one for the single-l versus double-l past-tense family, and one for the centre / defence / offence family. Six matches (above) needed conversion; everything else was either already en-GB, already correct (e.g. the proper-noun product name in PolyForm Noncommercial License + the verb form which en-GB tolerates), or false-positive (e.g. the literal noun "size", and "estimated" which is dialect-neutral).
- **Out-of-scope files** (`forms/METHOD_STATEMENT.md`, `forms/DECISION.md`, `forms/DONE.md`, `forms/SITE_LOG.md`, `forms/INCIDENT.md`, `forms/RFI.md`, `forms/CHANGE_ORDER.md`, `state/current.md`) still contain occasional US spellings inside historical entries (e.g. METHOD_STATEMENT.md line 1006 quoted-list of `-ise` flag candidates, DECISION.md line 434 has a US-form past participle of *recognise*). These are deliberately left in place — the MS-009 Section 1 scope is the 8 prose-heavy authoritative files; historical-record files are append-only and converting them would be an MS-008-style bulk pass not authorised here. cspell continues to pass on those files because the spellings are in the project dictionary or are acceptable variant forms in en-GB cspell.
- **First-session-of-MS-009 boundary:** Section 1 is the second of two sections completed in this session. Per operator's PROCEED authorisation, both Section 0 and Section 1 are completed in the first MS-009 session; Section 1 sign-off in chat unlocks Section 2 for the next session.
- **No new tooling, no validator changes.** Pure content edits to existing files. Pre-commit hook unaffected.

---

## MS-009 Section 2 — Internal references & links

Status: pending
Date filed: pending
Date signed: pending
Operator sign-off: pending

### Checklist results

(to be filled at Section 2 work)

### Findings

(to be filled at Section 2 work)

### Notes

(to be filled at Section 2 work)

---

## MS-009 Section 3 — Documentation accuracy

Status: pending
Date filed: pending
Date signed: pending
Operator sign-off: pending

### Checklist results

(to be filled at Section 3 work)

### Findings

(to be filled at Section 3 work)

### Notes

(to be filled at Section 3 work)

---

## MS-009 Section 4 — State integrity

Status: pending
Date filed: pending
Date signed: pending
Operator sign-off: pending

### Checklist results

(to be filled at Section 4 work)

### Findings

(to be filled at Section 4 work)

### Notes

(to be filled at Section 4 work)

---

## MS-009 Section 5 — Form integrity + retroactive DONE sign-off

Status: pending
Date filed: pending
Date signed: pending
Operator sign-off: pending

### Checklist results

(to be filled at Section 5 work)

### Findings

(to be filled at Section 5 work)

### Notes

(to be filled at Section 5 work — includes retroactive sign-off application for DONE-002..006 per operator-supplied magic-strings, plus 11th validator check ship + synthetic test)

---

## MS-009 Section 6 — Tooling end-to-end

Status: pending
Date filed: pending
Date signed: pending
Operator sign-off: pending

### Checklist results

(to be filled at Section 6 work)

### Findings

(to be filled at Section 6 work)

### Notes

(to be filled at Section 6 work — cold-clone test at `/tmp/unoai-cold-clone`, all five hook synthetic tests, cleanup after)

---

## MS-009 Section 7 — Doctrine alignment

Status: pending
Date filed: pending
Date signed: pending
Operator sign-off: pending

### Checklist results

(to be filled at Section 7 work)

### Findings

(to be filled at Section 7 work)

### Notes

(to be filled at Section 7 work — probe `/mnt/skills/user/eco-agentic-doctrine/SKILL.md` accessibility first; RFI if missing)

---

## MS-009 Section 8 — Phase 1 readiness gate

Status: pending
Date filed: pending
Date signed: pending
Operator sign-off: pending

### Checklist results

(to be filled at Section 8 work)

### Findings

(to be filled at Section 8 work)

### Notes

(to be filled at Section 8 work — DONE-009 filed only after this section signs off)
