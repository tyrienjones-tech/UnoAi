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

Status: signed off
Date filed: 2026-04-28
Date signed: 2026-04-28
Operator sign-off: Section 4 signed off by operator on 2026-04-28.

### Checklist results

- [x] **4.1 Phase line accurate.** `state/current.md:32` reads `Current: Phase 0b complete. Infrastructure phase in progress (MS-009). Phase 1 blocked on MS-009 close.` Phase identifier matches reality (MS-008 DONE; MS-009 in progress; Phase 1 not begun); validator check 10 PASS confirms README ↔ state phase-identifier sync. No drift in this line.
- [x] **4.2 Active MS line accurate (with one timestamp-context observation).** `state/current.md:38` reads `MS-009 in progress ... Sections 0-3 signed off (Section 3 magic-string applied at this session's sign-in per DEC-032 sixth exercise / fourth on SIGN_OFF.md surface); Sections 4-8 pending in subsequent sessions.` The "Sections 0-3 signed off / Sections 4-8 pending" status is correct as of pre-Section-4 state (HEAD `bb88533`). The "this session's sign-in" referent was the INSP-002 session at the time the line was authored (sign-out timestamp `2026-04-28 23:30`); a future-session reader would naturally re-bind "this session" to whatever the current sign-in is, which is benign in practice but worth flagging — the line will be rewritten at this Section 4 session's sign-out to reflect "Section 4 in progress" status going into MS-010-or-later sessions.
- [x] **4.3 Counters match highest-numbered actual entries.** Verified all five against form tail entries via grep:
  - `Latest MS:  MS-009` matches `forms/METHOD_STATEMENT.md` tail (`### MS-009 — Pre-Phase-1 deep check (8 sections, section-by-section sign-off, multi-session)`).
  - `Latest DEC: DEC-033` matches `forms/DECISION.md` tail (`### DEC-033 — Spell-check tooling locked`).
  - `Latest RFI: RFI-014` matches `forms/RFI.md` tail (`### RFI-014 — Email delivery mechanism for license tokens`).
  - `Latest INC: INC-009` matches `forms/INCIDENT.md` tail (`### INC-009 — Engineer heading-level transcription drift in INSP-002 session prompt`).
  - `Latest INSP: INSP-002` matches `forms/INSPECTION.md` tail (`## INSP-002 — External review consolidation ...`).
