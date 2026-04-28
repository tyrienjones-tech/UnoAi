# Sign-off log

This file tracks **section-by-section sign-offs** for MSes that use a section-gated execution model. Currently only MS-009 (pre-Phase-1 deep check) uses this form. Future MSes may opt in if their scope is large enough that a single chat sign-off at DONE-time would lose granularity.

**Why this form exists** — for a multi-section MS, signing off the whole thing at once collapses too much detail. A failure in Section 5 might invalidate Sections 6-8 work. Section-by-section sign-off catches problems at the section boundary, before downstream sections build on bad state.

**Format** — each section gets its own entry with checklist results, findings, and an `Operator sign-off:` field populated from operator's chat magic-string at next session sign-in (per DEC-032 mechanism, extended from DONE-form to SIGN_OFF-form).

**Magic-string format:** `Section N signed off by operator on YYYY-MM-DD.`

**Cross-section ordering:** sections must be completed in order. Section N+1 cannot begin before Section N's `Operator sign-off:` is populated. Builder enforces this by reading SIGN_OFF.md at session sign-in to determine which section is current.

**Validator interaction:** SIGN_OFF.md is not subject to the validator's numbering checks (those apply to DEC/RFI/INC/MS only). Section ordering is enforced procedurally, not mechanically. Future MS may add a validator check if section-gated MSes become routine.

---

## MS-009 Section 0 — `forms/SIGN_OFF.md` creation + PROCEDURES.md note

Status: signed off
Date filed: 2026-04-28
Date signed: 2026-04-28
Operator sign-off: Section 0 signed off by operator on 2026-04-28.

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

Status: signed off
Date filed: 2026-04-28
Date signed: 2026-04-28
Operator sign-off: Section 1 signed off by operator on 2026-04-28.

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

Status: signed off
Date filed: 2026-04-28
Date signed: 2026-04-28
Operator sign-off: Section 2 signed off by operator on 2026-04-28.

### Checklist results

- [x] **2.1 ID-reference walk (DEC / MS / INC / RFI / DONE).** Built the authoritative inventory from H3 entries inside the actual `## Entries` / `## Standing decisions` / `## Pre-filed RFIs` blocks of each form file (filtering out the `## Example` and `## Template` blocks where the same ID strings appear as illustrative placeholders — `MS-005` at `forms/METHOD_STATEMENT.md:46`, `INC-001` at `forms/INCIDENT.md:44`, `RFI-001` at `forms/RFI.md:41`, `DONE-004` at `forms/DONE.md:54` are all template-block decoration, not real entries). Authoritative inventory: DEC-001..033, MS-001..009, INC-001..006, RFI-001..010, DONE-002..008. Counters in `state/current.md` lines 42-45 (Latest MS=MS-009, Latest DEC=DEC-033, Latest RFI=RFI-010, Latest INC=INC-006) match the inventory. Then grep'd every `(DEC|MS|INC|RFI|DONE)-NNN` reference across the 18 in-scope `.md` files plus the 7 form files. **Result:** every reference resolves to either an existing entry, a properly-framed forward-looking entry, or properly-framed synthetic-test prose. See Findings for the one borderline case.
- [x] **2.2 Procedure N reference walk.** Inventory: Procedures 1-9 in `PROCEDURES.md` (lines 7, 26, 50, 73, 85, 103, 121, 133, 156). Grep'd every `[Pp]rocedure [0-9]+` reference across all 25 in-scope files. Every numbered reference (1-9) resolves. The single `Procedure 10` mention (`forms/METHOD_STATEMENT.md:862`) is a counter-factual ("adding a Procedure 10 *would* bump the 'nine procedures' count to ten...") explaining why a tenth procedure was deliberately not introduced — not a stale reference.
- [x] **2.3 Working-agreement #N reference walk.** Inventory: agreements #1-#16 in `state/current.md` lines 93-108. Grep'd every `(working agreement|agreement|discipline) #[0-9]+` reference across all 25 in-scope files. Every reference resolves. The single `#17` mention (`forms/METHOD_STATEMENT.md:1252`) is explicitly framed as a future-state candidate that "lands at MS-009 final sign-out" — forward-looking, not stale.
- [x] **2.4 Local file-link walk.** Inventory: extracted every `[text](./path.md)` markdown link target and every backtick-wrapped path reference from non-form prose files. All 8 markdown link targets in `CONTEXT.md` / `GLOSSARY.md` / `PROJECT.md` / `README.md` (`PROCEDURES.md`, `PLAN.md`, `state/current.md`, `prompts/engineer-session-start.md`, `GLOSSARY.md`, `CONTEXT.md`, `PROJECT.md`, `forms/SITE_LOG.md`) resolve. All currently-non-existent path references in non-form files are explicitly forward-looking (`test/fixtures/destructive_prompts.json` tagged Phase 4 in `PLAN.md:114` and `PROJECT.md:245`; `test/fixtures/crisis_prompts.json` tagged Phase 6 in `PLAN.md:163` and `PROJECT.md:246`; `src/lib/shared/errors.ts` annotated "created when first needed" in `PROJECT.md:270`; `sign-token.ts` is a kebab-case naming example in `PROJECT.md:254`; `src/lib/auth/__tests__/sign-token.test.ts` is an "e.g." example inside `DEC-029` in `forms/DECISION.md:408`). `test/fixtures/private/` is correctly entered in `.gitignore` and the directory is not yet present (no real private fixtures yet) — references describe the convention, not an existing directory.
- [x] **2.5 Prose-reference walk ("per X" / "see X" / "via X" forms).** Verified per/see references to phases (Phase 0a/0b/1-8 all present in `PLAN.md` lines 9, 29, 53, 72, 88, 104, 131, 153, 173, 190), procedures (covered above), DECs/MSes/etc. (covered above), and external doctrine paths. Doctrine references (`/mnt/skills/user/eco-agentic-doctrine/SKILL.md`, LESSON-009 in `PROCEDURES.md:69`) are internally consistent — every doctrine path uses the same canonical string. Probing whether the doctrine file is actually accessible from the Builder environment is explicitly Section 7's scope per the SIGN_OFF.md scaffold and so is deliberately not exercised here.
- [x] **2.6 Pass criteria met:** every cross-reference walked resolves to either an existing target, a properly-framed forward-looking target (planned future entry, future phase, "created when first needed"), or properly-framed synthetic-test prose. One stylistic finding surfaced for boundary disposition (see Findings).

