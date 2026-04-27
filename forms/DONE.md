# Done log

Append-only. One entry per completed task or phase. **Proof is non-negotiable.**

A description of expected behaviour is not proof. "Confidence it works" is not proof. "Tested locally" without a recording is not proof.

---

## Template

```
### DONE-NNN — [task]
- **Date:** YYYY-MM-DD
- **Agent:** [name]
- **Phase:** [number + name]
- **Method statement:** MS-NNN

**Acceptance criteria (copied from MS-NNN):**
[Verbatim from the original method statement. Do not rewrite.]

**Builder-produced proof** (per DEC-011 — Builder fills at DONE filing):
- Test output: [paste or path]
- Git diff: [SHA range]
- Live demo / staging URL: [URL]
- Console logs: [path]

**Operator-captured proof** (per DEC-011 — operator fills at sign-off):
- Screenshot: [path or URL]
- Screen recording: [path or URL]
- Visual UI confirmation: [notes]

DONE entries must cite at least one Builder-produced artefact and at least one Operator-captured artefact (where applicable to the phase).

**What to look for in the proof:**
[Direct the operator's eye. "Frame at 0:14 shows the streamed response." "Lines 23-45 of the test output show the assertion passing."]

**Anything skipped or deferred:**
[List, or "none". If something was skipped, it must already be logged as a CHANGE_ORDER or RFI.]

**Linked incidents:** [INC-NNN if any happened during this task]

**Operator sign-off:** [pending / signed YYYY-MM-DD]
**Sign-off notes:**
[Optional. Caveats, follow-ups, observations.]
```

---

## Example

```
### DONE-004 — Phase 2: Chat shell + BYOK complete
- Date: 2026-04-27
- Agent: Reaper-1
- Phase: 2 — Chat shell + BYOK
- Method statement: MS-005

Acceptance criteria:
- Type a message, hit send, see assistant tokens stream into the message bubble
- Browser network tab shows POST to api.anthropic.com only (no proxy)
- Invalid key shows visible error in chat, not a console-only failure
- Screen recording attached to DONE entry

Builder-produced proof:
- Test output: ./proofs/done-004-streaming.txt (3 prompts, all streamed; assertion log included)
- Git diff: a3f2c1d..f4e8d2b
- Staging URL: https://staging.<project>.pages.dev/

Operator-captured proof:
- Screen recording: ./proofs/done-004.webm (90s)
- Network tab screenshot: ./proofs/done-004-network.png

What to look for:
- 0:00–0:25 — entering API key in settings
- 0:25–0:50 — sending a message, tokens stream visibly into the assistant bubble
- 0:50–1:10 — network tab visible, only api.anthropic.com calls (no other backend)
- 1:10–1:30 — testing invalid key, error appears in chat UI

Anything skipped or deferred:
- API key validation on save (just stored as-is) — deferred to Phase 7 polish
- Token usage tracking — out of v1 scope (logged as CO-002, deferred to v2)

Linked incidents: none

Operator sign-off: pending
```

---

## Entries

<!-- Append new DONE entries below this line. -->

### DONE-002 — Post-decision batch (MS-002 complete)
- **Date:** 2026-04-27
- **Agent:** Reaper-1
- **Phase:** 0 prep (pre-0a)
- **Method statement:** MS-002

