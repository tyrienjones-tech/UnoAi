# UnoAi

Browser-based AI companion. Buy once, BYOK, conversations stay on your device.

**License:** PolyForm Noncommercial 1.0.0 — see [LICENSE](./LICENSE).

---

[Marketing copy goes here in Phase 1]

---

## Self-hosting

The source is public — verify what it does, fork it, run it yourself if you want. PolyForm Noncommercial license permits personal self-hosting (see LICENSE).

The $9 hosted version is for people who'd rather skip the setup. You're paying for the hosting, the updates, and the work of keeping it running — not the code itself.

If you self-host, you are responsible for your own deployment, your own users, and your own legal compliance. The hosted version's terms and protections do not transfer to self-hosted instances.

---

## For agents working on this project

Fresh Engineer sessions on this project should start by reading [`prompts/engineer-session-start.md`](./prompts/engineer-session-start.md).

**Start here every session:**

1. Read [`PROJECT.md`](./PROJECT.md) — what this is, who you are, what's banned
2. Read [`PROCEDURES.md`](./PROCEDURES.md) — the nine rules
3. Read [`state/current.md`](./state/current.md) — current phase, counters, open RFIs, pending operator actions
4. Skim [`PLAN.md`](./PLAN.md) — the phased build, find the current phase
5. Run `bash scripts/validate.sh` from the repo root — confirm `VALIDATOR: PASS` before starting work
6. File a session-start entry in [`forms/SITE_LOG.md`](./forms/SITE_LOG.md) using the template at the top of that file
7. Then begin work

If you're about to mutate a file: file a METHOD_STATEMENT first.

If you're about to claim a task is done: attach proof to a DONE entry.

If you don't know something: file an RFI, don't guess.

**Sign-in / sign-out heading-line format (strict, validator-parsed):**

- Sign in: `### YYYY-MM-DD HH:MM session start`
- Sign out: `### YYYY-MM-DD HH:MM session end`

Validator regex: `^### \d{4}-\d{2}-\d{2} \d{2}:\d{2} session (start|end)$`. Any deviation breaks parsing and the pre-commit hook will hard-fail. See `forms/SITE_LOG.md` top section for the body template.

### File map

```
unoai/
├── README.md            ← you are here
├── LICENSE              ← PolyForm Noncommercial 1.0.0
├── CONTRIBUTING.md      ← bug reports yes, PRs no (per DEC-018)
├── CONTEXT.md           ← what UnoAi is, conceptually (agent onboarding)
├── PROJECT.md           ← read first, every session
├── PLAN.md              ← phased build with acceptance criteria
├── PROCEDURES.md        ← the nine rules
├── .gitleaks.toml       ← secrets ruleset (per DEC-024)
├── .githooks/           ← pre-commit hook (gitleaks + validator + Prettier + ESLint)
├── prompts/
│   ├── engineer-session-start.md     ← paste at fresh Engineer session start
│   └── engineer-prompt-checklist.md  ← Engineer reads before writing prompts to Builder
├── scripts/
│   └── validate.sh      ← structural-integrity validator (per DEC-026)
├── state/
│   └── current.md       ← phase, counters, open RFIs (auto-updated at sign-out)
└── forms/
    ├── SITE_LOG.md         ← session diary + sign-in/sign-out templates
    ├── METHOD_STATEMENT.md ← file before mutating anything
    ├── DONE.md             ← file with proof when complete
    ├── DECISION.md         ← log non-obvious choices
    ├── CHANGE_ORDER.md     ← when scope wants to expand
    ├── RFI.md              ← when you need an answer to proceed
    └── INCIDENT.md         ← when something breaks
```

---

## Status

Phase 0b complete. Infrastructure phase in progress (MS-005). Phase 1 begins after MS-006 DONE. See [`PLAN.md`](./PLAN.md).
