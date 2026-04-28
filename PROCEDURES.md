# Procedures

Nine procedures govern this project. Each maps to a form template in `/forms/`, except Procedure 8 (secrets discipline) which is enforced by the `gitleaks` pre-commit hook and Procedure 9 (session lifecycle) which is enforced jointly by the SITE_LOG sign-in/sign-out templates and the `scripts/validate.sh` validator script run at every commit. Every procedure exists because of a specific failure mode it prevents — the *why* is as important as the *what*.

---

## Procedure 1 — Site induction

**When:** every new agent session, before any other action.

**What:**
1. Read `PROJECT.md` (full)
2. Read `PLAN.md` (skim, focus on current phase)
3. Skim the most recent 3 entries in `forms/SITE_LOG.md`
4. File a SITE_LOG entry: "Arrived. Read induction. Working on phase X."
5. Then begin work.

**Engineer-role addendum (per MS-007):** sessions that will be writing prompts to Builder also read `prompts/engineer-prompt-checklist.md` before drafting any prompt. The checklist is the mechanical fix for the chat-vs-file drift patterns named in working agreements #5, #10, and #11 — going through it takes ~2 minutes and catches known failure modes that have cost real time across multiple MSes. Fresh Engineer sessions additionally start with `prompts/engineer-session-start.md` (the operator-pasted onboarding prompt that loads the agentic-doctrine context).

**Form:** `forms/SITE_LOG.md` (append-only)

**Why:** agents that skip induction reinvent decisions, drift scope, and break governance. Five minutes of reading prevents hours of rework. This is non-negotiable.

---

## Procedure 2 — Method statement before mutation

**When:** before writing or modifying files. **Granularity rule (per DEC-012):** default is one METHOD_STATEMENT *per phase*. A sub-MS is required when *any* of:
- The diff exceeds ~150 lines net change, OR
- The work touches more than 3 files, OR
- The work introduces a new top-level dependency (which is also a DECISION trigger).

Routine work inside a phase (small refactors, single-file edits, variable renames) proceeds under the phase's single MS. SITE_LOG entries cover the granular trail.

**What:** file a METHOD_STATEMENT stating:
- What you plan to do (numbered steps)
- Which files you will touch and why
- Estimated diff size
- Risks identified
- Acceptance criteria

Wait for operator approval. Do not start work until approved.

**Form:** `forms/METHOD_STATEMENT.md` (numbered, MS-001 onwards)

**Why:** "I'll just quickly..." is how agents do invisible damage. Stating intent before mutating is the cheapest possible safeguard. The operator catches design problems before they're code. The granularity rule prevents the operator becoming a router on every typo fix.

---

## Procedure 3 — Done means proof

**When:** when claiming any task or phase is complete.

**What:** file a DONE entry with:
- Reference to the original METHOD_STATEMENT
- Acceptance criteria copied verbatim from the method statement
- **Proof attached** — see division of labour below

**Proof division (per DEC-011 + MS-008 Scope C clarification):**
- **Builder produces:** test output (paste or path), git diffs (SHA range), deployed/staging URL, console logs.
- **Operator captures (where applicable to the work):**
  - For code-producing MSes: screenshots, screen recordings, visual UI confirmation against the Builder-produced live URL.
  - For doc-only MSes (no UI surface): visual inspection of the rendered files on GitHub is sufficient. Operator-captured proof is the chat sign-off itself (per DEC-032 magic-string mechanism).

A description of expected behaviour is **not proof**. "It works on my machine" is not proof. "I'm confident it's correct" is not proof. The DONE entry must still cite at least one Builder-produced artefact; the operator-captured artefact is work-type-dependent.

**Form:** `forms/DONE.md` (append-only, DONE-001 onwards)

_Numbering note: the first real DONE entry is DONE-002. DONE-001 was never written — MS-001 predated the close-out-DONE convention (see `state/current.md` MS chain status: "MS-001: complete (operator pre-authorised; no DONE filed — predates the DONE-required convention)"). The "DONE-001 onwards" phrasing names the schema's starting point, not an existing entry; backfilling a retroactive DONE-001 would create a synthetic record._