**Acceptance criteria (copied from MS-002):**
- `forms/DECISION.md` contains DEC-001 through DEC-022 in order, no duplicates, no truncations. DEC-013 body shows the engineer-supplied scaffold options (TS, Svelte 5, adapter-cloudflare, ESLint, Prettier, Vitest, Playwright, Tailwind, no shadcn-svelte) plus the carve-out clause.
- DEC-014 carries `Supersedes: DEC-003`; DEC-015 carries `Supersedes: DEC-004`. Both supersede references resolve.
- `forms/RFI.md` shows RFI-001, 002, 004, 005, 006, 007, 008 with `Operator decision: ANSWERED 2026-04-27 via DEC-NNN` lines. RFI-003 status unchanged (still pending). RFI-007 and RFI-008 are present as historical-record entries with Builder-notes.
- `PROJECT.md` Banned moves contains the new persona-promises bullet (PM1). Pricing reads "$9 one-time" with no "(proposed, pending)" hedge (PM2). Persona section references DEC-015 (PM3). New "Appendix A — System Prompt v1" section at end with the five paragraphs verbatim (PM4).
- `PLAN.md` Phase 0a estimate "2–3 hours" + expanded deliverables (PL1). Phase 4 has prompt-assembly-function deliverable + DEC-016 + Appendix A references (PL2). Phase 6 has provider-abstraction-layer deliverable + DEC-021-shaped acceptance (PL3). Phase 8 ToS subsection rewritten per DEC-022 with footer line (PL4). Out-of-scope list has three new items (PL5).
- `README.md` has license-badge line near top (R1), Self-hosting section near bottom (R2), and structural split between user-facing stub at top and "For agents" section below (R3). Agent content preserved.
- `INCIDENT.md` example INC-001 references Ed25519, not HMAC.
- No edits in PROCEDURES.md, CHANGE_ORDER.md, DONE.md template/example structure, METHOD_STATEMENT.md template/example, SITE_LOG.md template/example.
- Builder-produced proof for DONE-002: file-by-file change summary with line-count delta before/after.
- No uncaught cross-reference breaks (post-apply grep sweep documented in DONE-002).

**Builder-produced proof:**

*File-by-file change summary (no git history yet — diff equivalent below):*

| File | Lines (post-MS-002) | MS-002 changes |
|---|---|---|
| `README.md` | 60 | R1 license badge added (line 5). R2 Self-hosting section added with R2c liability sentence (lines 17–21). R3 restructure: agent content moved into "For agents working on this project" section header; user-facing marketing-copy stub at top; LICENSE entry added to file map with "committed in Phase 0b" annotation. |
| `PROJECT.md` | 135 | PM1 banned-moves bullet (persona must not promise permanence / claim love / substitute for human relationships). PM2 Pricing section rewritten for $9 + DEC-014 reference. PM3 Persona section rewritten for honest-core + shard architecture per DEC-015. PM4 Appendix A appended with five-paragraph honest-core text verbatim. INC-004 also fixed line 9 intro: $39 → $9. |
| `PLAN.md` | 232 | PL1 Phase 0a estimate 1h → 2–3h; deliverables list expanded with PUBLIC repo + Issues-open-PRs-closed + $9 LS placeholder + parallel-creation note. PL2 Phase 4 adds prompt-assembly-function deliverable + DEC-016 fixture #4 reference + Appendix A as source of truth; closes RFI-002/005. PL3 Phase 6 adds provider-abstraction layer (DEC-020) + acceptance reframed per DEC-021 (98% TP / 10% FP starting points, floor preserved). PL4 Phase 8 ToS rewritten per DEC-022 with R2a (template-selection step) + R2b (ToS body URL links to /safety + /privacy) + footer line; counsel-review RFI removed. PL5 Out-of-scope adds counsel ToS, user-authored shards, multi-provider classifier. INC-004 fix: Phase 1 goal $39 → $9. |
| `PROCEDURES.md` | 141 | No change (per scope). |
| `forms/SITE_LOG.md` | 73 | One entry added covering session, pushback acknowledgments, R4 LICENSE-decline reasoning, cross-reference sweep summary. |
| `forms/METHOD_STATEMENT.md` | 219 | MS-002 entry filed pre-edit (Procedure 2 compliance). |
| `forms/DONE.md` | 92 + this entry | DONE-002 (this entry) appended. Template/example structure unchanged. |
| `forms/DECISION.md` | 284 | DEC-013 body replaced (engineer pre-fill of scaffold options table). DEC-014..022 (9 new entries) appended in order. DEC-014 supersedes DEC-003; DEC-015 supersedes DEC-004; explicit `Supersedes:` lines present in both. |
| `forms/CHANGE_ORDER.md` | 86 | No change (per scope). |
| `forms/RFI.md` | 195 | RFI-001/002/004/005/006 status updates to `ANSWERED 2026-04-27 via DEC-NNN`. RFI-003 status set to OPEN/parked. RFI-007 and RFI-008 authored retroactively as historical-record entries with Builder-notes (per MS-002 R1 approval). |
| `forms/INCIDENT.md` | 206 | Example INC-001 line 61: `HMAC verification` → `Ed25519 signature verification` (cosmetic fix per scope). INC-003 appended (engineer pattern: DECs reference RFIs not present in source). INC-004 appended (sweep-miss caught two stale $39 references in PROJECT.md line 9 + PLAN.md Phase 1 goal). |

