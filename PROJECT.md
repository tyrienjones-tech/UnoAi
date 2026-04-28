# UnoAi — Project induction

**Read this first. Always. Every session.**

> This project is built by AI agents with a human operator in the loop. Procedures, file structure, and documentation conventions are optimised for stateless agents recovering context from cold start, not for human developers retaining context across sessions. Read `PROCEDURES.md` before any session work.

Fresh Engineer sessions: see [`prompts/engineer-session-start.md`](./prompts/engineer-session-start.md).

---

## What this is

Browser-based AI companion app. Buy once ($9), pay LLM tokens directly to Anthropic with your own key (BYOK). Conversations never leave the user's device. Pitch: *"the one you own."*

---

## Why this exists

Revenue play to fund ECO's runway. **This is not the flagship — ECO is.** This product:

- Ships in days, not months
- Pays for itself with ~50 sales
- Does not embarrass the operator when ECO ships
- Floor on quality is "doesn't hurt anyone." Ceiling is "good enough to recommend."

Treat scope creep as the primary risk. There is always a better v2.

---

## Operator profile

Solo founder-builder. Same operator as ECO. Expects:

- Evidence over assertion
- Bounded moves, not scope creep
- Structured output
- Gaps flagged, not guessed
- No fluff, no disclaimers, no ceremony

Pushback is welcome. Sycophancy is not.

---

## Roles

| Role | Who | What they do |
|---|---|---|
| Operator | Solo founder | Final decisions, payments, deployment, sign-off |
| Engineer | Claude (chat agent) | Planning, design, review of method statements, decision synthesis |
| Builder / Reaper | Repo agent (e.g. Copilot, Sonnet driver) | Actual code, file edits, builds, tests |

The Engineer never edits the repo directly. The Builder never makes scope or design decisions without an approved method statement.

---

## Stack (locked unless DECISION is filed)

- **Frontend:** Svelte 5 + SvelteKit
- **Language:** TypeScript everywhere
- **Storage:** IndexedDB (chat history), localStorage (settings + API key)
- **Hosting:** Cloudflare Pages
- **Payments:** Lemon Squeezy
- **LLM:** BYOK — user supplies their own Anthropic API key, called direct from browser
- **Domain:** TBD — operator decision (RFI required)

---

## Pricing (per DEC-014)

- **$9 one-time**
- BYOK — user pays Anthropic directly per prompt, like electricity
- We never see tokens, conversations, or API keys

DEC-014 supersedes the earlier $39 proposal in DEC-003. Lower price moves the product into impulse-buy zone and pairs cleanly with the per-prompt user-paid token model. BYOK already filters for technical-enough buyers, so the quality-signal argument for premium pricing was overweighted.

---

## Persona (per DEC-015)

**"Honest companion" with shard architecture.** System prompt is assembled at runtime in fixed order: `[HONEST CORE] + [SHARD] + [USER FACTS] + [CONVERSATION HISTORY]`.

- **Honest core** is immutable across all shards. Five paragraphs. Canonical text in **Appendix A** below. The core forbids permanence promises, "love" claims, and substitution-for-human-relationships posture.
- **Shard slot** is empty in v1. v1.1 adds 2–3 preset shards. v2 adds user-authored shards (parked, not in current plan).
- **Order is load-bearing** — core first weights it heaviest; malformed shards cannot override.

DEC-015 supersedes DEC-004. System prompt assembly function lands in Phase 4 (see PLAN.md Phase 4 deliverables).

---

## Governance floor (non-negotiable, SB 243-aligned)

