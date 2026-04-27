# UnoAi — Project induction

**Read this first. Always. Every session.**

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
