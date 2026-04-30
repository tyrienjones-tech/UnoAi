# Incident log

Append-only. File for any failure, surprise, revert, or unexpected behaviour. Numbered INC-001 onwards.

**No blame, just facts.** The point is patterns, not punishment.

Even one-line entries are valuable. If you're not sure whether to file an incident, file it.

---

## Template

```
### INC-NNN — [short title]
- **Date:** YYYY-MM-DD HH:MM
- **Agent:** [name]
- **Severity:** low / medium / high
- **Phase:** [number + name]

**What happened:**
[Plain-English description. What was being attempted, what actually occurred.]

**Blast radius:**
[Files affected, users affected, data affected, time lost. "None" is a valid answer.]

**How detected:**
[Operator noticed / test failed / agent self-reported / user reported / production alarm]

**Action taken:**
[Reverted commit / restored data / no action needed / etc.]

**Linked to:**
[MS-NNN, DEC-NNN, CO-NNN if applicable]

**Lessons:**
[What would have prevented this. Even "nothing actionable" is a valid answer if true. Avoid blame, focus on the procedural or design gap.]
```

---

## Example

```
### INC-001 — License key validation accepted bad keys
- Date: 2026-04-28 11:14
- Agent: Reaper-1
- Severity: medium
- Phase: 1 — Landing + payment + license

What happened:
While testing Phase 1 acceptance, a malformed license key (random base64 string of correct length) passed the in-app validation check. Should have failed signature verification.

Blast radius:
Test environment only. No production impact. Test data only.

How detected:
Operator was testing acceptance criteria for DONE-002, tried a deliberately wrong key.

Action taken:
- Reverted commit a3f2c1d
- Re-implemented Ed25519 signature verification with the public key constant correctly committed (private key remains in Worker secrets only)
- Added a unit test for known-bad keys
- New commit: f1e2d3c

Linked to: MS-002, DONE-002 (revoked sign-off)

Lessons:
The acceptance criteria didn't include negative tests ("verify a known-bad key is rejected"). Should add "negative case" to default acceptance criteria template for any validation work.
```

---

## Entries

<!-- Append below this line. -->

### INC-001 — Engineer halt left handover package in inconsistent state
- **Date:** 2026-04-27 22:10
- **Agent:** Reaper-1
- **Severity:** low
- **Phase:** 0 prep (pre-0a)

**What happened:**
The Engineer was making in-package fixes and halted mid-edit. The operator-prompt-stated intent for items A, B, C, D, F did not all land in the file content. Specific gaps as found:

- **A (RFI-006):** absent entirely in `forms/RFI.md`. Engineer's stated intent says it should exist with a proper header and the 2% FN / 10% FP thresholds; file content had RFI-001..005 only.
- **B (DEC-013):** absent entirely in `forms/DECISION.md`. Engineer's stated intent says it should be pre-named for Phase 0b; file content had DEC-001..012 only.
- **B (DEC-008 "Known costs"):** absent. Engineer's stated intent (per Reaper PB1) says it should include latency / token-spend / failure-mode-policy values; file content had no such subsection.
- **C (DONE.md proof split):** absent. Engineer's stated intent (per DEC-011) says template + example should split Builder-produced / Operator-captured; file content had a single flat "Proof:" block.
- **D (README file map):** ASCII file-map line still said "the six rules" while header at line 12 had been corrected to "seven". Partial fix.
- **F (Phase 6 thresholds + fixture path):** absent. Engineer's stated intent (per Reaper N3 + N4) says PLAN.md Phase 6 should specify `/test/fixtures/crisis_prompts.json` and 2% FN / 10% FP thresholds; file content had only "false-positive + false-negative rates" with no values and no file path.

The operator prompt also referenced "a self-incident logged during the edit" — no such INC entry was present in `forms/INCIDENT.md` (Entries section was empty). INC-001 (this entry) is the first incident on file.

**Blast radius:**
None to product. Documentation only. Phase 0a/0b is not yet started, so no downstream code or commits depend on the halt-state.

**How detected:**
Reaper-1 verification pass during MS-001 cleanup, comparing copied source files against the operator's A–G checklist via grep + targeted reads.

**Action taken:**
- Applied direct fixes for D and F (file-map line, Phase 6 thresholds + fixture path).
- Inserted "Known costs" subsection into DEC-008 using values from prior Reaper PB1 review.
- Authored DEC-013 as a structural placeholder (title + "TO BE FILLED" body) for Builder to populate in Phase 0b.
- Authored RFI-006 mirroring RFI-005 structure, using the 2%/10% values and fixture path stated in the operator prompt. Pushback recorded in SITE_LOG and as an inline Builder-note in the RFI-006 entry: this content is normally Engineer-authored.
- Split DONE.md proof section in both template and example per DEC-011.
- All changes recorded in MS-001.

**Linked to:** MS-001.

