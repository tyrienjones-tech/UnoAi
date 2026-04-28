# UnoAi — Glossary

This file is the canonical reference for project terms. Every acronym, role, decision-class, and architecture-specific term used across the repo is defined here. When terms drift between files, this file is the source of truth.

For procedure: read [`PROCEDURES.md`](./PROCEDURES.md).
For project context: read [`CONTEXT.md`](./CONTEXT.md).
For session-start: read [`prompts/engineer-session-start.md`](./prompts/engineer-session-start.md).

---

## A

**AGENTS.md** — convention some open-source projects use for agent-onboarding documentation; UnoAi uses `prompts/` directory instead but the role is similar.

**Anthropic** — the company that builds the Claude AI models. UnoAi is BYOK to Anthropic's API for chat completions.

**API key** — credential that authorises a request to a service. UnoAi never stores or proxies API keys server-side; users enter their own at runtime (BYOK).

## B

**banned moves** — list of project-wide prohibitions in PROJECT.md, restated in `state/current.md` for visibility. Includes "no permanence promises in persona" and "no Co-Authored-By Claude footers on commits."

**BYOK** — Bring Your Own Key. UnoAi's architecture: users provide their own Anthropic API key; UnoAi never holds keys or relays conversation traffic.

**Builder** — the role of executing changes in the repo. Currently filled by Reaper (Claude Code in operator's terminal). Builder files MSes, runs commands, commits code. Distinguished from Engineer (who writes the prompts Builder executes).

## C

**cache TTL** — Time-To-Live; how long a cached response stays valid before re-fetching. GitHub's API endpoint for `refs/heads/main` caches for 60 seconds; HTML pages cache for hours. See working agreement #14.

**chain check** — validator's 9th check (per INC-006 / MS-005): no MS marked in-progress can have a "Depends on: MS-NNN" referencing a target that isn't yet DONE. Mechanically prevents out-of-sequence MS filing.

**CHANGE_ORDER** — form template at `forms/CHANGE_ORDER.md`. Filed when scope expansion is tempting but undecided. CO-001 onwards.

**Claude** — Anthropic's family of AI models. The Engineer role in this project is filled by Claude (in chat); the Builder role is filled by Claude Code (in terminal).

**Cloudflare Pages** — hosting platform UnoAi will deploy to (Phase 1+). Static site + Workers for the license-issuance webhook.

**CONTEXT.md** — agent-onboarding-focused file at repo root. Distinct from PROJECT.md (procedural) and README.md (marketing). For agents joining mid-build to understand what UnoAi is conceptually.

**crisis classifier** — Phase 6 component that scans user messages for suicide/self-harm content before the bot replies normally. Hands off to crisis hotlines if triggered. Per DEC-008 / DEC-020 / DEC-021.

**cspell** — spell-check tool used in the pre-commit hook (per DEC-033). Code Spell Checker; npm-based; uses real dictionary data plus a project-specific dictionary at `.cspell.json`.

## D

**DEC** — Decision. Form template at `forms/DECISION.md`. Used for non-obvious choices (stack picks, library choices, pricing, persona details, scope locks). DEC-001 onwards. Append-only; superseded entries marked but not deleted.

**doctrine** — operator's standing rules for agentic AI behaviour. Lives at `/mnt/skills/user/eco-agentic-doctrine/SKILL.md`. Loaded at session start by Engineer instances per `prompts/engineer-session-start.md`.

**DONE** — form template at `forms/DONE.md`. Filed when an MS is complete, with proof. Builder produces test/diff/log proof; operator captures visual proof where applicable. Per DEC-011 + Procedure 3.

**DONE sign-off** — operator's confirmation that a DONE entry is accepted. Recorded via magic-string mechanism per DEC-032: operator types `DONE-NNN signed off by operator on YYYY-MM-DD` in chat; Builder copies verbatim into the entry's Operator sign-off field at next session sign-in.

## E

**Ed25519** — asymmetric cryptography algorithm used for license tokens (per DEC-007). Worker holds private key (Worker secret only); client embeds public key for verification. Replaced HMAC after the secrets-discipline review.

**ECO** — operator's flagship project; separate from UnoAi but sibling. Tauri/Rust governed AI control plane. UnoAi is a side revenue product funding ECO runway.

**Engineer** — the role of designing prompts and signing off DONEs. Currently filled by Claude in chat. Distinguished from Builder (who executes the prompts) and Operator (who sets direction).

**Engineer working agreement** — running list of discipline-failures-turned-rules in `state/current.md`. Numbered sequentially starting at #1. Each agreement names a specific failure pattern Engineer has exhibited and the rule that prevents recurrence.

## F

**fail-fast** — pre-commit hook chain pattern: each step runs in order, first failure aborts subsequent steps. Cheaper than running all checks and reporting all failures. See Procedure 8 + Scope F4 of MS-006.

**form** — generic term for templates in `forms/` directory: SITE_LOG, METHOD_STATEMENT, DONE, DECISION, RFI, INCIDENT, CHANGE_ORDER. Each form has its own append-only file; entries numbered sequentially within each form.

## G

**GitHub auto-init** — GitHub's checkbox-on-repo-create that adds an initial README/LICENSE/.gitignore. UnoAi's repo was auto-initialised despite the "no init files" instruction, producing the 31-byte fossil at SHA `372902c`. Pattern logged as INC-005.

**gitleaks** — secrets-scanner tool used in the pre-commit hook (per DEC-024). Scans staged content for known secret patterns; blocks commits on positive match. Configuration at `.gitleaks.toml`.

**GLOSSARY.md** — this file. Canonical reference for project terms.

## H

**HMAC** — keyed-hash signature scheme. Originally proposed for license signing but replaced by Ed25519 (per DEC-007) because asymmetric crypto avoids shipping a shared secret to clients. HMAC is still used by Lemon Squeezy for webhook signing (their choice, separate from license tokens).

**hosted version** — the $9 paid product at `unoai.[tld]` (TBD per RFI-009). Distinguished from self-hosted version (user runs the source themselves under PolyForm Noncommercial license).

## I

**INC** — Incident. Form template at `forms/INCIDENT.md`. Filed when something breaks, gets reverted, surprises the operator, or fails a test. INC-001 onwards. No-blame posture; logging incidents is how patterns become visible.

**IndexedDB** — browser-native local database UnoAi uses for conversation persistence (Phase 3). Conversations never leave the user's device, per the privacy claim.

## L

**Lemon Squeezy** — payment processor UnoAi will use for $9 license sales. Sends webhooks on purchase events; webhook signed with HMAC-SHA256 (their format). UnoAi's Worker verifies the webhook, then issues an Ed25519-signed license token to the buyer.

**LESSON-NNN** — numbered entries in the ECO doctrine (`/mnt/skills/user/eco-agentic-doctrine/SKILL.md`). Each LESSON captures a specific failure pattern observed in agentic AI work. Battle-tested across multiple projects.

## M

**METHOD_STATEMENT** — form template at `forms/METHOD_STATEMENT.md`. Filed before mutating any file. Numbered MS-001 onwards. Operator must approve before work begins. Per Procedure 2 + DEC-012 (granularity rule).

**MS** — short for METHOD_STATEMENT. Used interchangeably with the file form (e.g., "MS-007 was about agent onboarding"). Numbered sequentially; no skips per working agreement #5.

**MS chain** — section in `state/current.md` tracking which MSes are in progress, DONE, or pending. Each pending MS declares dependencies; validator's 9th check enforces that dependencies are DONE before dependent MS can be filed.

## O

**Operator** — the role of setting direction and signing off decisions. Currently filled by Tyrien Jones. The operator approves MSes, signs off DONEs, makes final calls on RFIs, and decides scope.

## P

**Phase** — major project milestone. PLAN.md defines Phases 0a, 0b, 1, 2, ..., 8 with acceptance criteria. Phases group related MSes; current phase is named in `state/current.md`.

**PLAN.md** — phased build plan with acceptance criteria. Read at session start. Updated when scope or estimates shift.

**PolyForm Noncommercial 1.0.0** — UnoAi's license (per DEC-019). Source-available for personal/audit use; commercial use forbidden without separate agreement. Permits self-hosting; protects the $9 hosted-version revenue.

**pre-commit hook** — git hook that runs before each commit. UnoAi's hook chain (after MS-008): gitleaks → validator → Prettier → ESLint → cspell. All five must pass; first failure blocks the commit.

**Prettier** — code formatter wired into the pre-commit hook (per MS-006 Scope F). Format violations block commits.

**Procedure** — numbered rule in PROCEDURES.md. Nine procedures total; each maps to a form template (or to mechanical enforcement, as Procedures 8 and 9 do).

**PROJECT.md** — project-overview file at repo root. First read at session start. Contains organising principle, banned moves, persona constraints, and "For agents reading the code" conventions.

**prompt** — text the Engineer writes for Builder to execute. Written per the checklist at `prompts/engineer-prompt-checklist.md`. The first session-start prompt for Engineer instances is at `prompts/engineer-session-start.md`.

## R

**Reaper** — the Builder's nickname (set in MS-001 prompt). Claude Code instance running in operator's terminal. Files MSes, runs commands, commits and pushes work to GitHub.

**README.md** — project's marketing-and-onboarding surface at repo root. Contains pitch, license badge, self-hosting section, and "For agents working on this project" section.

**RFI** — Request For Information. Form template at `forms/RFI.md`. Filed when blocked on a question only the operator (or Engineer) can answer. RFI-001 onwards. No work proceeds on the blocked task until answered.

## S

**SB 243** — California Senate Bill 243 (effective 2026-01-01). Regulates AI companion products. Created the liability framework UnoAi's persona constraints are designed against. See banned moves in PROJECT.md and DEC-022 for ToS implications.

**self-hosted** — running UnoAi from source on your own infrastructure. Permitted by the PolyForm Noncommercial license. Self-hosters are responsible for their own deployment, users, and legal compliance (per README self-hosting section).

**shard** — persona overlay architecture (per DEC-015). Immutable honest core + mutable shard slot. v1 ships with slot empty; v1.1 adds preset shards; user-authored shards parked for v2.

**SITE_LOG** — form template at `forms/SITE_LOG.md`. Append-only session diary. Sign-in / sign-out entries mandatory per Procedure 9; templates at top of file.

**state/current.md** — single file capturing current project state. Updated at every session sign-out. Read at every sign-in. Contains phase, counters, MS chain status, open RFIs, pending operator actions, working agreements list.

**SvelteKit** — UnoAi's web framework (per DEC-001 / DEC-013). Svelte 5 + adapter-cloudflare for Pages deployment.

**synthetic test** — test that introduces a deliberate violation of a discipline (numbering gap, missing cross-reference, ESLint rule, etc.) to verify the enforcing tooling actually catches it. Mandatory before shipping any tooling per working agreement #8 — untested validators are worse than no validator.

## T

**Tailwind v4** — CSS framework UnoAi uses (per MS-003 Decision 2 + MS-006 ESLint config). v4 was sv 0.15.1's scaffold default; v4 chosen over v3 because the framework's default IS the ecosystem recommendation.

## U

**UnoAi** — the project. Browser-based AI companion, $9 one-time, BYOK to Anthropic, conversations stay on device. Public-source under PolyForm Noncommercial. The pitch in one line: *"the one you own."*

## V

**validator** — bash script at `scripts/validate.sh`. Runs as 2nd step of pre-commit hook. Currently 10 checks (numbering, cross-references, state-counter sync, session lifecycle, MS chain, README↔state currency). 11th check (DONE sign-off) deferred per DEC-032.

**validator size budget** — per-MS line-count cap for `scripts/validate.sh`. Smell-check, not hard limit, per working agreement #10. Caps calibrated against existing per-check complexity; new checks that need new parsing primitives (block-aware scans, multi-file walks) routinely exceed per-check estimates by 2–3×. The 150-line guidance from MS-004 is retired (per DEC-026).

**Vitest** — JavaScript/TypeScript test runner used for unit + component tests in UnoAi (per DEC-013 / DEC-029). Unit tests live in `__tests__/` subdirectories next to the code under test. Distinguished from Playwright (e2e tests at `test/e2e/`).

## W

**working agreement** — see "Engineer working agreement."

**Worker** — Cloudflare Worker that handles UnoAi's server-side surface: Lemon Squeezy webhook reception, license token issuance via Ed25519. Conversations never touch the Worker; only payment events do.
