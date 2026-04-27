# Procedures

Eight procedures govern this project. Each maps to a form template in `/forms/`, except Procedure 8 (secrets discipline) which is enforced by the `gitleaks` pre-commit hook rather than a paper form. Every procedure exists because of a specific failure mode it prevents — the *why* is as important as the *what*.

---

## Procedure 1 — Site induction

**When:** every new agent session, before any other action.

**What:**
1. Read `PROJECT.md` (full)
2. Read `PLAN.md` (skim, focus on current phase)
3. Skim the most recent 3 entries in `forms/SITE_LOG.md`
4. File a SITE_LOG entry: "Arrived. Read induction. Working on phase X."
5. Then begin work.

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

**Proof division (per DEC-011):**
- **Builder produces:** test output (paste or path), git diffs (SHA range), deployed/staging URL, console logs.
- **Operator captures:** screenshots, screen recordings, visual UI confirmation against the Builder-produced live URL.

A description of expected behaviour is **not proof**. "It works on my machine" is not proof. "I'm confident it's correct" is not proof. The DONE entry must cite at least one Builder-produced artefact and at least one Operator-captured artefact (where applicable to the phase).

**Form:** `forms/DONE.md` (append-only, DONE-001 onwards)

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

If a procedure feels like overhead, that's the procedure working. Without it, the project drifts in ways nobody notices until later.