**Why:** LESSON-009 from the doctrine — agents produce confident, plausible, fabricated work whenever procedure doesn't catch it. Proof is the antidote. The two-party division prevents the failure mode of "Builder claimed DONE with no recording attached because the headless agent couldn't capture one."

---

## Procedure 4 — Decision log

**When:** any non-obvious choice gets made — stack, library, persona detail, pricing, scope, naming, copy.

**What:** file a DECISION entry. One sentence summary, then alternatives and reason. Append-only.

**Form:** `forms/DECISION.md` (DEC-001 onwards; standing decisions already populated)

**Why:** future agents and the operator need to know why. Without this, every choice gets re-litigated every session. Decisions also create the change-resistance the project needs — once DEC-001 says Svelte, no agent rewrites it in React without filing DEC-NNN to override.

---

## Procedure 5 — Scope fence

**When:** the mid-task urge to "also fix X while I'm here" or "this would be better if I added Y."

**What:**
1. **Stop.**
2. File a CHANGE_ORDER describing the urge
3. Continue the original scope only
4. Do not act on the change-order until operator decides

**Form:** `forms/CHANGE_ORDER.md` (CO-001 onwards)

**Why:** scope creep is the #1 source of agent damage and most of it feels helpful in the moment. The CHANGE_ORDER turns "while I'm here" energy into a queued decision, which is almost always the right call.

Default operator disposition for v1: **defer to v2**.

---

## Procedure 6 — Request for information

**When:** blocked on a question only the operator (or engineer) can answer. *Do not guess.*

**What:** file an RFI with:
- The blocking task
- The clear, specific question (one per RFI)
- Context — what's been tried, what the options are
- Engineer's lean (if applicable)

Wait for the answer. No work proceeds on the blocked task until answered.

**Form:** `forms/RFI.md` (RFI-001 onwards)

**Why:** guessing produces a wrong answer that's hard to detect. RFI makes "I don't know" cheap to say.

---

## Procedure 7 — Incident log

**When:** something breaks, gets reverted, surprises the operator, or fails a test that was expected to pass.

**What:** file an INCIDENT entry. Even one line is fine. **No blame, just facts.**

**Form:** `forms/INCIDENT.md`

**Why:** patterns only become visible when failures are logged. Most of the doctrine in `eco-agentic-doctrine` came from logged incidents.

---

## Procedure 8 — Secrets discipline

**When:** every commit, on every branch, forever. Enforced automatically by the `gitleaks` pre-commit hook (per DEC-024). No human-action trigger — the hook fires on `git commit`.

**What:**
1. The hook scans staged content with `gitleaks protect --staged --config .gitleaks.toml`.
2. On positive match, the commit is **blocked**. The agent / operator follows the DEC-025 response sequence:
   - Treat the matched content as compromised — rotate at source immediately.
   - Remove the matched content from the staged diff.
   - File an INCIDENT entry with redacted detail (Procedure 7).
   - If the rule is a false positive, extend `.gitleaks.toml` allowlist with a tight pattern.
3. Bypassing the hook with `git commit --no-verify` is itself a banned move except inside an INCIDENT response, and even then only after rotation and redacted-incident filing.