- [x] **4.4 MS chain status matches actual MS states.** Each line verified against `forms/DONE.md` and `forms/SIGN_OFF.md`:
  - MS-001: complete (no DONE — predates close-out-DONE convention; carve-out documented in `PROCEDURES.md:67` per Section 3.1 footnote) ✓
  - MS-002 through MS-008: each has a corresponding DONE entry (DONE-002, DONE-003, DONE-004, DONE-005, DONE-006, DONE-007, DONE-008) ✓
  - MS-009: in progress; Sections 0-3 signed off per `forms/SIGN_OFF.md` (each section's `Status: signed off` + `Operator sign-off: Section N signed off by operator on 2026-04-28.` populated); Sections 4-8 pending ✓
  - MS-010 / INSP-002 / MS-011 / [first Phase 1 MS]: pending; chain dependencies correctly described per the post-INSP-001 sequence updated in MS-009 Section 3 second-session sign-in ✓
- [x] **4.5 Open RFIs list matches RFIs in `RFI.md` not yet ANSWERED (post-Section-4-step-5c update).** Pre-Section-4 list contained RFI-009 + RFI-011 + RFI-012 + RFI-013 + RFI-014. Post Section-4-step-5c (RFI-012 ANSWERED via PROJECT.md-as-canonical resolution; see Finding 1), Open RFIs list now reads RFI-009 + RFI-011 + RFI-013 + RFI-014 (4 entries; RFI-012 moved to closure-line note alongside RFI-010). Verified no false negatives by grepping `forms/RFI.md` for `Operator decision:` lines: RFI-001..008 + RFI-010 + RFI-012 all show `ANSWERED`; RFI-009 + RFI-011 + RFI-013 + RFI-014 all show `pending`.
- [x] **4.6 Pending operator actions list cleaned up.** See Finding 2 below for itemised disposition. Pre-Section-4 list had 6 entries; post-Section-4 list has 5 entries (one removed as obsolete: README self-hosting wording amendment was already shipped via operator commit `bf2d661` per `DONE-005` close-out evidence; one annotated with RFI-013 dependency: Cloudflare Pages account creation; one annotated with verification context: GitHub repo description checked via API at this section, still "Name is place holder"; three unchanged: Lemon Squeezy, Worker secret store, Domain registrar).
- [x] **4.7 Engineer working agreements list complete (1-20), sequentially numbered, no skips.** Verified `state/current.md:107-126` contains entries #1, #2, #3, #4, #5, #6, #7, #8, #9, #10, #11, #12, #13, #14, #15, #16, #17, #18, #19, #20 — sequential, no gaps, no duplicates. Working agreement #10 carries the documented numbering note from MS-005 (operator wrote "#11" when introducing it; Builder renumbered to next-sequential #10 per discipline #5; never corrected at DONE-005 sign-off). Per Section 4 prompt scope: candidates #21-#24 from INSP-002 session are NOT added here — they're queued for MS-011 consolidation per discipline #5 (Engineer-authored work). Section 4 verifies the existing 20 only.
- [x] **4.8 Banned moves now match between PROJECT.md and state/current.md (10 items each, verbatim mirror; RFI-012 resolved per step 5).** Pre-Section-4 inspection: PROJECT.md had 9 items, state/current.md had 5 + 1 unique. Post Section-4-step-5b: PROJECT.md extended to 10 items (added: `` `Co-Authored-By Claude` footers on commits — operator-attributed commits only; AI-assistance attribution is a project policy decision filed as DEC if/when revisited.``), state/current.md banned moves replaced with the 10 PROJECT.md items verbatim. Mirror header `(mirror of PROJECT.md, restated for session-start visibility)` is now accurate. RFI-012 marked `ANSWERED 2026-04-28 via MS-009 Section 4 + INSP-002 MEDIUM-7` per step 5c. See Finding 1 for the divergence inventory and Finding 3 for one residual cross-reference observation.

### Findings

**Finding 1 — RFI-012 banned-moves divergence inventory and resolution applied (Section 4 step 5).** Pre-Section-4 state of the two banned-moves lists:

- `PROJECT.md:102-114` (header: `## Banned moves`) — 9 bullets: (1) MS-discipline / mutation; (2) DONE-proof; (3) top-level dependency without DEC; (4) CHANGE_ORDER for scope; (5) user-conversation server storage; (6) targeting minors; (7) LLM-via-our-proxy; (8) persona promises/love/substitution; (9) sensitive-content commits.
- `state/current.md:128-134` (header: `## Banned moves (mirror of PROJECT.md, restated for session-start visibility)`) — 5 abbreviated bullets + 1 unique bullet: (i) "No code changes without an MS"; (ii) "No silent fixes outside scope"; (iii) "No commits with secrets (gitleaks-enforced)"; (iv) **"No Co-Authored-By Claude footers on commits"** (no equivalent in PROJECT.md); (v) "Persona: no permanence promises, no love claims, no substitute-for-humans framing".

Cross-walk: state items map approximately to PROJECT items 1, 4, 9, 8 (in that order); state's `Co-Authored-By` rule has no PROJECT.md equivalent; PROJECT.md items 2 (DONE proof), 3 (dependency-without-DEC), 5 (server storage), 6 (minors), 7 (proxy) had no state equivalent. The mirror-claim header was inaccurate.

Resolution applied per Engineer's direction (resolved via INSP-002 MEDIUM-7 and chat-confirmed at Section 4 prompt): PROJECT.md becomes canonical, state/current.md mirrors verbatim, `Co-Authored-By Claude` rule added to PROJECT.md as the 10th banned move (formalises the operator-attributed-commits-only scope established during MS-003 commit-attribution decisions). PROJECT.md now has 10 items; state/current.md now has the same 10 items verbatim. RFI-012 marked ANSWERED in `forms/RFI.md` with resolution citing this Section 4 work and INSP-002 MEDIUM-7. `Open RFIs` list in `state/current.md` updated to drop RFI-012 (and the closure-line note added alongside the existing RFI-010 closure note).

**Finding 2 — Pending operator actions list audit (Section 4 step 6).** Pre-Section-4 list (`state/current.md:75-81`) had 6 entries; post-Section-4 list has 5. Per-item disposition:

- *Cloudflare Pages account creation* — **STILL BLOCKING** Phase 1 deployment. **Annotated** to flag RFI-013 dependency: if operator approves the Engineer's lean (migrate to Workers before v1 deploy), this item converts to "Cloudflare Workers account creation" rather than Pages. Item kept in list with the RFI-013 conditional spelled out inline.
- *Lemon Squeezy account + store + $9 placeholder product* — **STILL BLOCKING** Phase 1 payment flow. No status change observed. Item unchanged.
- *Worker secret store ready for Ed25519 private key* — **STILL BLOCKING** Phase 1 webhook handler. No status change observed. Item unchanged. (Compatible with both Pages-with-Functions and Workers-only, so RFI-013 outcome doesn't change this item's wording.)
- *Domain registrar account + domain selection* — **STILL DEFERRED** per RFI-009 (TLD selection still operator-pending; pre-Phase-8 deadline). Item unchanged.
- *GitHub repo description update* — **STILL PENDING** confirmed via GitHub API at this section: `https://api.github.com/repos/tyrienjones-tech/UnoAi` returned `"description": "Name is place holder"`. **Annotated** with verification context (date and method). Item kept in list.
- *Optional: README self-hosting wording amendment (deferred to MS-003.5 or roll into Phase 1 prep)* — **OBSOLETE** (work was actually completed). Operator commit `bf2d661` shipped the wording amendment; the accompanying ##→plain heading drop was caught and fixed in MS-005 per `DONE-005` evidence (`forms/DONE.md:472, 629`). MS-003.5 was never filed because the wording itself "remains as `bf2d661` set it" per DONE-005 close-out. Item **REMOVED** from the list. The current `README.md:13-19` Self-hosting section is the operator's intended final wording.

**Finding 3 — Verbatim mirror introduces one residual cross-reference observation (informational, not blocking).** PROJECT.md banned-moves bullet 9 ends with `Commits any item from the **Sensitive content** list below, in any branch, ever.` The phrase `**Sensitive content** list below` is a forward-reference to the `## Sensitive content — never committed (per DEC-025)` section that immediately follows banned-moves *inside PROJECT.md*. After Section 4's verbatim copy into state/current.md, the same bullet text appears in state/current.md but no `Sensitive content` section follows it there. Reader-impact: a reader of state/current.md who reads the verbatim mirror without context would see `below` and not find a target in state/current.md; the mirror header `(mirror of PROJECT.md, restated for session-start visibility)` is intended to anchor the reader back to PROJECT.md as the source. Per the Engineer's verbatim-mirror direction, the bullet stays as-is; this observation is logged here as a known property of the mirror approach, not a fix-now item. Engineer may revisit at MS-011 or later if state/current.md mirror-quality concerns surface.

**Finding 4 — Active MS line carries a self-referential "this session's sign-in" phrase that re-binds across sessions (informational).** `state/current.md:38` was authored in the INSP-002 session and uses the phrase "Section 3 magic-string applied at this session's sign-in" with "this session" referring to the INSP-002 sign-in (timestamp `2026-04-28 23:16`). When read at the next sign-in (this Section 4 session's sign-in), "this session" naturally re-binds to a different session and is therefore mildly misleading on the historical referent. The line will be rewritten at this Section 4 session's sign-out per standard sign-out state-update procedure — a benign turnover artefact rather than a structural issue. Logging here so future state-integrity audits know this line's `this session` phrasing rotates with each sign-out.

### Notes

- **Section 4 deliberately does not touch INSP-001 or INSP-002 findings.** Per the Section 4 prompt's scope guards: INC-007/008/009 work (already closed at INSP-002 session), INSP-001 / INSP-002 findings (MS-010 territory), validator hardening (MS-010 territory), cspell dictionary cleanup (MS-010 territory), CO-001 numbering gap (MS-010 territory), and working-agreements consolidation (MS-011 territory) all remain out of scope. Any Section 4 findings outside scope are documented as findings with routing notes (e.g. Finding 3's observation about the verbatim-mirror cross-reference: noted, not actioned, available for Engineer to scope at MS-011 if desired).
- **Working-agreement candidates from INSP-002 (#21-#24) deliberately not added in Section 4.** Per the prompt: "Section 4 verifies the existing 20 working agreements only" and "candidates #21-#24 from INSP-002 session are NOT yet added — they're queued for MS-011 consolidation per discipline #5 (Engineer-authored work)." Confirmed: no #21-#24 entry was authored in this section.
- **Single-section session per MS-009 prompt rules of engagement.** Section 4 only; Section 5 (form integrity + 11th validator check) is the largest remaining section and warrants fresh-session focus per the prompt's "Rules of Engagement" — explicitly NOT continued in this session.
- **Pause-at-blocker discipline operated zero times this session.** All Section 4 work fit within either the explicit step instructions (steps 4-7) or the documented Engineer's-direction-confirmed resolution (step 5b/c on RFI-012). No structural ambiguities surfaced. Working agreement #18 (explicit-approval-per-step) had no triggering moments — the Section 4 prompt itself encoded the approval for the RFI-012 resolution direction and the steps 4-7 audit work.
- **No new numbered entries (DEC / RFI / INC / MS) filed this section.** RFI-012 was *closed* (status field changed from `pending` to `ANSWERED`), no new RFI / INC / DEC was filed. The only file-with-numbered-entries change is the SIGN_OFF Section 4 entry itself (which is not subject to validator numbering checks per `forms/SIGN_OFF.md` header).
- **Section 4 sign-off in chat unlocks Section 5 (form integrity + retroactive DONE sign-off + 11th validator check).** Per the MS-009 prompt scaffold, Section 5 is the largest remaining section. Next Builder session begins Section 5 in a fresh session.

---

## MS-009 Section 5 — Form integrity + retroactive DONE sign-off + 11th validator check

Status: signed off
Date filed: 2026-04-29
Date signed: 2026-04-28
Operator sign-off: Section 5 signed off by operator on 2026-04-28.

### Checklist results

**Sub-scope 5A — Per-form integrity audits:**

- [x] **6a `forms/DECISION.md` (DEC-001..033).** Sequential numbering clean (validator check 1 PASS). Each entry carries Date / Decided by / Decision / Reason / Reversibility / Affects fields per template. Supersede chains resolve cleanly: DEC-014 supersedes DEC-003 ✓; DEC-015 supersedes DEC-004 ✓; DEC-009 supersedes DEC-005 ✓; DEC-007 supersedes earlier informal HMAC reference (prose form, no orphan); DEC-008 supersedes RFI-004 lean (prose form). Validator check 6 PASS confirms every `Supersedes:` line points to an existing prior DEC. DEC-013 Tailwind v4 sign-off line **NOT** added per scope guard (INSP-002 LOW-5 routing → MS-010); DEC-013 still carries `**Operator confirmation needed at MS-003 close**` from MS-003. Documented as deferred, not new finding. DEC-003 + DEC-004 retain `Status: pending operator confirmation` because both are append-only historical text — they are *superseded* by DEC-014 / DEC-015 respectively (resolved via Supersedes chain), not retroactively rewritten.
- [x] **6b `forms/RFI.md` (RFI-001..014).** Sequential numbering clean (validator check 2 PASS). Each entry has clear status: ANSWERED with closure citation OR pending. Open RFIs verify as the expected four — RFI-009 (TLD, pending operator), RFI-011 (validator check 10 design tightness, pending Engineer scoping), RFI-013 (Pages → Workers timing, pending operator), RFI-014 (email delivery mechanism, pending operator). RFI-012 properly carries `Operator decision: ANSWERED 2026-04-28 via MS-009 Section 4 + INSP-002 MEDIUM-7` per Section 4 closure. ANSWERED RFIs cite the closing DEC (RFI-001→DEC-014, RFI-002→DEC-015, RFI-005→DEC-016, RFI-006→DEC-021, RFI-007→DEC-019, RFI-008→DEC-018, RFI-010→DEC-032) or MS (RFI-012→MS-009 Section 4).
- [x] **6c `forms/INCIDENT.md` (INC-001..009).** Sequential numbering clean (validator check 3 PASS). Each entry carries root cause / resolution / lesson sections (INC-007/008/009 use `### Root cause` / `### Resolution` / `### Lesson` H3 sub-headings; INC-001..006 use `**Root cause:** ... **Action taken:** ... **Lessons:** ...` bold-prefix style — both are valid INCIDENT.md conventions established by existing entries). All historical incidents resolved. INC-007/008/009 (filed in INSP-002 session) verify as properly structured — body content matches Engineer-supplied verbatim text, H3 heading-marker convention applied per INC-009's resolution.
- [x] **6d `forms/METHOD_STATEMENT.md` (MS-001..009).** Sequential numbering clean (validator check 4 PASS). MS-001 through MS-008 each have a corresponding DONE entry (DONE-002 through DONE-008; MS-001 carve-out documented in `PROCEDURES.md:67` footnote per Section 3.1). MS-009 in progress (no DONE-009 yet — correct). One finding flagged on field population: see Finding 1 below.
- [x] **6e `forms/DONE.md` (DONE-002..008).** Sequential numbering clean (validator check 4-equivalent — DONE.md isn't directly numbered-checked but check 9's done_mses parser inventories cleanly). DONE-001 absent by design (MS-001 predates the DONE convention; carve-out per `PROCEDURES.md:67` footnote — not a numbering gap). DONE-002..008 each carry Acceptance criteria + Builder-produced proof. Operator-captured proof present for DONE-003..008 (UI / scaffold / commit-state work); absent for DONE-002 by design (template comment "where applicable to the phase" + DONE-002 sign-off-notes line documents "Likely no visual proof needed per MS-002 (doc work only)"). Sign-off field present for each DONE; **all seven now populated** post Sub-scope 5B (DONE-002..006 magic-strings applied this session; DONE-007 + DONE-008 already populated from MS-008 / MS-009 session sign-ins).
- [x] **6f `forms/SITE_LOG.md` sign-in / sign-out pairing.** Validator check 8 (session lifecycle) PASS — exactly one open session (this Section 5 session's sign-in) without matching sign-out. Chronological order preserved. No orphaned sign-ins from prior sessions (each prior sign-in has a matching sign-out from the same date).
- [x] **6g `forms/CHANGE_ORDER.md`.** Entries section is empty (line 86 onwards is just the `<!-- Append below this line. -->` comment); no real CO entries filed yet. Template at line 12 uses `CO-NNN`; example at line 53 uses `CO-002`. The template/example CO-002 numbering gap (CO-002 in example without CO-001 in template/entries) is documented in INSP-002 LOW-1 → MS-010 routing. Documented as deferred, not new finding.
- [x] **6h `forms/SIGN_OFF.md`.** Sections 0-4 marked signed off (Section 4 magic-string applied at this session's sign-in per DEC-032 seventh exercise). Section 5 (this entry) `Status: in progress` with all sub-scope 5A/5B/5C work documented. Sections 6-8 still scaffolded `Status: pending`.
- [x] **6i `forms/INSPECTION.md`.** INSP-001 (filed at c655dab) and INSP-002 (filed at bb88533) both present and structured per template (Date / Inspector / Scope / Repo state / Files reviewed / Methodology / Summary / Findings by severity / Open questions / Recommended next inspection / Cross-references). INSP cross-references inside INSP-002 resolve to existing entries (INSP-001 ✓, INC-008 ✓, RFI-012 ✓, RFI-013 ✓, RFI-014 ✓). The INSP-002 Cross-references block does NOT name INC-007 (pre-existing-deferred) or INC-009 (surfaced after INSP-002 was drafted) — documented in MS-009 Section 4 SITE_LOG handover note 6 per the verbatim-preservation rule (Builder did not retroactively edit INSP-002's Cross-references). The INSP-002 Cross-references RFI-012 entry says `(banned moves divergence, open) — resolution routed to MS-010 per MEDIUM-7`; this is now stale because RFI-012 was actually resolved in Section 4 itself (not routed to MS-010). Same verbatim-preservation rule applies; logged here as a known property of the append-only convention rather than as a new finding.

**Sub-scope 5B — Retroactive DONE sign-off cleanup (FIRST application of DEC-032 to historical entries):**

- [x] DONE-002 `Operator sign-off:` field updated `pending.` → `DONE-002 signed off by operator on 2026-04-27.` (verbatim per Engineer-supplied magic-string).
- [x] DONE-003 `Operator sign-off:` field updated `pending.` → `DONE-003 signed off by operator on 2026-04-27.` (verbatim per Engineer-supplied magic-string).
- [x] DONE-004 `Operator sign-off:` field updated `pending.` → `DONE-004 signed off by operator on 2026-04-28.` (verbatim per Engineer-supplied magic-string).
- [x] DONE-005 `Operator sign-off:` field updated `pending.` → `DONE-005 signed off by operator on 2026-04-28.` (verbatim per Engineer-supplied magic-string).
- [x] DONE-006 `Operator sign-off:` field updated `pending.` → `DONE-006 signed off by operator on 2026-04-28.` (verbatim per Engineer-supplied magic-string).
- [x] All five strings applied verbatim per working agreement #11 (Engineer-supplied content goes in unchanged). Dates reflect operator's actual chat sign-off timing for each DONE entry. Note: DONE-002's commit lineage differs from DONE-003..006 — MS-002 was documentation-only and landed inside the MS-003 migration commit (`0cf45cd`) rather than its own close-out commit. The close-out-commit pattern became standard from MS-003 onward. DONE-002 was operator-signed in chat at the time; the retroactive sign-off applies anyway. This is the **first application of DEC-032 to historical entries** (prior DEC-032 exercises were forward-looking from DONE-007 onwards starting at MS-008 sign-in).

**Sub-scope 5C — 11th validator check shipped + synthetic-tested:**

- [x] **Check 11 implementation in `scripts/validate.sh`:** parses `forms/DONE.md` for each DONE entry's `Method statement: MS-NNN` and `Operator sign-off:` lines, builds the set of MSes whose DONE has a non-pending sign-off (sign-off considered "signed" if its trimmed value does NOT match `[Pp]ending\.?\s*` — i.e. anything other than `pending` / `pending.` is treated as a magic-string per DEC-032). Then walks the same `Depends on: MS-NNN` lines that check 9 walks, FAILing with a specific message naming the source MS and the unsigned dependency. Skips targets that check 9 already failed on (DONE missing) to avoid double-fail noise. Implementation lives between check 10 and the Output block.
- [x] **README "10 checks" reference scan:** `README.md` carries no current-state numeric check count to update (only `scripts/validate.sh` path reference at file-map line 69). `GLOSSARY.md:161` `**validator**` definition was the only current-state mention of "10 checks" / "11th deferred"; updated to "11 checks" with DEC-032 enforcement called out and the MS-009 Section 5 ship-event noted. Historical-record references in `forms/DONE.md`, `forms/METHOD_STATEMENT.md`, `forms/SIGN_OFF.md` (Section 3 entry), `forms/SITE_LOG.md` (prior session entries), and `forms/DECISION.md` DEC-026 left untouched per append-only convention.
- [x] **Validator header comment block updated:** lines 7-37 of `scripts/validate.sh` rewritten — opening line now says `(eleven — see DEC-026 + INC-006 + MS-005 Scope A + MS-006 Scope G + MS-009 Section 5)`; check 9 description revised so its trailing sentence reads "check 11 below tightens this to DONE-signed" instead of the prior "deferred to MS-007"; new check 11 description added after check 10; the standalone `Deferred check 11` block at lines 27-37 removed (replaced by the new check 11 entry in the numbered list).
- [x] **Synthetic test (working agreement #8 mandatory before shipping tooling):**
  - **Pre-toggle baseline:** `bash scripts/validate.sh` → `VALIDATOR: PASS`, exit 0.
  - **Synthetic violation injected:** DONE-008 `Operator sign-off:` field temporarily reverted from `DONE-008 signed off by operator on 2026-04-28.` to `pending`.
  - **Post-toggle:** `bash scripts/validate.sh` → `VALIDATOR: FAIL`, exit 1, with the specific message `DONE sign-off: MS-009 cannot proceed — depends on MS-008 whose DONE entry has 'Operator sign-off: pending' (not signed). DEC-032 magic-string must be applied at next session sign-in.` Confirms the check fires, names both the source MS (MS-009) and the unsigned dependency (MS-008), and references the resolution path (DEC-032 magic-string at next sign-in).
  - **Revert:** DONE-008 `Operator sign-off:` field restored to `DONE-008 signed off by operator on 2026-04-28.`
  - **Post-revert:** `bash scripts/validate.sh` → `VALIDATOR: PASS`, exit 0. Clean state confirmed.
- [x] **Validator size after addition:** `wc -l scripts/validate.sh` reports 324 lines (was 289 lines pre-Section-5; net +35 lines). Per working agreement #10 (validator size budget retired in favour of per-check complexity calibration; the budget is wrong, not the script): the +35 lines decompose as ~13 lines of header comment block update (rewriting the `(ten — ...)` line, adding check 11 description, removing the deferred-check-11 block) + ~22 lines of new implementation code (signed_mses awk parser ~16 lines + while-loop walk ~6 lines). No size cap exceeded; no compression pressure.

### Findings

**Finding 1 — MS template + MS-001..MS-004 lack explicit `**Depends on:** / **Blocks:**` field lines** (routing: MS-010 / MS-011 territory; documented here as audit-not-fix per scope guards).

INC-006 (MS-004 H2d shortfall) claims H2a, H2b, H2c shipped while H2d (validator chain check) did not, with H2d folded into MS-005. Specifically, INC-006 asserts H2b shipped — "MS template 'Depends on / Blocks' fields" — and H2c shipped — "retroactive lines on MS-001/002/003".

Section 5 audit verifies neither claim is reflected in the current file:

- **Template** (`forms/METHOD_STATEMENT.md:7-39`) does not contain `Depends on:` or `Blocks:` field placeholders; the template's bullet list ends at `Linked RFIs / decisions:` and proceeds straight into `Plan (numbered, terse):`.
- **Example** (`forms/METHOD_STATEMENT.md:43-78`) likewise has no `Depends on:` / `Blocks:` lines.
- **MS-001..MS-004 entries** carry no `^- \*\*Depends on:\*\*` lines (verified via Grep across all entries; only MS-005 line 510, MS-006 line 655, MS-007 line 843, MS-008 line 988, MS-009 line 1162 have explicit `Depends on:` field lines). No MS entry uses `Blocks:` at all.

This means validator's check 9 (chain check) and the new check 11 (sign-off enforcement) only validate the MS-005-onwards portion of the chain. MS-001..MS-004 are invisible to both checks — accidental clean state today because all four are DONE and signed, but a chain check that doesn't validate the start of the chain has reduced coverage.

Routing options for Engineer to scope:
- **MS-010 territory** — alongside other validator hardening (RFI-011 check-10 design tightness, INSP-001 MEDIUM-3 hook tamper-detection).
- **MS-011 territory** — as a procedural-discipline finding alongside the working-agreements consolidation work and the Engineer "verify before asserting" pattern (#21-#24 candidates from INSP-002 session).

This finding is **audit-not-fix per scope guards**: per the operator-validated rule on MS-009-style audits, when audit catches divergence already routed to a future MS family, document as finding only; do not reconcile in-section. The MS template + retroactive MS-001..MS-004 backfill belongs in the same MS-010-or-MS-011 batch as the rest of the validator hardening work; not in Section 5.

**Finding 2 — Documented-as-deferred items confirmed in current state (no new findings; explicit re-listing for sign-off audit-trail completeness):**
- DEC-013 Tailwind v4 sign-off line — still carries `**Operator confirmation needed at MS-003 close**` text; INSP-002 LOW-5 routes to MS-010.
- CO-001 numbering gap — `forms/CHANGE_ORDER.md` template at line 12 uses `CO-NNN` placeholder, example at line 53 uses `CO-002`; no real CO-NNN entries; INSP-002 LOW-1 routes to MS-010.
- INSP-002 Cross-references block stale on RFI-012 (calls it "open" / "routed to MS-010" when it was actually closed in Section 4) — append-only verbatim convention preserves the as-drafted text.
- INSP-002 Cross-references block missing INC-007 + INC-009 — same append-only verbatim preservation rule (operator's Section 4 SITE_LOG handover note 6 documented this).
- RFI-011 (validator check 10 design tightness) — pending Engineer scoping into MS-010 / MS-011 per Section 3 finding.
- DONE-002 has no Operator-captured proof header — by design (documentation-only MS); template phrase "where applicable to the phase" supports this; sign-off-notes line documents "Likely no visual proof needed per MS-002 (doc work only)." Not a finding, listed for completeness.

### Notes

- **Order of execution non-negotiable:** 5A → 5B → 5C ran in that order. Sub-scope 5C's check 11 would have FAILed on the very entries it's designed to validate (DONE-002..006) if it had shipped before Sub-scope 5B retroactive cleanup. Working agreement #8 (synthetic tests before shipping tooling) requires the check pass on clean state before going live; Sub-scope 5B getting the state clean before 5C ships the check is the order this constraint imposes.
- **DEC-032 first application to historical entries.** All prior DEC-032 exercises (DONE-007 at MS-008 sign-in, DONE-008 at MS-009 sign-in, then SIGN_OFF.md Sections 0-4 across MS-009 sign-ins #2-#5) were forward-looking — magic-strings copied from chat into entries as they were freshly signed. Sub-scope 5B retroactively applies the mechanism to DONE entries operator-signed in chat months earlier (per the dates: DONE-002 + DONE-003 on 2026-04-27; DONE-004 + DONE-005 + DONE-006 on 2026-04-28). The DEC-032 entry's `Affects` line foresaw this — "Existing DONE-002 through DONE-006 to be cleaned up retroactively at MS-008 (Section 5 — form integrity audit)" — though the actual cleanup landed at MS-009 Section 5 rather than MS-008 because MS-008 ended up scoped to glossary + cspell tooling instead of form integrity. The MS-008 deferred-check-11 header comment in `scripts/validate.sh` lines 27-37 was the inherited deferral from that re-scoping; it's now removed in favour of check 11's actual implementation.
- **Working agreement #8 produced durable evidence.** The synthetic test outputs documented above (PASS → FAIL with specific message → PASS) are the exact pattern the working agreement was written to produce: the validator's behaviour on a known-bad input is captured in the SIGN_OFF entry as the proof artefact, so future Engineer verification doesn't require re-toggling the field. Same precedent established at MS-005 (chain-check synthetic test for both target-missing and target-undone branches) and MS-006 (README ↔ state-sync synthetic test).
- **Validator size posture stable.** 324 lines (11 checks). Per working agreement #10 the budget retiring decision from MS-005 onwards continues — caps are calibrated against per-check complexity, not against fixed line counts. Check 11's +35 lines is in line with check 10's pre-shipped budget (40 lines for the 10th check per `state/current.md` MS-006 history line 97). No compression pressure surfaced this section.
- **No new numbered entries (DEC / RFI / INC / MS) filed this section.** The only file-with-numbered-entries change is the SIGN_OFF Section 5 entry itself (which is not subject to validator numbering checks per `forms/SIGN_OFF.md` header). All other file changes are field updates inside existing entries (DONE-002..006 sign-off fields, GLOSSARY.md validator definition, scripts/validate.sh check 11 implementation + header comment block, state/current.md MS chain + Active MS + Updated timestamp + Last verified working state, forms/SIGN_OFF.md Section 4 magic-string + Section 5 entry).
- **Section 5 sign-off in chat unlocks Section 6 (tooling end-to-end).** Per the MS-009 prompt scaffold, Section 6 is the cold-clone test at `/tmp/unoai-cold-clone` plus all five hook synthetic tests plus cleanup. Next Builder session begins Section 6 in a fresh session.

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
