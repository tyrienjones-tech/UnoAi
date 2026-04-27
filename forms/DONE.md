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

---

### DONE-003 — Phase 0b kickoff complete (MS-003 closed)
- **Date:** 2026-04-27
- **Agent:** Reaper-1
- **Phase:** 0b — Builder scaffolding (complete pending operator sign-off)
- **Method statement:** MS-003

**Acceptance criteria (copied from MS-003):**
- `C:\Users\Tyrien\Desktop\UnoAi\` exists with all 4 root docs + LICENSE + CONTRIBUTING + .gitignore + scaffold output + `forms/` (7 templates with accumulated entries). ✓ Plus B7.5 additions: `.gitleaks.toml`, `.githooks/pre-commit`.
- `C:\Users\Tyrien\Desktop\Chat2U\` unchanged from MS-002 closing state (rollback path preserved). ✓
- All `Chat2U` references in forward-looking docs replaced with `UnoAi`. All `Companion` proper-noun product references replaced with `UnoAi`. Role-descriptor "companion" / "AI companion" preserved. Historical-record entries preserved verbatim. ✓
- `forms/DECISION.md` includes DEC-023 (product name lock; closes RFI-003) + DEC-024 (gitleaks hook required) + DEC-025 (sensitive-content list). DEC-013 body updated from engineer-pre-fill to scaffold-time-actuals. ✓
- `forms/RFI.md` shows RFI-003 ANSWERED via DEC-023 + Builder-note flagging RFI-009 follow-up. RFI-009 filed (TLD selection). ✓
- `forms/INCIDENT.md` includes INC-005 (migration + auto-init-commit finding). ✓
- `LICENSE` content matches operator-supplied PolyForm NC text verbatim with copyright header prepended. ✓
- `CONTRIBUTING.md` content per MS-003 B3 verbatim with `[security contact TBD]`. ✓ Plus added "Repo setup" section for the hooks-path activation per B7.5.
- `.gitignore` content per MS-003 B4 baseline + sv's SvelteKit additions union. ✓
- `npm install` completes without errors. ✓ (242 packages, 3 low-severity transitive vulns; non-blocking)
- `npm run dev` starts a dev server; default Svelte page renders. ✓ (Vite 8.0.10, ready in 3.1s on `localhost:5173/`)
- Commit pushed to `https://github.com/tyrienjones-tech/UnoAi`; visible on GitHub. ✓

**Builder-produced proof:**

*Git state (post-push):*
```
$ git log --oneline
0cf45cd Migrate handover package + LICENSE + SvelteKit scaffold   ← MS-003
372902c Initial commit                                              ← GitHub auto-init (fossil; per B8 Decision 1 layer-on-top resolution)

$ git ls-remote origin main
0cf45cd7c85d2b329ee57eb4c65113c995a8ffa6  refs/heads/main
```

*Commit URLs (visible since DEC-017 / public repo):*
- Repo: <https://github.com/tyrienjones-tech/UnoAi>
- This commit: <https://github.com/tyrienjones-tech/UnoAi/commit/0cf45cd>

*Commit diff stats:*
```
[main 0cf45cd] Migrate handover package + LICENSE + SvelteKit scaffold
 42 files changed, 8174 insertions(+), 1 deletion(-)
```
The single deletion is the auto-init's 31-byte placeholder README being replaced with the migrated UnoAi README. The 8174 insertions break down approximately:
- `package-lock.json` ~5,500 lines (typical npm lockfile)
- Migrated handover docs (4 root + 7 forms with cumulative MS-001 + MS-002 + MS-003 entries) ~2,000 lines
- `LICENSE` 81 lines (PolyForm NC + copyright)
- Scaffold configs + `src/` + `static/` ~600 lines

*npm run dev startup output:*
```
> unoai@0.0.1 dev
> vite dev
vite 11:39:14 PM (client) Forced re-optimization of dependencies
  VITE v8.0.10  ready in 3136 ms
  Local:   http://localhost:5173/
  Network: use --host to expose
```

*Pre-commit hook output verbatim (proves the hook ran during commit):*
```
[pre-commit] gitleaks scanning staged content...
    o
    | \
    |  o
    o  .
    .    gitleaks
INF  0 commits scanned.
INF  scanned ~345897 bytes (345.90 KB) in 222ms
INF  no leaks found
[pre-commit] gitleaks: clean.
```

*Final form tallies:*
- `forms/DECISION.md`: DEC-001..DEC-025 (25 real entries), no gaps, no duplicates outside example block.
- `forms/RFI.md`: RFI-001..RFI-009 (9 real entries). RFI-003 ANSWERED via DEC-023; RFI-009 OPEN (TLD).
- `forms/INCIDENT.md`: INC-001..INC-005 (5 real entries).
- `forms/METHOD_STATEMENT.md`: MS-001 + MS-002 + MS-003 (all approved + completed).
- `forms/DONE.md`: DONE-002 + DONE-003 (this entry).
- `forms/SITE_LOG.md`: 6 session entries spanning MS-001 → MS-003 close.

