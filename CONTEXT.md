# UnoAi — Project Context

This file is for agents (AI or human) joining the project mid-build. It explains what UnoAi is, what makes it different from other AI products, and what conceptual constraints the build operates under.

For procedure: read [`PROCEDURES.md`](./PROCEDURES.md).
For phased build plan: read [`PLAN.md`](./PLAN.md).
For decisions and incidents: read [`forms/`](./forms/).
For current state and counters: read [`state/current.md`](./state/current.md).
For session-start onboarding: read [`prompts/engineer-session-start.md`](./prompts/engineer-session-start.md).
For terminology: read [`GLOSSARY.md`](./GLOSSARY.md).

## What UnoAi is

A browser-based AI companion app. One-time $9 purchase. Bring-your-own-key (BYOK) to Anthropic. Conversations stay on the user's device — no telemetry, no central database, no account except a license key. Public-source so users can audit the privacy claim themselves.

The pitch in one line: *"the one you own."*

## What UnoAi is not

It is not:

- An engagement-optimized companion (the persona is explicitly designed to push back, not flatter).
- A subscription product (one-time purchase, BYOK for usage).
- A surveillance product (no telemetry, no centralized conversation storage).
- A romantic partner simulator (banned moves: no permanence promises, no love claims, no substitute-for-humans framing).
- A wellness app (no mood tracking, no daily check-ins, no habit-formation hooks).
- A self-help substitute (crisis classifier hands off to hotlines; bot does not pretend to be therapy).

## Why these constraints exist

The companion-AI category has documented failure modes (Garcia v. Character.AI, A.F. v. Character.AI, Raine v. OpenAI). The legal and ethical floor is set by California SB 243 and the underlying liability theory: the immersion itself is the harm vector when users form dependency on a bot. UnoAi's persona is designed to hold the line that prevents that failure mode.

## What makes the architecture different

- Browser → `api.anthropic.com` direct (no proxy holding user conversations).
- IndexedDB local persistence (conversations never leave the user's device).
- Cloudflare Pages hosting (static + Worker for license issuance only).
- Ed25519 license tokens (asymmetric — Worker signs, client verifies, no shared secret to leak).
- PolyForm Noncommercial license (source-available for audit, commercial fork forbidden).

## Who's building this

Operator: solo founder. UnoAi is a side revenue product funding their flagship project (ECO).
Engineer: Claude (this conversation).
Builder: Reaper (Claude Code in operator's terminal).

The build is documented in real-time across the [`forms/`](./forms/) directory. Every decision has a DEC. Every blocker has an RFI. Every break has an INCIDENT. Every session has a SITE_LOG entry. The procedural overhead is deliberate — it's what makes solo + AI development survivable across stateless sessions.
