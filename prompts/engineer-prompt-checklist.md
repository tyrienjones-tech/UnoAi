# Engineer prompt-writing checklist

This is the checklist Engineer runs through before sending any prompt to Builder. Each item is a known failure mode caught by an Engineer working agreement. Going through the list takes ~2 minutes; skipping it has cost real time across multiple MSes.

> **Scope note:** This checklist covers **prompt-writing only** — the work of drafting an MS prompt to send to Builder. It does *not* cover the separate disciplines around DONE sign-off (working agreements #9 / #12 / #14, handled by Engineer's verification flow at sign-off time) or Builder's execution discipline (working agreements #3 / #7 / #8, handled by Builder during MS application). All three sets of agreements live in the same list in `state/current.md`; this checklist is the prompt-writing slice.

## Before writing the prompt

1. **Read `state/current.md`.** Specifically the "Counters" section. Note the actual current values for:
   - Latest MS
   - Latest DEC
   - Latest RFI
   - Latest INC

2. **Read `forms/RFI.md`.** Note which RFIs are still open. Any prompt that references "Closes: RFI-NNN" must point at one that exists.

3. **Read `forms/DECISION.md`.** Note any DECs marked "superseded" or "in flight." Don't reference DECs that have been retired.

## While writing the prompt

4. **DEC numbering: sequential from current state.** If the prompt files new DECs, they are DEC-(latest+1), DEC-(latest+2), etc. No skips. (Working agreement #5.)

5. **References resolve to committed files.** If the prompt references prior decisions, cite by DEC/MS/INC/RFI number, not by chat-message annotation ("H2a", "as we discussed", "the prior turn"). Chat-discussion labels do not exist in the file system. (Working agreement #11.)

6. **Scope-by-section means all references in section.** If the scope says "update PROJECT.md banned moves section," the prompt explicitly notes that other places in PROJECT.md may also reference the value being changed and should be checked too. (Working agreement #2.)

7. **Bash budget caps are estimated against current size, not from "what feels right."** If the prompt sets a validator size cap, it's "current size + estimated new check size + buffer." (Working agreement #10.)

## Before sending the prompt

8. **Verify each `Closes:` reference resolves.** Open `forms/RFI.md` and confirm every `RFI-NNN` cited in the prompt's DECs actually exists. If it doesn't exist, either open it in the prompt's scope OR drop the `Closes:` line. (Working agreement #1.)

9. **Verify file-state references match committed files.** If the prompt says "the existing X" or "as it currently stands," verify by reading the actual committed file, not by trusting the chat history. (Working agreement #11.)

10. **For repo-creation MSes: verify remote state at create-time.** GitHub auto-init, default branch, default permissions — all need to be checked when the repo is created, not when Builder clones. (Working agreement #6.)

11. **Don't authorise prep work for "hold" answers.** If Builder is correctly waiting and there's no real work product to define, the answer is "hold" — not "useful things to do while waiting." (Working agreement #4.)

12. **Pushback framing is neutral, not fault-implying.** Verification questions are "what state is X in?", not "did you do X correctly?". The first produces diagnostic responses; the second produces defensive ones. (Working agreement #13.)

13. **DONE sign-off verification uses API endpoints, not HTML.** When verifying repo state for sign-off, query `api.github.com/repos/.../git/refs/heads/main`, not the HTML repo page. HTML pages stale at multi-hour intervals. (Working agreement #14.)

## After sending the prompt

14. **If Builder RFIs, the RFI is the procedure working, not a problem.** Builder asking permission for a default they've already reasoned through is the discipline. Engineer's job is to confirm or override, not to discourage future RFIs.

## When the agreements list grows

This checklist mirrors the Engineer working agreements list in `state/current.md`. When new agreements are added there (via DONE sign-off), add a corresponding checklist item here — but only if the new agreement is about **prompt-writing**. Builder-discipline and DONE-sign-off agreements stay in their respective domains. The list in `state/current.md` is canonical for all agreements; this checklist is the prompt-writing-scoped subset.

If they drift: the validator should catch it (future enhancement — not currently checked). Until then, manual sync at MS sign-out.
