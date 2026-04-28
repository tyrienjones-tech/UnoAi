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