### Findings

**Finding 1 — `DONE-001 onwards` in `PROCEDURES.md:67` references a non-existent DONE entry.** The line reads: `**Form:** \`forms/DONE.md\` (append-only, DONE-001 onwards)`. The other three forms use the same numbering-convention idiom and *do* resolve: `DECISION.md:3` → `Numbered DEC-001 onwards.` (DEC-001 exists at `forms/DECISION.md:13`), `METHOD_STATEMENT.md:3` → `Numbered MS-001 onwards.` (MS-001 exists at `forms/METHOD_STATEMENT.md:86`), `INCIDENT.md` follows the same pattern (INC-001 exists at `forms/INCIDENT.md:77`). DONE.md is the exception: its first real entry is **DONE-002** (`forms/DONE.md:96`), not DONE-001. The reason is the MS-001 carve-out — per `state/current.md:49`, "MS-001: complete (operator pre-authorised; no DONE filed — predates the DONE-required convention)", so DONE-001 was never written.

This is borderline: as a literal cross-reference it doesn't resolve, but as an idiomatic numbering-schema description ("the form starts at 001") it parallels the three siblings that do resolve. Per the operator's Section 2 instruction ("if any reference doesn't resolve, RFI before fixing"), surfacing rather than fixing. Three plausible dispositions for whichever section adopts this:
  1. Update to `DONE-002 onwards` (literally accurate; breaks pattern symmetry with the three sibling form descriptions).
  2. Update to `DONE-001 onwards (DONE-001 itself was never written; MS-001 predated the DONE convention — see state/current.md MS chain)`.
  3. Leave as-is; the schema-start framing is acceptable in context and the DONE.md file's own header could absorb a one-liner about the MS-001 carve-out.

Operator decision recommended at Section 2 sign-off; resolution likely belongs in Section 3 (documentation accuracy) or could be deferred entirely.