**Setup (one-time per clone):**
- Install `gitleaks` (https://github.com/gitleaks/gitleaks) so it's on `PATH`.
- `git config core.hooksPath .githooks` to activate the committed hook.

**Form:** none — the hook + `.gitleaks.toml` + INCIDENT log is the audit trail. The DEC-025 sensitive-content list (mirrored in PROJECT.md) is the canonical reference for what counts as a secret.

**Why:** the project's privacy story (BYOK, conversations stay on device, "the one you own") relies on architectural separation. A leaked Anthropic key, Lemon Squeezy webhook secret, or Ed25519 license-signing key would break that story instantly and irreversibly once on a public repo. Pre-commit is the cheapest layer to prevent the failure mode. Detection-after-push is too late for a public repo where commits are mirrored to clones, archives, and search engines within seconds.

---

## Procedure 9 — Session lifecycle

**When:** every session, regardless of role.

**What:**

1. **Sign in.** File a "session start" entry in `forms/SITE_LOG.md` using the template (heading line: `### YYYY-MM-DD HH:MM session start`). Include role, session goal, what you're resuming from, context loaded (PROJECT.md / PROCEDURES.md / state/current.md), open MSes, open RFIs awaiting you, and the result of the pre-session validator run. **PASS before starting work.**
2. **Work.** File MS / DEC / RFI / INCIDENT / DONE entries as normal during the session. Each entry includes the session start timestamp in its body for trail reconstruction.
3. **Sign out.** File a "session end" entry in `forms/SITE_LOG.md` using the template (heading line: `### YYYY-MM-DD HH:MM session end`). Include role, outcome, files touched, validator run at end (PASS or FAIL), state/current.md updated yes/no, next action, handover note. **Update `state/current.md` if anything changed** (phase, MS status, counters, RFIs opened/closed, INCIDENTs filed).

A session that ends without a sign-out entry is a procedural incident. The next session's first action (after their own sign-in) is to file an INCIDENT for the missing sign-out and reconstruct what was done.

A session that starts without a sign-in is a procedural incident. Catch it immediately, file the INCIDENT, then file the proper sign-in retroactively.

**Form:** this procedure uses `forms/SITE_LOG.md` (sign-in / sign-out) and `state/current.md` (persistent state). No new form template — the SITE_LOG templates and the validator are the form.

**Enforcement:** `scripts/validate.sh` runs as the second step of the pre-commit hook (after gitleaks). The validator hard-fails if a session-start has no matching session-end from a prior session, if state counters drift from actual entry counts, on numbering gaps / cross-reference breaks, or on MS chain dependencies that aren't yet DONE (per DEC-026 + INC-006).

**README Status sync (mechanical, per MS-006 Scope G):** if `state/current.md` is updated at sign-out, `README.md`'s "Status" section must be updated to match. The validator's 10th check (`scripts/validate.sh` check 10) compares the phase identifier in state's `## Phase` "Current:" line against README's `## Status` first non-empty line. Drift hard-fails the pre-commit hook with a specific FAIL message naming both lines.

**Why:** AI agents are stateless across sessions. The lifecycle gives every session a known start state and a known end state, so handovers don't degrade. Trust-based procedure breaks under fatigue, time pressure, or agent reset; mechanical lifecycle enforcement does not.

---

## Section-gated MSes (`forms/SIGN_OFF.md`)

Some MSes are large enough that signing them off as a single unit at DONE-time loses too much detail — a failure in section 5 might invalidate sections 6-8 work. For those, an MS opts into a section-gated execution model: each section gets its own checklist, findings, and `Operator sign-off:` field in `forms/SIGN_OFF.md`. Sections must be completed in order; section N+1 cannot begin until section N is signed off in chat (per the magic-string format `Section N signed off by operator on YYYY-MM-DD`, copied verbatim into the section's entry at the next session sign-in per the same DEC-032 mechanism that handles DONE-form sign-offs). DONE for the whole MS is filed only after the final section signs off. Currently only **MS-009** uses this form (pre-Phase-1 deep check, 8 sections); future MSes opt in case-by-case based on scope. SIGN_OFF.md is not subject to the validator's numbering checks (those apply to DEC/RFI/INC/MS only); section ordering is enforced procedurally.

---

## Summary

| Trigger | Form | Procedure |
|---|---|---|
| New session starts | SITE_LOG | 1. Induction |
| About to edit a file | METHOD_STATEMENT | 2. Method statement |
| Claiming a task complete | DONE | 3. Done means proof |
| Made a non-obvious choice | DECISION | 4. Decision log |
| Tempted to expand scope | CHANGE_ORDER | 5. Scope fence |
| Don't know the answer | RFI | 6. Request for information |
| Something broke | INCIDENT | 7. Incident log |
| Every commit (automatic) | (gitleaks hook) | 8. Secrets discipline |
| Session sign-in / sign-out | SITE_LOG + state/current.md | 9. Session lifecycle |

If a procedure feels like overhead, that's the procedure working. Without it, the project drifts in ways nobody notices until later.