*gitleaks verification (3 working-tree scans + 1 protect-staged + 1 hook-fired during commit, all clean):*
- Initial detect (git history, pre-MS-003): 1 commit, 29 bytes, no leaks.
- Working-tree detect (pre-edits): 165 KB, no leaks.
- Working-tree detect (post-edits with new sensitive-content section): 174 KB, no leaks.
- Pre-commit `protect --staged` rehearsal: 345.90 KB, no leaks.
- `git commit` triggered hook: same scan, clean.

*DEC-013 update confirmation:*
DEC-013 now contains the engineer-pre-fill-vs-scaffold-actuals comparison table, the verbatim reproducibility command from sv's "to skip prompts next time" output, the Tailwind v4 deviation note (operator-approved at B8 Decision 2), the file inventory of scaffold-added files, the README + .gitignore restoration notes, and the npm install / dev-server result. See `forms/DECISION.md` line 162.

*DEC-023 / DEC-024 / DEC-025 / RFI-009 / INC-005 confirmation:*
- DEC-023 at `forms/DECISION.md` line 313 — Product name UnoAi; closes RFI-003.
- DEC-024 at `forms/DECISION.md` line 322 — gitleaks pre-commit hook required.
- DEC-025 at `forms/DECISION.md` line 345 — Sensitive-content list.
- RFI-009 at `forms/RFI.md` line 195 — Domain TLD for unoai.[?]; OPEN.
- INC-005 at `forms/INCIDENT.md` line 209 — Migration + auto-init-commit finding.

*Line counts (post-MS-003):*
| File | Lines |
|---|---|
| README.md | 60 |
| LICENSE | 81 |
| CONTRIBUTING.md | 25 |
| PROJECT.md | 162 |
| PLAN.md | 232 |
| PROCEDURES.md | 165 (was 141; +24 for Procedure 8) |
| .gitignore | 38 |
| .gitleaks.toml | 88 |
| .githooks/pre-commit | 53 |
| forms/SITE_LOG.md | 314 |
| forms/METHOD_STATEMENT.md | 360 |
| forms/DONE.md | 166 + this entry |
| forms/DECISION.md | 367 (was 284; +83 for DEC-013 update + DEC-023 + DEC-024 + DEC-025) |
| forms/CHANGE_ORDER.md | 86 (unchanged) |
| forms/RFI.md | 211 (was 195; +16 for RFI-003 closure note + RFI-009) |
| forms/INCIDENT.md | 241 (was 206; +35 for INC-005) |
| package.json | 48 |

**What to look for in the proof:**
- Repo URL renders the migrated README (UnoAi marketing surface stub at top, Self-hosting section, agents section below) — not the auto-init "Name is place holder."
- LICENSE file shows PolyForm Noncommercial 1.0.0 text with the copyright header.
- `git log --oneline` on a fresh clone shows two commits: the auto-init `372902c` fossil and our `0cf45cd`.
- The commit message has no Co-Authored-By Claude footer (per MS-003 Open Question 2).
- `package.json` shows `"name": "unoai"` (not `"chat2u"`, not `"companion"`), `tailwindcss ^4.2.2`, `@sveltejs/adapter-cloudflare ^7.2.8`, `svelte ^5.55.2`. Zero `*` or `latest` version specifiers.
- Pre-commit hook lives at `.githooks/pre-commit` and activates per-clone via the documented `git config core.hooksPath .githooks`.

**Operator-captured proof (operator fills at sign-off):**
- Visit <https://github.com/tyrienjones-tech/UnoAi> — confirm landing page renders the UnoAi README, LICENSE link visible, file list shows PROJECT.md / PLAN.md / PROCEDURES.md / forms/ / src/ / package.json / etc.
- Visit <https://github.com/tyrienjones-tech/UnoAi/commit/0cf45cd> — confirm message, file count, no AI co-author footer.
- Optionally: pull the repo on a fresh clone, run `npm install` + `npm run dev`, verify it works for an independent observer.

**Anything skipped or deferred:**
- **Cloudflare Pages link** — DEFERRED (per MS-003 B9). Operator account creation is the prerequisite. Will be a separate small MS once the account exists; Builder's call whether to roll into Phase 1 prep or file as MS-003.5.
- **RFI-009 (TLD selection: `unoai.com` vs `unoai.app`)** — OPEN. Pending operator availability check. Phase 0a DNS configuration is blocked by this.
- **`Chat2U/` rollback folder retention** — operator decision post-DONE-003 sign-off (delete vs keep).
- **LICENSE legal-due-diligence re-verification** — Builder fetched from `polyformproject/polyform-licenses` GitHub mirror branch `1.0.0` via curl. If operator wants independent comparison with SPDX text repo, Builder can run a `diff`. Low-priority follow-up; not blocking Phase 0b.

**Linked incidents:** INC-005 (migration + auto-init finding).

**Linked DECs filed in MS-003:** DEC-013 (updated to actuals), DEC-023 (UnoAi name), DEC-024 (gitleaks hook), DEC-025 (sensitive-content list).

**Linked RFIs:** RFI-003 (closed via DEC-023), RFI-009 (newly filed, OPEN).

**Operator sign-off:** pending.
**Sign-off notes:**
[Operator fills. Visit GitHub repo + commit URL to confirm visible state. Caveats or post-DONE-003 follow-ups go here, including the `Chat2U/` rollback-folder retention call.]