**Lessons:**
- "Engineer in-package edit" is a multi-write workflow that benefits from the same proof discipline as the Builder. A fast `grep` checklist after editing — does the file content actually contain what the edit summary claims? — would have caught all of these before halt.
- Issues authored by the Builder that are normally the Engineer's (RFI content, DEC content) should always carry a "Builder note" line in the entry itself, not just in SITE_LOG. RFI-006 and DEC-013 follow this pattern.
- "Pre-named placeholder" entries (DEC-013) are useful — they reserve the number and prevent collision — but the placeholder body should be authored by whoever knows the intent, not invented downstream. DEC-013 here is structural only; its body is left blank for the Phase 0b filler.

---

### INC-002 — README "Phase 0" status line inconsistent with PLAN.md 0a/0b split
- **Date:** 2026-04-27 22:11
- **Agent:** Reaper-1
- **Severity:** low
- **Phase:** 0 prep (pre-0a)

**What happened:**
Off the A–G checklist. README.md line 47 read "Phase 0 not yet started" but PLAN.md was already split into Phase 0a (Operator setup) and Phase 0b (Builder scaffolding) per the Engineer's prior fix to issue F. The README status line had not been updated to match.

**Blast radius:**
None. Documentation only.

**How detected:**
Reaper-1 noticed during the README line-32 "six rules" → "seven rules" fix.

**Action taken:**
Updated README.md line 47 to "Phase 0a/0b not yet started." Logged here per the operator-prompt instruction to file off-list consistency fixes as INCIDENT entries.

**Linked to:** MS-001.

**Lessons:**
- A "rename one thing, find all references" sweep is cheap and is the sort of thing the Engineer's edit-checklist should include going forward.

---