**Finding 2 — `README.md:85` stale phase-status content (cross-section observation, not a Section 2 reference resolution issue).** Line reads: `Phase 0b complete. Infrastructure phase in progress (MS-005). Phase 1 begins after MS-006 DONE. See \`PLAN.md\`.` The IDs `MS-005` and `MS-006 DONE` *do* resolve (both entries exist), so this is not a Section 2 reference-resolution failure — but the content is stale relative to current state (`state/current.md:32-34` shows MS-009 in progress, Phase 1 blocked on MS-009 close). The validator's check 10 (README ↔ state phase sync) verifies the line *starting* with `Phase 0b complete.` matches `state/current.md`'s `Current: Phase 0b complete.` and so passes despite the stale `MS-005` / `MS-006 DONE` tail. Surfacing here so it's caught before downstream sections build on the assumption that README phase commentary is current. Resolution belongs in Section 3 (documentation accuracy).

### Notes

- **Out-of-scope this section:** the validator's check 1-10 cover DEC↔RFI/Supersedes mechanically (per `scripts/validate.sh` header). Section 2 explicitly catches what the validator does *not*: Procedure-N references, working-agreement-#N references, local file-link targets, prose `per X` / `see X` references. The two domains are complementary; Section 2's clean walk plus the validator's clean run combine to "all internal cross-references resolve."
- **Methodology note:** the `## Example` / `## Template` block filtering matters. The cspell-style "every distinct ID anywhere in any file" grep produced apparent duplicates (`MS-005` appearing at line 46 *and* line 504 of `METHOD_STATEMENT.md`, etc.) that resolved to template-block decoration once block context was applied. Future cross-reference passes should bake the block-aware filtering into the methodology rather than re-deriving it. (Builder spent ~3 minutes verifying this once it was noticed; would have been 0 minutes with a documented methodology.)
- **Cold-clone implication for Section 6:** the cross-reference walk used `find . -not -path './node_modules/*' -not -path './.svelte-kit/*' -not -path './.git/*'`. A cold-clone scenario (Section 6 work) repeats this against a fresh clone. If new files are added in Sections 3-5, the inventory baseline shifts; Section 6's walk should re-derive rather than re-use this section's output.
- **No tooling added.** No validator changes. No working-agreement changes. No DEC. Pure verification work; the artefact is the Findings entry above.
- **Section 2 sign-off in chat unlocks Section 3 (Documentation accuracy).** Both findings flagged here naturally feed Section 3's scope: the `DONE-001 onwards` disposition is a doc-accuracy decision; the `README.md:85` staleness is straightforward doc-accuracy work.

---

## MS-009 Section 3 — Documentation accuracy

Status: signed off
Date filed: 2026-04-28
Date signed: 2026-04-28
Operator sign-off: Section 3 signed off by operator on 2026-04-28.

### Checklist results

- [x] **3.1 Section 2 carry-forward Finding 1 — `PROCEDURES.md:67` "DONE-001 onwards"** — applied per Engineer's lean in Section 3 approval: italicised footnote inserted between the Form line and the Why line of Procedure 3, explaining DONE.md's first real entry is DONE-002, MS-001 predated the close-out-DONE convention, and "DONE-001 onwards" names the schema's starting point not an existing entry. Cross-references `state/current.md` MS chain status entry for MS-001 verbatim. No retroactive DONE-001 backfill (would create synthetic record); no rewrite to "DONE-002 onwards" (loses historical context for the MS-001 carve-out).

- [x] **3.2 Section 2 carry-forward Finding 2 + INSP-001 LOW-3 — `README.md:85` Status section staleness** — updated from `Phase 0b complete. Infrastructure phase in progress (MS-005). Phase 1 begins after MS-006 DONE.` to `Phase 0b complete. Infrastructure phase in progress (MS-009). Phase 1 begins after MS-009 → MS-010 → INSP-002 → MS-011.` Validator check 10 still passes — both files extract the `Phase 0b complete` identifier; the change is in the active-MS tail which check 10 doesn't examine (see Finding 1 below).

