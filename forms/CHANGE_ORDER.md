# Change order

Filed when scope shifts mid-task. Operator approves before any work proceeds on the change. Numbered CO-001 onwards.

**Default disposition for v1: deferred to v2.** The operator has to actively choose to expand v1 scope.

---

## Template

```
### CO-NNN — [short title]
- **Date:** YYYY-MM-DD
- **Filed by:** [agent name]
- **Triggered during:** MS-NNN
- **Phase:** [number + name]

**Original scope (from MS-NNN):**
[Verbatim from the method statement.]

**Proposed change:**
[What's being added / removed / shifted.]

**Why surfacing this:**
[What changed mid-task. Was this discovered? Is it blocking the original scope? Is it just a nice-to-have?]

**Classification:**
- [ ] Required to complete original scope (blocking)
- [ ] Useful improvement, not blocking
- [ ] Scope creep that would feel good but isn't needed

**Impact:**
- Time: [estimate]
- Cost: [if any — domains, services, API tiers]
- Other phases affected: [list]
- Dependencies added: [if any]

**Recommendation:**
- [ ] Accept (extend v1 scope)
- [ ] Reject (revert and complete original scope only)
- [ ] Defer (log as v2 backlog, complete original v1 scope now)

**Operator decision:** [pending / accepted / rejected / deferred]
**Decision notes:**
[Optional. Reason for the call, any conditions.]
```

---

## Example

```
### CO-002 — Add token usage tracking
- Date: 2026-04-27
- Filed by: Reaper-1
- Triggered during: MS-005 (streaming Anthropic responses)
- Phase: 2

Original scope:
Direct fetch to api.anthropic.com with streaming. User's browser to Anthropic, no proxy.

Proposed change:
Add a small token-usage counter in the UI that shows prompt + completion tokens for the last message and a running session total.

Why surfacing this:
While testing streaming, noticed Anthropic returns usage metadata in the response. Would be cheap to display. Users with BYOK might want to see what they're spending.

Classification: scope creep that would feel good but isn't needed.

Impact:
- Time: ~2 hours
- Cost: none
- Other phases: would touch Phase 7 polish
- Dependencies: none

Recommendation: defer to v2.

Operator decision: deferred
Decision notes: agreed, queue for v2 alongside any other "billing transparency" features.
```

---

## Entries

<!-- Append below this line. -->