**Files NOT modified:** `PROCEDURES.md`, `forms/CHANGE_ORDER.md`. Confirmed via post-apply check.

**Pre-state line counts:** not captured before edits began (procedural lesson — capture `wc -l` snapshot pre-edit in future MSes for clean delta diffs). Post-state captured above.

*Cross-reference grep sweep (post-apply):*
```
^### DEC-\d+   →  DEC-001..DEC-022 (22 entries)        ✓
^### RFI-\d+   →  RFI-001..RFI-008 (8 entries)         ✓
^### MS-\d+    →  MS-001, MS-002 (real); MS-005 example ✓
^### INC-\d+   →  INC-001..INC-004 real; INC-001 example ✓
^### DONE-\d+  →  DONE-002 (this); DONE-004 example     ✓

DEC-023+ orphans   → 0
RFI-009+ orphans   → 0
"Closes: RFI-NNN"  → all targets resolve
"$39" stale refs   → 0 (all hits are historical-record audit trail)
"HMAC" stale refs  → 0 (all hits are DEC-007 alternatives discussion)
```

**What to look for in the proof:**
- DECISION.md grows from 13 entries to 22 entries (+9 entries) plus DEC-013 body replacement. Header line for DEC-013 changed from "(placeholder; to be filled in Phase 0b)" to "(engineer pre-fill; Builder confirms in Phase 0b)" reflecting the fill-in.
- RFI.md grows from 6 entries to 8 entries (+2 retroactive entries), plus 5 status updates to existing entries.
- PROJECT.md gains a new Appendix A section at the end; intro/Pricing/Persona/Banned-moves sections rewritten in place.
- PLAN.md Phase 0a, Phase 1 goal, Phase 4, Phase 6, Phase 8, Out-of-scope all carry MS-002 changes; Phase 2/3/5/7 unchanged.
- README.md fully restructured: 4 sections (header+badge / marketing stub / self-hosting / agents+filemap+status) replacing prior 3 (header / agents / filemap+status).
- INCIDENT.md gains INC-003 + INC-004 in Entries section; example INC-001 (in code-block, separate from real entries) carries Ed25519 cosmetic fix.

**Anything skipped or deferred:**
- **LICENSE file** — declined in this MS. Operator's R4 amendment authorised it as optional. WebFetch on the canonical PolyForm NC URL returned 404 from this environment; writing legal text from memory risks fabrication. Deferred to Phase 0b where canonical text can be sourced reliably. Logged in SITE_LOG.
- **No code, no scaffold, no commits** — confirmed per rules of engagement.

**Linked incidents:** INC-003 (engineer pattern: DECs referencing absent RFIs, including DEC-018/019 → RFI-007/008 from this MS), INC-004 (sweep-miss: two stale $39 references caught in cross-reference sweep).

**Operator sign-off:** pending.
**Sign-off notes:**
[Operator fills. Likely no visual proof needed per MS-002 (doc work only). Any caveats / follow-ups go here.]