- [x] **3.3 Quantified-claims audit — procedure count, validator check count, hook step count, file map accuracy.**
  - **Procedure count:** `PROCEDURES.md` defines nine procedures (1-9, headings at lines 7, 26, 50, 73, 85, 103, 121, 133, 156). `README.md:30` says "the nine rules" — matches.
  - **Validator check count:** `scripts/validate.sh:7-25` header documents ten checks (1-10) and a deferred 11th. No current-state prose claims a different count.
  - **Hook step count:** `.githooks/pre-commit` runs five steps in order (gitleaks → validator → Prettier → ESLint → cspell, lines 45-137). `README.md:63` `.githooks/` parenthetical described `(gitleaks + validator + Prettier + ESLint)` — STALE (missing cspell, the 5th step from MS-008 / DEC-033). Updated to `(gitleaks + validator + Prettier + ESLint + cspell)`.
  - **File map accuracy:** every entry in `README.md:52-79` resolves to an existing file or directory. THREE current-state files were missing from the map: `forms/SIGN_OFF.md` (created MS-009 Section 0), `forms/INSPECTION.md` (created INSP-001), and `.cspell.json` (created MS-008 per DEC-033). All three added; tree connectors adjusted (`forms/INCIDENT.md` previously last with `└──` now `├──`; `forms/INSPECTION.md` becomes new `└──`).

- [x] **3.4 Stale-reference scan — `Chat2U`, `$39`, `eight rules` / `X procedures` / `X checks` / `X steps` count drift in current-state prose.** Cross-grep across all `.md` files at any depth (excluding `node_modules/` / `.svelte-kit/` / `.git/`):
  - `Chat2U`: 22 hits, all in historical-record entries (MS-001 / MS-002 bodies; INC-005; DONE bodies; SITE_LOG entries pre-migration). ZERO in current-state prose.
  - `$39`: 12 hits, all in historical-record entries (DEC-003 superseded body, DEC-007 alternatives, DEC-014 supersede note, RFI-001 example block, INC-004 stale-reference fix description, MS-002 history, DONE-002 metrics line, SITE_LOG entries, METHOD_STATEMENT.md MS-001/MS-002 bodies). ZERO in current-state prose.
  - `eight rules` / `seven rules` / `four rules` / `seven procedures` / `eight procedures` / `ten procedures` / `nine checks` / `ten checks` / `eleven checks` / `three steps` / `four steps` / `six steps`: ZERO current-state hits.