### INC-003 — Engineer pattern: DECs reference RFIs not present in source
- **Date:** 2026-04-27 22:30
- **Agent:** Reaper-1 (logged at operator's suggestion in MS-002 approval)
- **Severity:** low
- **Phase:** 0 prep (pre-0a)

**What happened:**
Pattern observed across two MSes now. Engineer authored DECISION entries that close RFIs which had not been opened in `forms/RFI.md`:

- **MS-001:** DEC-013 was added by the Engineer pre-Reaper review as a "pre-named placeholder" but no corresponding pre-fill content existed. (Resolved by Reaper authoring a structural stub.)
- **MS-002:** DEC-018 carried `Closes: RFI-008` and DEC-019 carried `Closes: RFI-007` — but neither RFI-007 nor RFI-008 was present in `forms/RFI.md`. The closure references made the cross-reference web claim more than the file content delivered.

In both cases, the operator-stated intent was for the RFIs to exist (operator's MS-002 approval explicitly authorised retroactive authoring); the gap was procedural-on-Engineer-side, not decision-on-operator-side.

**Blast radius:**
None to product. Documentation only. Builder time spent reconstructing question content from DEC alternatives sections. ~10 minutes in MS-002.

**How detected:**
Reaper-1 verification pass during MS-002 scope review. Cross-reference grep of `Closes: RFI-NNN` lines in DECISION.md against RFI headers in RFI.md.

**Action taken:**
- MS-001: DEC-013 placeholder authored.
- MS-002: RFI-007 and RFI-008 authored as historical-record reconstructions, with Builder-notes inline indicating that the question content was reconstructed from DEC-019 and DEC-018 alternatives sections respectively. Operator approved the historical-reconstruction approach in MS-002.
- This INC entry filed at operator's suggestion in MS-002 approval, naming the pattern.

**Linked to:** MS-001 (DEC-013 placeholder), MS-002 (DEC-018, DEC-019, RFI-007, RFI-008).

**Lessons:**
- **Engineer discipline going forward:** any new DEC that closes an RFI must verify the RFI exists in `forms/RFI.md` first, or open it in the same MS that introduces the DEC. The cross-reference web is not free — closures point at something that has to exist.
- **Builder discipline:** continue grepping for `Closes: RFI-` and `(per RFI-` references in incoming MS scope and verify each target exists in source before applying. Catching this at MS-write time is cheaper than reconstructing later.
- **Procedural-not-personal:** Engineer is the chat agent; cross-session memory of "did I file that RFI?" is genuinely hard. The fix is process (verify-before-close), not blame.

---

### INC-004 — Stale $39 references survived PM2's scope-limited price update
- **Date:** 2026-04-27 22:35
- **Agent:** Reaper-1
- **Severity:** low
- **Phase:** 0 prep (pre-0a)

**What happened:**
MS-002 PM2 instruction was scope-limited to "the Pricing section" of PROJECT.md. Two `$39` references outside that section survived:

- **PROJECT.md line 9 (`What this is` intro):** "Browser-based AI companion app. Buy once ($39)..." — out of the Pricing section, but the same product. Stale after DEC-014.
- **PLAN.md Phase 1 line 55 (goal statement):** "Goal: the public can pay $39 and receive a license key by email." — out of any "Pricing section" scope, but specifies the price.

Cross-reference grep during MS-002's post-apply sweep caught both.

**Blast radius:**
None to product. Documentation only.

**How detected:**
Reaper-1 cross-reference grep during MS-002 post-apply sweep: `\$39|HMAC|pending operator confirm|Phase 0 not yet|the six rules`. Filtered out historical-record hits (DEC-003 superseded text, DEC-007 alternatives, INCIDENT historical descriptions, RFI-001 example block); two genuine stale references remained.

**Action taken:**
- Fixed both: $39 → $9 in PROJECT.md line 9 and PLAN.md Phase 1 line 55.
- Filed this INC entry per the operator-prompt rule: off-list consistency fixes go in INCIDENT.md.

**Linked to:** MS-002 (PM2 scope), DEC-014.

**Lessons:**
- Same lesson as INC-002: "rename one thing, find all references." Builder's post-apply grep sweep is the right place to catch this; doing it before declaring DONE-002 is the standard pattern going forward.
- Engineer's MS instructions that scope-limit by section heading should consider whether other sections name the same value. PM2 should probably have read "Update every $39 reference in PROJECT.md to $9 (Pricing section, intro, anywhere else)." Worth mentioning in MS-002 SITE_LOG as a procedural refinement, not a blocker.

---

### INC-005 — Project folder migrated from Chat2U to UnoAi; auto-init commit found on remote
- **Date:** 2026-04-27 23:30
- **Agent:** Reaper-1
- **Severity:** low
- **Phase:** 0b — Builder scaffolding

**What happened:**
Two related findings during MS-003 Scope A:

1. **Migration:** Following operator's product-name decision (DEC-023, locked as **UnoAi**), the working folder migrated from `C:\Users\Tyrien\Desktop\Chat2U` to `C:\Users\Tyrien\Desktop\UnoAi`. The Chat2U folder is preserved as the rollback path until DONE-003 sign-off, after which operator decides retention.

2. **Auto-init commit on remote:** Cloning the empty UnoAi repo revealed that GitHub had pre-created an `Initial commit` (372902c) containing an auto-generated `README.md` ("# UnoAi / Name is place holder"). Operator's MS-003 said "no init files" but GitHub's repo-creation UI had inserted one (likely the "Add a README file" checkbox at create-time). This affects B8 push strategy: force-push to drop the auto-init vs layer our work as commit #2. Decision deferred to operator at B8 time per MS-003 Risk R10 (first-commit-defines-patterns).

**Blast radius:**
None to product. Documentation + working-folder migration only. No code committed yet, no remote history modified. All current work is local in `C:\Users\Tyrien\Desktop\UnoAi`.

**How detected:**
- Migration: planned action under MS-003 Scope A.
- Auto-init commit: noticed during `git log --oneline` after clone — the repo had `372902c Initial commit` already.

**Action taken:**
- Migration: `cp` of all 11 markdown files from `Chat2U/` (4 root + 7 forms) into `UnoAi/`. `diff -rq` verified zero content drift.
- Name swaps applied per the operator's judgment-call rule: README.md L1 `# Companion` → `# UnoAi`, README.md file-map folder line `companion-project/` → `unoai/`, README.md status line updated to "Phase 0b in progress (MS-003)", PROJECT.md L1 `# Companion — Project induction` → `# UnoAi — Project induction`. All role-descriptor "companion" / "AI companion" uses preserved (PROJECT.md intro at line 9, persona section at line 76, Appendix A persona text at line 127). All historical-record entries in DEC bodies, INC bodies, RFI bodies, MS bodies, SITE_LOG entries left untouched.
- DEC-023 filed (product name lock). RFI-003 closed via DEC-023 with Builder-note flagging RFI-009 follow-up. RFI-009 filed (TLD selection, engineer's lean: `.com` first, `.app` fallback).
- Auto-init commit: surfaced to operator in chat as a paused B8-time decision; **not yet acted on**. Local working tree has migrated files staged on top of the existing 372902c commit. Operator decision needed at B8 push time: force-push to drop, or layer-on-top with adjusted commit message.
- Chat2U folder unchanged. Will not be modified or deleted until operator confirms post-DONE-003.

**Linked to:** MS-003, DEC-023, RFI-003 (closed via DEC-023), RFI-009 (newly filed).

**Lessons:**
- "Empty repo" via GitHub UI is not actually empty if "Add a README file" was checked at create-time. For future repos: uncheck that option at GitHub-create-time. If it's already there, decide force-push-vs-layer at first-commit time, never silently. Pattern named so future MSes around new-repo-creation can verify upfront.
- Migration via `cp -r` was clean on Windows bash; `diff -rq` is the right verification step.

---

### INC-006 — Chain mechanism partially shipped in MS-004; validator dependency check missing
- **Date:** 2026-04-27
- **Severity:** medium (not blocking, but creates false confidence)
- **Discovered by:** Reaper at MS-005 prep

**What happened:**
MS-004 approval H2 added MS chain mechanism in four parts (H2a–H2e). Three of the four shipped: state/current.md "MS chain" section (H2a), MS template "Depends on / Blocks" fields (H2b), retroactive lines on MS-001/002/003 (H2c). The fourth part — H2d, validator check enforcing that no MS proceeds while dependencies are open — did not ship. Engineer's DONE-004 sign-off claimed "working as designed" without verifying H2d was actually built.

**Why it matters:**
Chain documentation without enforcement is trust-based discipline, which is exactly what MS-004 existed to replace. Operator could file Phase 1's first MS with `Depends on: MS-006` and nothing would block the commit. The intention is there; the mechanism is not.

**Root cause:**
Engineer's DONE-004 verification was visual (read the repo, saw the chain section in state/current.md, assumed the validator check shipped alongside it) instead of mechanical (run the validator with a synthetic dependency violation, confirm FAIL).

**Resolution:**
H2d (chain check) folded into MS-005 scope. Validator gains a 9th check. Synthetic violation added to test set.

**Linked to:** MS-004 (DONE-004 sign-off), MS-005 (Scope A), DEC-026 (validator), engineer working agreement #9.

**Builder note:** INC-006 body authored by operator (engineer-drafted) and copied verbatim by Reaper-1 in MS-005 per the operator approval message. Same Builder-mediated historical-record pattern as RFI-006/007/008 — content is operator/engineer-supplied; Builder transcribes.

---

### INC-007 — Operator personal email caught in INSP-001 inspection report by gitleaks pre-commit hook

**Date:** 2026-04-28
**Severity:** low (rule working as designed; no exposure 
  shipped)
**Discovered by:** Inspector during INSP-001 commit attempt
**Detected by:** .gitleaks.toml rule "operator-personal-email"

### What happened

Inspector drafted INSP-001 with literal quotation of 
operator's personal Gmail address in four locations — LOW-1 
evidence (documenting the rule's pattern), LOW-2 evidence 
(documenting dual-email exposure), and twice in Summary 
(referencing auto-init commit author metadata). Pre-commit 
hook caught the violation, blocked the commit. Inspector 
paused, reported to Engineer, did not attempt --no-verify 
bypass.

### Root cause

Inspector reasoning that "documenting the exposure pattern 
requires showing the actual exposure" — logically defensible 
but fails the rule's intent. The rule exists to prevent the 
email landing in the public repo regardless of whether the 
surrounding prose is "about the email." Mention is exposure.

### Resolution

- INSPECTION.md prose redacted: literal email replaced with 
  descriptive paraphrase ("operator's primary @gmail.com 
  address from the auto-init commit's author metadata") in 
  all four locations
- This INCIDENT entry filed per Procedure 8 / DEC-025 
  response sequence
- Pre-commit retry succeeded after redaction
- INSP-001 commit landed clean at c655dab

### Lesson

gitleaks rules are content-pattern checks, not context-
aware. Documentation of an exposure pattern cannot use the 
literal exposure as evidence — must use descriptive 
paraphrase. Future Inspector entries documenting any 
sensitive-content rule should follow this pattern.

### Working agreement candidate

Engineer to formalize at MS-011 consolidation: "Inspection 
reports documenting sensitive-content rules must use 
descriptive paraphrase for any literal pattern the rule is 
designed to catch. The rule does not distinguish prose-
about-the-thing from the-thing-itself."

### Severity rationale

No DEC needed — this is procedural, not architectural. 
Severity is low because the rule fired correctly and 
nothing shipped to remote.

---

### INC-008 — Engineer verification miss in INSP-002 action plan PDF v1.0

**Date:** 2026-04-28
**Severity:** medium (no committed-state corruption; 
  reputational cost on the audit trail's credibility)
**Discovered by:** Operator during ground-truth verification 
  of INSP-002 action plan PDF
**Detected by:** Operator cloned repo, ran direct file 
  inspection, found "nine rules" at README.md current HEAD 
  (16a70c9) contradicting PDF's "eight rules" claim

### What happened

Engineer drafted INSP-002 action plan PDF consolidating an 
external review with own verification work. PDF v1.0 claimed 
README.md still says "the eight rules" as a confirmed-correct 
external finding (Section 1.1) AND as an Engineer-caught 
finding the external review missed (Section 2). Both claims 
were factually wrong — README.md at HEAD says "the nine 
rules" twice (line 30 and line 60). The fix landed in commit 
16a70c9 itself (MS-009 Section 3), which Engineer had read 
directly via web_fetch on the commit page earlier in the 
same session.

### Root cause

Engineer verified the external reviewer's claim by reading 
GitHub's HTML view of the repo, which serves multi-hour-
cached content. The HTML showed pre-MS-009-Section-3 state. 
Engineer trusted the rendered HTML rather than 
git ls-remote / raw file fetch, despite working agreement 
#14 (refined three-tier: git ls-remote > API > HTML, and 
"HTML repo pages should never be the verification source — 
they cache at multi-hour intervals") being explicitly 
designed to prevent this exact failure mode.

### Compounding error

The same wrong claim appeared TWICE in the PDF — once as 
confirmed external finding, once as Engineer's additional 
catch — without Engineer noticing the double-count. This 
indicates Section 1.1 and Section 2 were drafted 
independently without cross-referencing.

### Resolution

- INSP-002 action plan PDF reissued as v1.1 with the "eight 
  rules" claim removed from both Section 1.1 (now shows as 
  withdrawn finding with explanation) and Section 2 (removed 
  entirely). Section 8 of v1.1 documents the v1.0 → v1.1 
  errata openly rather than smoothing it over.
- Severity counts table in PDF Section 4.2 adjusted: LOW 
  count 6 → 5; Engineer audit LOW column 2 → 1.
- Other minor inaccuracies surfaced by operator's 
  verification:
  - "23 devDeps" corrected to "27 devDeps" in PDF v1.1
  - "MS-009 Section 3 close" framing softened to "Section 3 
    work landed at 16a70c9 with chat sign-off pending" in 
    INSP-002 template (§4.1) and References (§7.1)

### Lesson

Working agreement #14 isn't optional discipline — it's the 
entire reason the Engineer role can verify anything. When 
Engineer skips git ls-remote / direct file fetch in favour of 
rendered HTML, every claim built on that verification 
inherits the staleness. The cost compounds when the same 
unverified claim gets cited multiple times within the same 
artifact.

### Working agreement candidate

Engineer to formalize at next state/current.md update: 
"Engineer claims about repo state must cite the verification 
method used (git ls-remote, raw file fetch, commit-page diff, 
etc.). Claims with no cited method are unverified and must 
be removed before filing. Rendered HTML pages are never 
sufficient verification — they cache at multi-hour intervals 
per refined working agreement #14, and findings built on 
stale renders inherit the staleness."

### Severity rationale

Medium because: (a) no committed-state corruption — PDF is 
in /mnt/user-data/outputs and v1.0 never made it into the 
repo, (b) operator caught it before INSP-002 filed, 
(c) but the same mechanism would have produced a wrong 
INSP-002 entry in forms/INSPECTION.md if operator hadn't 
verified, which would have required a corrigendum after-
the-fact.

### Pattern note

This is the third Engineer working-agreement candidate in 
the same family (cross-environment paths #19, new-role-
surfaces-friction #20, this verification-method candidate 
#21). MS-011 consolidation should treat them as sub-cases 
of one principle: Engineer assumes things about state it 
hasn't verified, then builds compounding claims on top. 
Verify before asserting.

---

### INC-009 — Engineer heading-level transcription drift in INSP-002 session prompt

**Date:** 2026-04-28
**Severity:** low (caught at validator before commit; 
  mechanical fix; no committed-state corruption)
**Discovered by:** Builder (Reaper) during validator run 
  in INSP-002 + INC-007/008 + RFI-013/014 session
**Detected by:** scripts/validate.sh check_sequential FAIL 
  on Latest INC counter (claimed INC-008, found INC-006) 
  and Latest RFI counter (claimed RFI-014, found RFI-012)

### What happened

Engineer drafted INSP-002 + INC-007 + INC-008 + RFI-013 + 
RFI-014 bodies for Reaper to file verbatim. Engineer used 
H2 (`## `) heading levels across all five entries. 
INSPECTION.md convention (set by INSP-001) is H2, so 
INSP-002 was correct. But INCIDENT.md convention 
(set by INC-001 through INC-006) and RFI.md convention 
(set by RFI-001 through RFI-012) are both H3 (`### `). The 
validator's real_headings() function 
(scripts/validate.sh:60-70) only counts H3 entries for INC 
and RFI sections; H2-headed entries were invisible to 
check_sequential, producing the counter-mismatch FAIL.

### Root cause

Engineer drafted all five entry bodies in a single mental 
pass, inherited INSP entry formatting (H2 correct there) 
without checking the destination form's convention. The 
form-specific convention is established by the existing 
file content, not documented in PROCEDURES.md or 
GLOSSARY.md as an explicit rule. Engineer assumed 
heading level was uniform across all forms.

### Compounding factor

INC-009 is the third Engineer working-agreement-candidate 
in two days from the same root pattern (INC-008 verification 
miss, INC-008-precedent counter-state failure, this 
heading-level drift). Each surfaces as a different 
specific symptom; the underlying pattern is "Engineer 
assumes form/state convention without verifying."

### Resolution

- Reaper converted H2 → H3 mechanically for INC-007, 
  INC-008, RFI-013, RFI-014 per operator authorisation. 
  INSP-002 retained H2 (correct for INSPECTION.md).
- Validator passed on retry.
- This INC-009 entry filed per operator's standing rule 
  of engagement on validator failures.

### Lesson

Form heading-level convention is form-specific and not 
centrally documented. Engineer drafting numbered entries 
must verify the destination form's existing entries before 
choosing heading level. INSPECTION.md uses H2; 
INCIDENT.md and RFI.md use H3; DECISION.md, MS, DONE, 
SIGN_OFF.md, CHANGE_ORDER.md conventions to be confirmed 
case-by-case at draft time.

### Working agreement candidate

Engineer to formalize at MS-011 consolidation: "Engineer 
draft of numbered form entries must inspect the destination 
form's existing entries to verify heading level, status 
field syntax, and any other form-specific conventions 
before authoring. Form conventions are established by 
existing entries, not documented as central rules."

This candidate is sub-case of the broader pattern named in 
INC-008 (#21 candidate) and the INC-007/INC-008 sequencing 
failure (#22 candidate). All three candidates address the 
same root: Engineer assumes state/convention without 
verifying. MS-011 consolidation should treat them as 
specific instances of one principle: "verify before 
asserting."

### Severity rationale

Low because: (a) caught at validator before commit, 
(b) mechanical fix (single-character heading-marker 
change), (c) no committed-state corruption, (d) no rework 
of prose content needed.

---

### INC-010 — Prior agent left dangling SITE_LOG sign-in + uncommitted WIP across overnight gap

**Date:** 2026-04-30 11:20 (filed retroactively; events span 2026-04-29 10:11 → 2026-04-30 11:20)
**Severity:** medium (procedural break sustained ~24 hours; work-product discarded under operator authorisation; silent counter drift created in working tree before discovery)
**Discovered by:** Milo (Opus 4.7) on first-session induction reads, 2026-04-30
**Detected by:** `forms/SITE_LOG.md` trailing-open `### 2026-04-29 10:11 session start` entry without matching session-end heading; six modified files in working tree (`git status -s`); `state/current.md` `Updated:` line at 2026-04-29 10:11 referencing "Scopes A/B/C/D pending below per session prompt"

### What happened

Reaper-1 signed in 2026-04-29 at 10:11 for an INSP-003 + bug-fix session per its own session prompt rules of engagement. Sign-in mechanical actions were applied to the working tree (Section 5 sign-off magic-string in `forms/SIGN_OFF.md`, MS chain bump and `Updated:` refresh in `state/current.md`, sign-in entry appended to `forms/SITE_LOG.md`). Subsequent scope work was attempted as follows:

- **Scope A (`asdfqwerty` removal from `.cspell.json`):** removed from main `words` array; retained in the `forms/**/*.md` + `state/current.md` override at `.cspell.json:89`. Status from working-tree inspection: ambiguous (could be partial work or intentional final state).
- **Scope B (`scripts/validate.sh` check 11 awk polarity fix):** applied. Working tree had positive-pattern match against DEC-032 magic-string format; header comments referenced INSP-003 MEDIUM-1.
- **Scope C (INSP-003 filing):** applied. `forms/INSPECTION.md` contained INSP-003 entry at H2 per form convention.
- **Scope D (RFI-015 filing):** not started. `forms/RFI.md` unmodified; RFI-015 absent from file. The RFI-015 body was specified by the session prompt as "Engineer-supplied verbatim" — that source was not captured in the repo.

The session never wrote a sign-out entry, never committed, never pushed. Six files sat dirty for ~24 hours (2026-04-29 10:11 → 2026-04-30 11:20) before discovery.

### Blast radius

- Working-tree dirty state for ~24 hours: `forms/SITE_LOG.md`, `forms/SIGN_OFF.md`, `forms/INSPECTION.md`, `scripts/validate.sh`, `state/current.md`, `.cspell.json`.
- One open SITE_LOG sign-in with no matching sign-out — silent procedural debt visible only to a careful reader of the file tail.
- Counter drift in working tree: `forms/INSPECTION.md` contained INSP-003 entry while `state/current.md` still claimed `Latest INSP: INSP-002`. Validator's check 7 covers MS / DEC / RFI / INC counters but not INSP, so the drift was silent.
- HEAD remained at `4feef75` throughout; no committed-state corruption.
- No production impact — project is pre-Phase-1; nothing deployed; no users.

### How detected

Milo (Opus 4.7) first-session induction on 2026-04-30 included Procedure 1 reads of `forms/SITE_LOG.md` and a `git status` check. The trailing-open sign-in surfaced immediately at the file tail. Read-only audit (per operator direction "1 read only audit, figure out what left before finish") confirmed the four-scope status above and the missing sign-out / commit / push.

### Action taken

Per operator authorisation 2026-04-30 ("I agree and approve" on the proposed sequence: reset + sign-in + INC, with forward work scope to be set next):

1. **`git reset --hard 4feef75`** — six WIP files discarded. Working tree clean. Validator PASS confirmed on reset state (`VALIDATOR: PASS`, exit 0).
2. **No retroactive sign-out filed** for the 2026-04-29 10:11 session. The reset removed the sign-in entry itself (it was uncommitted), so there is no orphan start to pair with. The session's existence is documented here in INC-010 instead.
3. **Milo (Opus 4.7) signed in 2026-04-30 11:20** as Builder/Reaper successor per role-table update of 2026-04-30.
4. **INC-010 (this entry)** filed as first work action per Procedure 9 missing-sign-out clause.
5. Discarded work-products are recoverable: validator polarity fix can be re-done under proper MS coverage; INSP-003 can be re-filed verbatim from the operator-supplied source if needed; Section 5 chat sign-off (operator 2026-04-28) is documented in chat history and the magic-string can be re-applied at the next legitimate Section 5 sign-off cycle per DEC-032 mechanism. None of the discarded WIP was load-bearing on the committed state at `4feef75`.

### Linked to

- **MS-009 Section 5** — Section 5 magic-string was being applied in the discarded WIP; not yet re-applied.
- **DEC-032** — magic-string mechanism; the Section 5 magic-string is pending re-application at next sign-in cycle.
- **INSP-003** — was being filed in the discarded WIP; not yet re-filed.
- **(potential) MS-010 / MS-011** — recommendations below may belong to MS-010 scope (validator hardening) or MS-011 scope (working-agreements consolidation).

### Lessons

Procedure 9's missing-sign-out enforcement is *retroactive only* — the validator catches it via check 8 (which allows ≤1 open sign-in). The check fires when a *next* session attempts to sign in and would create two open sessions; for the dangling session itself, no automatic mechanism flags the gap. The cost is procedural debt that accumulates silently between sessions — in this case ~24 hours; longer is possible if no next session triggers the catch.

Compounding factor: the dangling state included not only the sign-in but the entire substantive WIP. With no commit, the work was never preserved in git history; if the operator had moved to a different machine or the working directory had been deleted, all work would have been lost. Sign-out + commit + push is the close-out pattern; failing to do any one of them creates risk.

### Working agreement candidates (route to MS-011 consolidation)

1. **Sign-out + commit + push are joint, not separable.** A session that does work but never commits creates work-loss risk. Consider whether the agent profile or session-prompt template should include a sign-out checklist that explicitly fails if commit + push haven't happened.
2. **Validator check candidate:** flag any sign-in entry whose timestamp is older than N hours and has no matching sign-out. Surfaces dangling state on every commit, not only on next sign-in. Would have caught this gap proactively rather than waiting for the next agent's audit.
3. **Counter drift on INSP not covered by validator check 7.** Entries can be added to `forms/INSPECTION.md` without `Latest INSP` in `state/current.md` updating, and the discrepancy is invisible. Consider extending check 7 to cover INSP, OR adding explicit doctrine that INSPECTION.md → state/current.md counter sync is operator-direction-only.

### Severity rationale

Medium because: (a) procedural break sustained ~24 hours, (b) work-product discarded under operator authorisation (recoverable but not free), (c) silent counter drift created in working tree (INSP-003 in file but `Latest INSP: INSP-002` in state) before discovery, (d) sign-out is a Procedure 9 *required* step that was simply absent — pure rule break, not a near-miss. Not high because (e) no production impact, (f) no committed-state corruption (HEAD remained at `4feef75` throughout), (g) full reconstruction possible from the working-tree audit before reset, (h) operator authorised the cleanup path; recovery is clean and documented.

---

### INC-011 — `npm install` fails on corrupted `@sigstore/sign` internal file (system-level, not UnoAi-side)

**Date:** 2026-04-30 23:18 (filed during MS-009 Section 6 in-flight)
**Severity:** medium (environmental issue; blocks fresh `npm install` on this machine; live UnoAi commits unaffected because they use pre-existing `node_modules`)
**Discovered by:** Milo (Opus 4.7) during MS-009 Section 6 cold-clone hook test (Sub-scope 6B.3 Prettier synthetic test)
**Detected by:** Section 6B.3 commit attempt produced `npm error Unexpected token 'return'` rather than expected Prettier `--check` output. Diagnosis via the npm-cache debug log named in the error message (`C:\Users\Tyrien\AppData\Local\npm-cache\_logs\2026-04-30T15_17_50_271Z-debug-0.log`)

### What happened

MS-009 Section 6 is the cold-clone end-to-end test. Sub-scope 6A passed: clone, hook activation, validator from clone all clean. Sub-scope 6B.1 (gitleaks) and 6B.2 (validator) both passed in the cold clone with expected BLOCK behaviour. Sub-scope 6B.3 (Prettier synthetic test) committed a deliberately mis-formatted JSON file expecting Prettier to BLOCK with `--check` output. The commit was BLOCKED (exit 1), but the diagnostic was `npm error Unexpected token 'return'` rather than Prettier's expected formatting-issue output.

Investigation traced the error to `npm install` itself failing in **both** the cold clone AND the live working tree with the same error. The live UnoAi repo's pre-commit hook chain has been working today (commits `423465a` and `61c7cba` both cleared the full five-stage hook chain) because those invocations use `node_modules/` already on disk from a prior successful install — they don't trigger the broken code path.

The npm-cache debug log identifies the failing file: `C:\Program Files\nodejs\node_modules\npm\node_modules\@sigstore\sign\dist\witness\tsa\client.js:40`. The line content per the verbose stack:

```
$      return await this.tsa.createTimestamp(request);
^^^^^^
SyntaxError: Unexpected token 'return'
```

The stray `$` at the start of the line is invalid JavaScript. The file is corrupted on disk. `@sigstore/sign` is one of npm's internal package-signing libraries (used during install for Timestamp Authority verification), bundled with npm itself.

### Blast radius

- Cold-clone setup cannot complete `npm install` → cannot populate `node_modules/` in fresh clones → cannot test 6B.3 / 6B.4 / 6B.5 hook stages in cold clone with clean diagnostics.
- Live working tree cannot reinstall or update npm dependencies if needed — frozen at whatever `node_modules/` was last successfully populated.
- Pre-commit hook chain still functions for normal commits (uses pre-existing deps via `npx`-style invocations, doesn't load `@sigstore/sign`).
- No committed-state corruption. HEAD remains `61c7cba`.
- No production impact (project is pre-Phase-1; nothing deployed; no users).
- Affects only: this developer environment (operator's machine). Other clones on other machines unaffected unless they share the same corruption.

### How detected

MS-009 Section 6's cold-clone test methodology specifically surfaces fresh-environment friction that's invisible from a live working tree. 6B.3 was the trigger: synthetic Prettier violation produced an npm error instead of a Prettier error, which prompted the diagnostic dive. The cold-clone test paid for itself on its first run.

### Action taken

1. **Pause-at-blocker invoked** per session prompt rules of engagement. Surfaced findings to operator.
2. **Investigated via the source of truth** — the npm-cache debug log named in the error message. Pulled both the failure-path log (15:17:50) and a success-path log (12:43, from this morning's INC-010 commit's cspell run) for comparison. The success path used `npm exec cspell` (npx) which doesn't load `@sigstore/sign`; the failure path was `npm install` which does.
3. **Identified root cause:** corrupted `client.js` at `C:\Program Files\nodejs\node_modules\npm\node_modules\@sigstore\sign\dist\witness\tsa\client.js:40`. Stray `$` token, likely from antivirus interference, half-completed npm self-update, or disk write hiccup.
4. **Operator (Tyrien) authorised Path A:** reinstall Node from nodejs.org. Cleanest fix; repairs npm and its bundled internals without touching UnoAi-side state. Reinstall in progress at filing time.
5. **Section 6 resume planned** post-Node-reinstall: retry `npm install` in cold clone; if clean, continue 6B.3 through 6B.5 with proper hook diagnostics; complete 6C cleanup; sign out + commit + push.
6. **This INC filed** during the Node-reinstall window so the audit trail captures the discovery regardless of the resume path.

### Linked to

- **MS-009 Section 6** (in progress this session) — the cold-clone test surfaced this finding; Section 6 resumes from 6B.3 post-reinstall.
- **CONTRIBUTING.md** — likely needs an amendment documenting `npm install` as a per-clone setup step alongside the existing `git config core.hooksPath` instruction. Currently CONTRIBUTING.md only mentions hook activation; doesn't mention dependency install. Routing: future MS (likely MS-010 if scoped, or a small standalone amendment).
- **INSP-001 / INSP-002 / INSP-003** — none of these prior inspections caught this, because they all reviewed the live working tree where `node_modules/` already exists. Cold-clone testing was the discovery surface, which validates Section 6's existence.

### Lessons

1. **Cold-clone testing has unique discovery value.** A live working tree masks environment-state issues that only surface on fresh clones. Section 6's design — explicitly cold-cloning rather than testing in place — was the right call. The five-hook synthetic test in cold clone surfaced a real environmental issue that three prior inspections (INSP-001/002/003) all missed because they reviewed the live tree.
2. **Hook chain diagnostic clarity depends on `node_modules/` populated.** When `node_modules/` is missing, the hook chain still BLOCKS commits (safety property preserved) but via npm-side errors rather than the actual hook tool's output. A fresh agent reading those errors might be confused. Possible CONTRIBUTING.md amendment: document `npm install` as a setup step.
3. **The npm `@sigstore/sign` corruption is not a UnoAi failure mode.** It's a system-level / environment-level issue. Fix is environmental (Node reinstall), not procedural. The procedural lesson is "keep the diagnostic chain to the source of truth" — in this case, the npm-cache debug log was the right starting point.

### Working agreement candidates (route to MS-011 consolidation)

1. **CONTRIBUTING.md should document the full setup chain.** Current text mentions hook activation only. A fresh contributor needs: `git clone` → `git config core.hooksPath .githooks` → `npm install` → ready. The middle step is currently implicit. (Routing: MS-010 documentation cluster, or standalone amendment.)
2. **Pre-commit hook diagnostics could distinguish "tool failed" from "tool environment broken."** Currently when npm itself errors, the hook reports it under the relevant tool's BLOCK message (e.g., "Prettier flagged staged files"). A future hook-hardening step might detect `npm error` patterns specifically and surface "tool environment issue, not staged content issue." (Routing: MS-010 hook hardening, if scoped.)

### Severity rationale

Medium because: (a) environmental issue affects developer experience and fresh-clone reproducibility, (b) blocks any future `npm install` on this machine until repaired, (c) introduces fragility — live commits work only because `node_modules/` happens to be populated already; any reinstall trigger would expose the bug. Not high because (d) no production impact, (e) no committed-state corruption, (f) operator can fix in ~5 minutes via Node reinstall, (g) workaround for the immediate session is well-understood (test 6B.3-6B.5 in cold clone post-reinstall, OR document the cold-clone limitation if resume isn't pursued), (h) live UnoAi commits unaffected throughout.

