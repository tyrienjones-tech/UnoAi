# UnoAi

Browser-based AI companion. Buy once, BYOK, conversations stay on your device.

**License:** PolyForm Noncommercial 1.0.0 — see [LICENSE](./LICENSE).

---

[Marketing copy goes here in Phase 1]

---

Self-hosting

The source is public — verify what it does, fork it, run it yourself if you want. PolyForm Noncommercial license permits personal self-hosting (see LICENSE).

The $9 hosted version is for people who'd rather skip the setup. You're paying for the hosting, the updates, and the work of keeping it running — not the code itself.

If you self-host, you are responsible for your own deployment, your own users, and your own legal compliance. The hosted version's terms and protections do not transfer to self-hosted instances.

---

## For agents working on this project

**Start here every session:**

1. Read [`PROJECT.md`](./PROJECT.md) — what this is, who you are, what's banned
2. Read [`PROCEDURES.md`](./PROCEDURES.md) — the eight rules
3. Skim [`PLAN.md`](./PLAN.md) — the phased build, find the current phase
4. File a SITE_LOG entry in [`forms/SITE_LOG.md`](./forms/SITE_LOG.md)
5. Then begin work

If you're about to mutate a file: file a METHOD_STATEMENT first.

If you're about to claim a task is done: attach proof to a DONE entry.

If you don't know something: file an RFI, don't guess.

### File map

```
unoai/
├── README.md            ← you are here
├── LICENSE              ← PolyForm Noncommercial 1.0.0 (committed in Phase 0b)
├── PROJECT.md           ← read first, every session
├── PLAN.md              ← phased build with acceptance criteria
├── PROCEDURES.md        ← the eight rules
└── forms/
    ├── SITE_LOG.md         ← session diary, append-only
    ├── METHOD_STATEMENT.md ← file before mutating anything
    ├── DONE.md             ← file with proof when complete
    ├── DECISION.md         ← log non-obvious choices
    ├── CHANGE_ORDER.md     ← when scope wants to expand
    ├── RFI.md              ← when you need an answer to proceed
    └── INCIDENT.md         ← when something breaks
```

---

## Status

Phase 0b in progress (MS-003). See [`PLAN.md`](./PLAN.md).