- [x] **3.5 Banned moves match between `PROJECT.md` and `state/current.md`** — DOES NOT MATCH. See Finding 2 below; surfaced as RFI-012 rather than fixed in Section 3 (direction is a structural decision for Engineer per the prompt's pause-at-blocker discipline).

- [x] **3.6 "For agents reading the code" subsections per MS-005 / MS-006 scope.** Inventory of subsections in `PROJECT.md:144-316` (block-aware filter to the parent `## For agents reading the code` heading at line 144):
  - `### Code directory structure` (line 148, MS-006 Scope C / DEC-028) — present
  - `### File header convention` (line 184, MS-005 Scope B / DEC-027) — present
  - `### DEC references in code` (line 203, MS-005 Scope B) — present
  - `### Tests as documentation` (line 214, MS-005 Scope B) — present
  - `### Test layout` (line 228, MS-006 Scope D / DEC-029) — present
  - `### Naming conventions` (line 252, MS-005 Scope B + MS-006 Scope F / DEC-027) — present
  - `### Errors and logging` (line 264, MS-006 Scope E / DEC-030) — present
  - `### Dependency policy` (line 289, MS-006 Scope F / DEC-031) — present
  - `### When in doubt` (line 313, MS-005 closing) — present
  All seven MS-005 / MS-006-named subsections present, plus two bonus (Tests as documentation, When in doubt).

- [x] **3.7 Validator check 10 investigation** — see Finding 1 below; RFI-011 filed for Engineer's design call.

### Findings

**Finding 1 — Validator check 10 is working as designed but its narrow scope let active-MS staleness escape; surfaced as RFI-011.** The check (specced in MS-006 Scope G, implemented at `scripts/validate.sh:243-277`) extracts a `Phase X status` pattern (POSIX bracket-class regex at `scripts/validate.sh:253`, case-insensitive on the leading character, captured via awk's `match()` and lowercased before comparison). Both the stale README (`Phase 0b complete. Infrastructure phase in progress (MS-005)...`) and current state (`Phase 0b complete. Infrastructure phase in progress (MS-009)...`) extract `Phase 0b complete` — match. The `MS-005 / MS-006 DONE` tail isn't examined. So the check is not "too lax in implementation" (no substring laxness bug as the original Section 2 finding hypothesised) — it's narrow by design. Whether that narrowness is the right design is RFI-011 for Engineer to scope into MS-010 or MS-011.

**Finding 2 — Banned moves divergence between `PROJECT.md` and `state/current.md`; surfaced as RFI-012.** PROJECT.md (lines 102-114, 9 entries) and state/current.md (lines 120-126, 5 entries plus 1 not-in-PROJECT.md) are not equivalent. State/current.md adds `No Co-Authored-By Claude footers on commits` not present in PROJECT.md, and condenses or omits 5 of PROJECT.md's items (DONE proof, dependency-without-DEC, user-conversation server storage, minor-targeting marketing, LLM-via-our-proxy). The state/current.md header claims `(mirror of PROJECT.md, restated for session-start visibility)` — inaccurate. Direction of reconciliation is a structural decision for Engineer (RFI-012 names three options).

**Finding 3 — INSP-001 LOW-3 (README phase-content drift) closes via 3.2.** Same finding as Section 2 carry-forward Finding 2; resolution is the README Status section update applied in Section 3.

**Finding 4 — Section 2 carry-forward Finding 1 (PROCEDURES.md "DONE-001 onwards") closes via 3.1.** Footnote applied; no retroactive DONE-001 backfill.

**Finding 5 — Section 2 carry-forward Finding 2 (README.md staleness) closes via 3.2.** Same as Finding 3.

### Notes

- **Both RFIs (-011 and -012)** advance the `Latest RFI` counter from RFI-010 to RFI-012. State/current.md counter updated at section close-out per the existing pattern; both added to `Open RFIs`.
- **No DEC, INC, or MS filed this section.** The two RFIs are the only forms-with-numbers filed; the four current-state staleness fixes (PROCEDURES.md footnote + README.md three updates: Status section + `.githooks/` parenthetical + file map) are content edits to existing files.
- **`.cspell.json` words extension applied during this session** — added `hase` and `rocedure` to the dictionary as artefacts of cspell's POSIX character-class tokenization. cspell parses bracket character classes inside backtick-wrapped inline code such that inputs like `[Pp]hase` and `[Pp]rocedure` tokenize as `Pp` + `hase` and `Pp` + `rocedure` respectively, flagging the partial words. One-line config change per `.cspell.json` `words` array, no DEC required per DEC-033 spirit (additive dictionary hygiene). Same operational pattern as Inspector's `INSP` addition in INSP-001 (operator-authorised at commit time as a DEC-033 tooling-config extension; no DEC). Engineer may consolidate at MS-011 if dictionary cleanup becomes a concern. Triggered by: Section 2's signed-off line 105 contains `[Pp]rocedure [0-9]+` from Builder's prior-session ID-reference walk; modifying signed-off content was the alternative resolution path, but operator chose dictionary extension at commit time. My own new content (RFI-011 + SIGN_OFF Section 3 Finding 1) was rephrased to avoid the bracket regex inline (POSIX-form regex now described in prose with a `scripts/validate.sh:253` cross-reference) before the cspell re-run; only the pre-existing Section 2 case required the dictionary touch.
- **Validator check 10 continues to PASS post-edits** — verified at sign-out before commit. The README's `## Status` section's first non-empty line still extracts `Phase 0b complete` identifier, matching state's `Current: Phase 0b complete.` → `state_phase` and `readme_phase` are equal. Section 3's substantive change (the active-MS tail being updated from MS-005 to the MS-009 → MS-010 → INSP-002 → MS-011 chain) doesn't affect check 10's regex output.
- **"For agents reading the code" subsection completeness** verified by H3 inventory across `PROJECT.md` lines 144-316 with block-aware filtering (the parent `## For agents reading the code` heading is at line 144; `### ` headings appear elsewhere in the file, e.g. inside Appendix A's outer text, so block-aware filtering matters). Future audit passes can re-derive the inventory from the same regex (`^### `) within the parent block.
- **RFI-011 chat-label collision** with Inspector's earlier reference: the "RFI-011 (Inspector doctrine path)" raised in chat during INSP-001 was *not* filed in `forms/RFI.md` (per Inspector's session-end handover note 5: "scope was Inspector-environment-only, not project-state"). Per working agreement #5 (the file is canonical, no skip-numbering), RFI-011 in this section's filing is the *first* sequentially-filed RFI-011. The chat-label collision is a procedural footnote, not a numbering error.
- **Section 3 sign-off in chat unlocks Section 4 (State integrity).** Per the MS-009 prompt rules of engagement: single-session completion of Section 3 alone is reasonable; Sections 3+4 in one session is not authorised. This session ends at the Section 3 boundary.

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