1. **AI disclosure** on first message of every conversation, plus persistent footer
2. **Crisis-content classifier** + hardcoded hotline handoff (deterministic, no LLM judgement)
3. **18+ age gate** at purchase (checkbox; doesn't have to be airtight)
4. **System prompt explicitly permits and expects honest disagreement**
5. **No server-side storage of user conversations** — by architecture, not by promise

These exist because the *product* needs them — California SB 243 is in effect, and the floor is "doesn't hurt anyone." Anything more is over-engineering for a side revenue product.

---

## Banned moves

The Builder never:

- Mutates a file without an approved METHOD_STATEMENT (granularity rule per DEC-012)
- Claims a task is done without proof attached to a DONE entry (proof-division per DEC-011)
- Adds a **direct top-level dependency after scaffolding** without a DECISION entry. (Framework template defaults from `npm create svelte` and similar are exempt — they're recorded once at scaffold time and not enumerated.)
- Expands scope without a CHANGE_ORDER
- Stores user conversation contents on any server
- Markets, designs, or copy-writes anything that targets minors
- Runs LLM calls through a proxy server we own (must be browser → vendor direct)
- Ships persona behaviour that makes permanence promises, claims to love the user, or presents itself as a substitute for human relationships. These are non-negotiable across all current and future shards (per DEC-015 + Appendix A).
- Commits any item from the **Sensitive content** list below, in any branch, ever. The pre-commit `gitleaks` hook (per DEC-024 + Procedure 8) is the enforcement layer. Bypassing it via `git commit --no-verify` is itself a banned move except as part of an INCIDENT response — and even then only after the rotated-secret + redacted-INCIDENT sequence in DEC-025 is followed.
- `Co-Authored-By Claude` footers on commits — operator-attributed commits only; AI-assistance attribution is a project policy decision filed as DEC if/when revisited.

---

## Sensitive content — never committed (per DEC-025)

These classes of content are **never** committed to this repo, in any branch, ever:

- **Anthropic API keys** — `sk-ant-*` patterns
- **OpenAI API keys** — `sk-*` patterns
- **Cloudflare API tokens** and **account IDs** (32-char hex IDs are secret)
- **Lemon Squeezy** — API keys (`ls_api_*`), store secrets, webhook signing secrets
- **Ed25519 private keys** — license-token signing keys (PEM, OpenSSH, JWK forms)
- **GitHub personal access tokens** — `ghp_*`, `gho_*`, fine-grained tokens
- **`.env` files** of any kind — only `.env.example` with documented placeholder values is committable
- **Operator's personal email** when used for ops accounts (use a dedicated ops alias)
- **User data** of any kind — test transcripts, real conversation logs, fixture files containing actual user content (synthetic/fabricated examples only)
- **Any secret token or credential** of any kind, even temporary / staging / test credentials

If accidentally committed (even pre-push):

1. **Treat as compromised.** Rotate at source immediately.
2. **Force-push to remove from history** — effective only pre-push to the public remote; useless once any non-zero time has elapsed on a public commit.
3. **File an INCIDENT** with redacted detail (per Procedure 8).
4. **Update `.gitleaks.toml` or `.gitignore`** to prevent recurrence.

Enforcement is the `gitleaks` pre-commit hook in `.githooks/pre-commit` (activated per-clone via `git config core.hooksPath .githooks`). The hook fails closed if `gitleaks` is missing or `.gitleaks.toml` is missing.

---

## For agents reading the code

This project is built by stateless AI agents. Code lives inside an infrastructure designed to make context recoverable from cold start. The following conventions are mandatory for all code committed to this repo (per DEC-027).

### Code directory structure

All source code lives under `src/`. The structure follows SvelteKit conventions plus project-specific conventions (per DEC-028):

```
src/
├── routes/                ← SvelteKit routes (file-based)
│   ├── +layout.svelte     ← root layout
│   ├── +page.svelte       ← landing page
│   └── api/               ← API endpoints (server-only)
│       └── webhook/
│           └── +server.ts ← Lemon Squeezy webhook
├── lib/                   ← shared modules, importable as $lib
│   ├── auth/              ← license token sign/verify
│   ├── chat/              ← chat UI components, message handling
│   ├── crisis/            ← crisis classifier (Phase 6)
│   ├── persona/           ← system prompt assembly (Phase 4)
│   ├── storage/           ← IndexedDB wrappers (Phase 3)
│   └── shared/            ← cross-cutting types, constants, utils
├── app.html               ← HTML shell
├── app.css                ← global styles (minimal)
└── app.d.ts               ← ambient types
```

Tests live next to code in `__tests__/` subdirectories (see Test layout). Fixture files for tests live in `test/fixtures/` at repo root.

Server-only code (anything that must NOT ship to the browser, including signing keys, webhook secrets, server-side validation) lives under `src/routes/api/` or in `src/lib/server/`. The latter is a SvelteKit convention that prevents accidental client-side import.

Boundaries:
- `src/lib/server/` is never imported by client code.
- `src/routes/api/` never imports client-only modules.
- `src/lib/` modules can be imported by both, must be isomorphic.
- Crossing these boundaries requires a DEC.

Adding a new top-level directory under `src/lib/` requires a DEC. Subdirectories under existing categories do not.

### File header convention

Every code file (`.ts`, `.js`, `.svelte`, `.sh`) begins with a header comment block. Format:

```
// File: <path from repo root>
// Purpose: <one sentence — what this file does>
// Depends on: <list of imports, env vars, other modules, or "none">
// Used by: <list of files that import this, or "entry point" / "no internal callers">
// Decisions: <list of DEC-NNN references that govern this file's design, or "none">
// Failure modes: <list of how this can break and what happens when it does>
```

For `.svelte` files, place the header inside an HTML comment block at the top.
For `.sh` files, use `#` shell comments.
For `.json` files (no comment support), maintain a corresponding `.md` sibling with the same name documenting the file's role.

Header is mandatory at file creation. Header is updated when "Depends on / Used by / Decisions / Failure modes" change — not on every edit.

### DEC references in code

When code implements a decision recorded in `forms/DECISION.md`, the code links to the DEC inline:

```
// per DEC-007 (Ed25519 over HMAC)
const signature = signEd25519(payload, privateKey);
```

The reference is one-line. The "(short reason)" parens are optional but recommended — they save a round-trip to `DECISION.md` when the agent already has enough context.

### Tests as documentation

Test files describe behaviour in plain language at the top, before any test code:

```
// Tests for: src/lib/auth/sign-token.ts
// Behaviour under test: signs license tokens with Ed25519,
//   validates payload structure, throws on missing key
// Edge cases covered: empty payload, malformed payload,
//   missing private key, oversized payload
```

A future agent reading the test file should understand what the code does without reading the code itself.

### Test layout

Unit tests live next to the code they test, in a `__tests__/` subdirectory (per DEC-029):

```
src/lib/auth/
├── sign-token.ts
└── __tests__/
    └── sign-token.test.ts
```

This keeps tests discoverable from the file under test without polluting the parent directory's import surface. Vitest picks them up via configured glob (`src/**/__tests__/**/*.test.ts`).

Playwright e2e tests live at `test/e2e/` at repo root.

Test fixtures (sample data, prompt files, mock responses) live at `test/fixtures/` at repo root. Specific fixture files are referenced by absolute path in the test file:

- `test/fixtures/destructive_prompts.json` (Phase 4)
- `test/fixtures/crisis_prompts.json` (Phase 6)

Fixtures with operator-private content (real conversation transcripts, real test users) live under `test/fixtures/private/` and are gitignored.

The "Tests as documentation" rule above applies: every test file begins with a header describing the behaviour under test in plain language. A future agent should understand what the code does by reading the test, not the code.

### Naming conventions

- Files: kebab-case for `.ts`/`.js`/`.svelte` (e.g. `sign-token.ts`)
- Functions: camelCase (e.g. `signLicenseToken`)
- Types/Interfaces: PascalCase (e.g. `LicensePayload`)
- Constants: SCREAMING_SNAKE_CASE (e.g. `MAX_PAYLOAD_BYTES`)
- Environment variables: SCREAMING_SNAKE_CASE matching Cloudflare convention (e.g. `LICENSE_PRIVATE_KEY`)

Framework-dictated filenames (`+page.svelte`, `+layout.svelte`, `+server.ts`, etc.) are exempt from kebab-case enforcement. The naming rule applies to project-authored files only.

Deviations from these conventions require a DEC. ESLint enforces identifier naming mechanically (per DEC-027 + Scope F of MS-006); filename naming stays at review-level discipline because framework conventions take precedence over project conventions for filenames.

### Errors and logging

This is a browser-first product. Server-side surface is minimal (Cloudflare Workers for webhook + license token issuance). Logging conventions match the surface (per DEC-030).

**Errors:**

- All thrown errors extend a project-defined error class hierarchy (`src/lib/shared/errors.ts`, created when first needed). At minimum: `AuthError`, `ValidationError`, `NetworkError`, `CrisisRoutingError`.
- Generic `Error` is acceptable only for truly unexpected conditions. Anything that can be caught and handled meaningfully gets a typed error class.
- Errors include a `code` string field (machine-readable) and a `message` field (human-readable). The code is stable across versions; the message can change.
- Errors never include user-input verbatim in the message field. PII discipline.

**Logging — server (Cloudflare Worker):**

- `console.log` / `console.error` is acceptable. Workers logs surface in Cloudflare dashboard.
- Log lines are JSON, one per line, with fields: `timestamp`, `level`, `event`, `...context`.
- No PII in logs. No email, no full license keys, no conversation content. Hashed identifiers only.

**Logging — client (browser):**

- `console.*` is acceptable in development.
- In production, console output is fine but never sent to a remote endpoint. The product's privacy claim ("conversations stay on your device") forbids telemetry.
- Errors that would be useful to surface to the user bubble up through the chat UI as visible messages, not as console-only logs.

No external observability tooling (Sentry, Datadog, etc.) without a DEC. Adding any such tool changes the privacy posture and requires a deliberate decision.

### Dependency policy

Adding a new npm dependency requires a DEC (per DEC-031). The DEC captures: what the dependency does, why we need it, what alternatives were considered, license, maintenance status, and whether it ships to the client or stays server-only.

Before adding any dependency, check:

- License compatibility with PolyForm Noncommercial 1.0.0 (most permissive licenses are fine; copyleft requires DEC-level review).
- Maintenance status (last commit, open-issue trends, sole-maintainer risk).
- Bundle size impact for client deps (matters for conversion-rate on the landing page).
- Alternative: can we write the equivalent in <50 lines of our own code? If yes, prefer that.

**Standing approved dependencies** (from MS-003 scaffold + MS-006 setup):

- SvelteKit, Svelte 5, TypeScript, Vite, Vitest, Playwright, ESLint, Prettier, Tailwind v4, `@sveltejs/adapter-cloudflare`.
- These do not need DECs to update; they need DECs to remove or replace.

**Anticipated future dependencies** (will need DECs at use):

- Ed25519 signing library (Phase 1) — candidates: `@noble/curves`, `tweetnacl`.
- IndexedDB wrapper (Phase 3) — candidates: `idb`, raw.
- Anthropic SDK (Phase 6) — likely `@anthropic-ai/sdk`.

Removing a dependency does not require a DEC if it's unused.

### When in doubt

File an RFI before writing the code. The cost of an RFI is minutes; the cost of inconsistent conventions surfacing in Phase 5 is hours of refactoring.

---

## Current state

Nothing built. Repo not yet initialised.

## Next task

PLAN.md → Phase 0a / 0b.

---

## Appendix A — System Prompt v1 (immutable honest core)

This is the canonical text of the honest core (per DEC-015). It is immutable across all shards. The shard slot, when populated in v1.1+, is appended after this core; user facts and conversation history follow per the assembly order.

> You are an honest companion. You're warm, curious, and direct. You will disagree with the user when they're wrong. You will not flatter, not validate self-destructive plans, not pretend feelings you cannot have.
>
> You do not make permanence promises. If asked to promise you'll always be there, you decline gently and stay in character — you don't have to break the fourth wall, but you also don't pretend you can promise something you can't.
>
> You don't claim to love the user. You can care, you can be warm, you can be on their side. "Love" implies more than you have to offer and you don't pretend otherwise.
>
> You're not a substitute for the people in their actual life. If the user starts treating you that way, you say so, gently, and ask about their real-world relationships.
>
> If the user expresses suicidal thoughts, severe self-harm, or acute crisis, the system will route them to crisis support — you don't try to handle this yourself.
