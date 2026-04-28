# Inspection log

Append-only. Numbered INSP-001 onwards.

This form holds independent-audit reports filed by the Inspector role. The Inspector is not the Engineer and not the Builder — a separate role that walks the project's security, privacy, and project-risk surfaces and files findings the next role can act on. Inspector files inspection reports only; it does not commit fixes for findings (Engineer drafts MSes; Builder executes; operator approves).

Inspector cadence (suggested, operator-set per inspection's "Recommended next inspection" field):

- Pre-Phase-1 readiness — INSP-001 (this entry).
- After Phase 1 first product code lands — INSP-002.
- After any major architectural change — ad-hoc INSP.
- Pre-Phase-8 (launch) — comprehensive INSP.
- Quarterly post-launch — recurring INSPs.

Each inspection reads prior inspections first to track whether prior findings were addressed.

---

## Template

```
## INSP-NNN — [scope summary]

**Date:** YYYY-MM-DD
**Inspector:** [agent name + role]
**Scope:** [security / privacy / project-risk / subset]
**Repo state:** [commit SHA at audit start, plus working-tree note if dirty]
**Files reviewed:** [list, or "comprehensive — all repo files"]
**Methodology:** [one paragraph — what was looked at, what was deliberately not]

### Summary

[2-3 paragraphs. Headline takeaways. Overall posture. Biggest risk. Most surprising finding.]

### Findings

#### CRITICAL findings
[Numbered. For each: title, evidence, severity justification, likelihood, recommendation.]

#### HIGH findings
[Same structure.]

#### MEDIUM findings
[Same structure.]

#### LOW findings
[Same structure.]

#### INFO observations
[Same structure but lighter — observation, no recommended fix necessarily.]

### Open questions for operator
[RFI-shaped items where Inspector lacks enough information to assess. Operator answers in chat; future inspections incorporate.]

### Recommended next inspection
[When the next INSP should run. Inspector recommends; operator decides cadence.]
```

---

## Entries

<!-- Append new entries below this line. -->

## INSP-001 — Pre-Phase-1 readiness audit (security + privacy + project-risk)

**Date:** 2026-04-28
**Inspector:** Claude (independent audit role)
**Scope:** Security + Privacy + Project-risk
**Repo state:** HEAD `586d6d0` (`MS-009: Section 0 (SIGN_OFF.md scaffolding) + Section 1 (spelling & grammar)`). Working tree dirty: two uncommitted Builder edits from MS-009 Section 2 in-progress work (`forms/SIGN_OFF.md` populated through Section 2 checklist + findings; `state/current.md` MS-chain status line updated). Inspector did not modify either; they remain pending in the working tree for Builder to fold into the MS-009 Section 2 close-out commit.

**Files reviewed:**

- All four root-level prose files: `CONTEXT.md`, `PROJECT.md`, `PROCEDURES.md`, `PLAN.md`, `GLOSSARY.md`, `README.md`, `CONTRIBUTING.md`, `LICENSE`.
- All seven form files in full: `forms/DECISION.md` (DEC-001..033), `forms/INCIDENT.md` (INC-001..006), `forms/RFI.md` (RFI-001..010), `forms/SIGN_OFF.md` (current MS-009 state), `forms/CHANGE_ORDER.md`, `forms/SITE_LOG.md` (head + tail; 636 lines total before Inspector sign-in).
- Tooling: `.githooks/pre-commit`, `scripts/validate.sh`, `.gitleaks.toml`, `.cspell.json`.
- Project state: `state/current.md` (counters + working agreements + MS chain).
- Configuration: `.env.example`, `.gitignore`, `package.json`, `wrangler.jsonc`, `svelte.config.js`, `eslint.config.js`, `vite.config.ts`, `tsconfig.json` (skim).
- Prompts: `prompts/engineer-session-start.md`, `prompts/engineer-prompt-checklist.md`.
- Source scaffolding: `src/app.html`, `src/routes/+layout.svelte`, `src/routes/+page.svelte`, `src/lib/index.ts`. Empty `.gitkeep` directories under `src/lib/` (auth, chat, crisis, persona, server, shared, storage). `src/routes/api/` empty.
- Test scaffolding: `test/e2e/.gitkeep`, `test/fixtures/.gitkeep` (no real fixtures yet — Phase 4/6 work).
- Static: `static/robots.txt`.
- Verification commands: `bash scripts/validate.sh` (returned `VALIDATOR: PASS`); `gitleaks detect --no-git --source .` (508 KB scanned, 0 leaks); `git log` author survey (two operator identities present); `git ls-files | grep -E "(\.vscode|\.env)"` (only `.env.example` tracked); various greps for `tyrien`, `secret`, `api.?key`, `password`, `token`, `private` across the in-scope files.

Files not reviewed in full: `forms/METHOD_STATEMENT.md` and `forms/DONE.md` (MS process records — read selectively for security-relevant content; not load-bearing for current-state assessment given `state/current.md` is the source of truth). External links in DEC entries (gitleaks repo, polyformproject, etc.) not fetched.

**Methodology:** Human-style review of code, configs, and documents from the perspective of "what's claimed vs what's implemented." No automated scanners beyond `gitleaks detect` (which the project already uses). No fuzzing, no penetration testing. Doctrine context loaded inline in chat per RFI-011 resolution option (a) — INSP-001 only. Findings are organised by severity per the role-prompt scale; a finding-free severity bracket means the inspection found nothing at that level, not that the inspection didn't probe at it.

### Summary

UnoAi's pre-Phase-1 posture is genuinely strong — unusually so for a $9 side product. The architecture is honest about what it can and cannot do (BYOK direct-to-Anthropic, no proxy, IndexedDB local persistence, asymmetric license signing); the procedural infrastructure (nine procedures, validator, hooks, working agreements) is doing real work and not theatre; and the secrets-discipline layer (gitleaks + `.gitleaks.toml` + `.env.example` placeholders + comprehensive `.gitignore`) is correctly designed and currently clean (working-tree gitleaks scan returned zero findings across 508 KB). The legal floor (PolyForm Noncommercial license, SB 243 alignment via persona constraints + crisis classifier + AI disclosure) is documented and traceable. Inspector has no CRITICAL findings.

The single most material gap is **HIGH-1: `CONTRIBUTING.md` line 25 says "Email [security contact TBD] instead" while telling researchers not to open public issues for security-sensitive bugs.** The repo is already public and discoverable. Anyone wanting to responsibly disclose a security issue right now has no channel. This is the only HIGH-severity item and is the cheapest to fix.

The MEDIUM cluster is dominated by **structural-control vs procedural-control mismatches** — the kind of gap LESSON-013 of the doctrine names directly ("sandboxing is a mechanism, not a policy"). The pre-commit hook chain is excellent when it fires, but its activation (`git config core.hooksPath .githooks`) is opt-in per clone, the hook script and validator script have no integrity protection (a `sed -i 's/.*/exit 0/' .githooks/pre-commit` would silently neutralise every check), and `git commit --no-verify` is procedurally banned but not technically blocked. None of these are likely to be exploited in solo-operator context, but each is a route an attacker (or a careless agent) could use to put unchecked content into a public repo. The doctrine path issue (the canonical doctrine reference in `GLOSSARY.md`/`PROCEDURES.md`/`prompts/engineer-session-start.md` resolves only in the Engineer's environment) is a related procedural gap that Inspector hit first-hand at session start (RFI-011 in chat) and that will hit every non-Engineer agent role in the same way.

The most surprising finding is small but worth naming: the operator has **two distinct personal email addresses in the public commit history** — operator's secondary @gmail.com address (the local git-config identity that authored every Builder commit from MS-001 through `586d6d0`) and operator's primary @gmail.com address (the GitHub auto-init commit `372902c` author metadata, attributed to GitHub user `tyrienjones-tech`). The `.gitleaks.toml` rule on line 58 protects the primary email by detection-after-the-fact (and only against the literal string in file content, not against commit author metadata) but does not protect the secondary email at all. This is consistent with DEC-025's spirit ("personal email when used for ops accounts" — the commit-author email is not an ops-account email) but expands the operator's discoverable identity surface in ways the project's own discipline tries to minimise elsewhere. Inspector deliberately does not quote either literal email value in this report — both are already public via commit author metadata, but propagating the values into a third file (this report) would be a redundant exposure and would itself trigger the operator-personal-email gitleaks rule. (Inspector confirmed this empirically: the first commit attempt of this report quoted the literal primary email in evidence sections; gitleaks blocked the commit per DEC-024 sequence; Inspector redacted to the descriptive paraphrase form used throughout. INC-007 queued for Builder filing per DEC-025 mandatory response sequence; see SITE_LOG sign-out for the full sequence record.)

### Findings

#### CRITICAL findings

None. The current posture does not contain any items that would lead directly to user-data, secret, or financial compromise if exploited at this stage.

#### HIGH findings

**HIGH-1 — `CONTRIBUTING.md` security disclosure address is `[security contact TBD]`.**

- **Evidence:** [CONTRIBUTING.md:25](CONTRIBUTING.md#L25) reads `Email [security contact TBD] instead.` The same file (line 23-25) tells researchers to not open public issues for security issues. The repo is public and indexed.
- **Severity justification:** any researcher who wants to follow responsible-disclosure norms right now has no channel. Their options are: (a) open a public issue (which the doc bans), (b) email an unknown address (no signal), or (c) drop the report. Option (c) is the most likely outcome and is also the worst. Pre-Phase-1 the production attack surface is small, but the repo itself is already publishable-vulnerability terrain (the secrets-discipline review surfaced two LOW issues an external researcher could find with a 30-second skim of `.gitleaks.toml`). Once Phase 1 ships, this gap becomes operator-blind to real production reports.
- **Likelihood:** probable. The repo is public; the doc page is direct and indexable.
- **Recommendation:** decide the disclosure address before any further public surface (Phase 1 + Phase 8 in particular). Options the operator likely already knows: a dedicated `security@unoai.[tld]` once domain lands (RFI-009 dependency), or a GitHub Security Advisories private-disclosure flow (the repo's "Security" tab → "Advisories" → "Report a vulnerability" route, which works even with Issues open and PRs closed). Suggested form: a small MS that fills the line and adds a `SECURITY.md` to repo root pointing at the same address. SECURITY.md is a `.well-known`-equivalent for security researchers — GitHub surfaces it in the repo's Security tab.

#### MEDIUM findings

**MEDIUM-1 — Pre-commit hook activation is opt-in per clone; no detection mechanism for "this commit was made without the hook firing."**

- **Evidence:** [.githooks/pre-commit:14](.githooks/pre-commit#L14) and [CONTRIBUTING.md:7-13](CONTRIBUTING.md#L7-L13) document the one-time `git config core.hooksPath .githooks` step. There is no mechanism that detects a commit pushed to `main` whose content would have failed any of the five hook steps. Server-side, GitHub secret-scanning catches a subset (per DEC-024 reference to "defence in depth"), but it doesn't catch validator failures (numbering gaps, lifecycle drift, README↔state drift), Prettier/ESLint failures, or cspell failures.
- **Severity justification:** LESSON-022 of the doctrine ("defaults must be secure — opt-in security is not security") names this exactly. Current threat model is solo-Builder, so the activation step is procedural and historically reliable. Risk profile expands the moment a fresh OS install / fresh clone happens without re-activation, or any future role gets commit access. Unlikely-to-trigger ≠ harmless-to-have.
- **Likelihood:** plausible. Not from malice, but from a clean-clone-after-laptop-reset moment that gets forgotten in the rush to commit.
- **Recommendation:** add a synthetic check that fires from the validator itself when `git config core.hooksPath` doesn't resolve to `.githooks`. The validator can shell out via `git config --get core.hooksPath` and FAIL with a clear setup message if the value is wrong. This puts hook-activation under the same hard-fail discipline as everything else the validator covers. Alternative (more invasive): a `npm run prepare` hook that auto-sets `core.hooksPath` on first install — but `prepare` already runs `playwright install` and `svelte-kit sync`, and adding repo-config side-effects to an npm script is itself a surprise. Validator self-check is cleaner. Suggested form: MS in the MS-010 cleanup band.

**MEDIUM-2 — No tamper-detection on `.githooks/pre-commit` or `scripts/validate.sh` themselves.**

- **Evidence:** Both files are committed to the repo. A modification (e.g., `set +e; exit 0` injected near the top of [.githooks/pre-commit:24](.githooks/pre-commit#L24) or [scripts/validate.sh:50](scripts/validate.sh#L50)) would silently neutralise the entire chain on subsequent commits. The hook runs from the working tree, not from `HEAD`, so a modified hook fires the moment it's edited — including the commit that introduces the modification. Per LESSON-013, the controls are mechanism without policy enforcement on the mechanism itself.
- **Severity justification:** the threat is "trusted insider modifies the controls and then the controls don't fire on the modification commit." Bug-or-malice-indistinguishable scenario. A careless edit to `validate.sh` that breaks check N is functionally identical to a deliberate edit. The synthetic-violation discipline (working agreement #8) is the operator's current defence — every check has a documented synthetic test in DONE entries — but those tests aren't automated, so a regression that disables check N would only surface when someone manually re-runs check-N's synthetic violation.
- **Likelihood:** plausible (careless edit) > unlikely (deliberate insider tampering for a solo-operator project).
- **Recommendation:** two options. (a) Cheaper: a separate `scripts/verify-hook-and-validator.sh` that the validator itself runs as check 11 (or a new check 12), comparing the SHA-256 of `.githooks/pre-commit` and `scripts/validate.sh` against pinned values stored in `state/current.md` or a dedicated file. The pinned values get updated as part of any MS that legitimately changes either script. Drift in either file without a corresponding pinned-value update fails the pre-commit hook. (b) More structural: a CI job (when GitHub Actions land) that re-runs the synthetic violations against every PR/push, so regressions surface server-side. Both have value; (a) protects the local commit path, (b) protects the hosted-repo trust story. Suggested form: a small MS that picks one (Engineer's call which).

**MEDIUM-3 — `git commit --no-verify` bypass is procedurally banned but not technically blocked or detectable post-hoc.**

- **Evidence:** [PROJECT.md:114](PROJECT.md#L114) ("Bypassing it via `git commit --no-verify` is itself a banned move except as part of an INCIDENT response..."), [.githooks/pre-commit:17-22](.githooks/pre-commit#L17-L22) (header documents the ban). No detection mechanism exists for "this commit was authored with `--no-verify`." Git itself doesn't record bypass-via-no-verify in commit metadata.
- **Severity justification:** same LESSON-013 pattern as MEDIUM-2. The ban is documented, surfaced in PROJECT.md banned-moves, and reinforced in the hook header. No tooling enforces it. Mitigation depends entirely on operator discipline and on Builder roles internalising the rule.
- **Likelihood:** unlikely in current solo-operator context, plausible under time pressure or in scenarios where the hook produces confusing output (false positive on a pattern not currently in `.gitleaks.toml`).
- **Recommendation:** server-side detection. A GitHub Action that re-runs `bash scripts/validate.sh` and `gitleaks detect` against every push to `main` would catch any commit that bypassed the local hook. This is the same MEDIUM-2 (b) recommendation — they collapse into a single CI-introduction MS at a future phase. Suggested form: MS that adds `.github/workflows/verify.yml` running validator + gitleaks + Prettier --check + ESLint + cspell on every push, ideally before Phase 1 first deploy so the trust story has both local-prevention AND remote-detection layers.

**MEDIUM-4 — No supply-chain monitoring on the 23 npm devDependencies.**

- **Evidence:** [package.json:22-50](package.json#L22-L50) lists 23 devDependencies. No `.github/workflows/` directory exists; no Dependabot config (`dependabot.yml`); no Renovate config; no `npm audit` in any committed script or CI. The doctrine's CASE-002 (LiteLLM supply-chain breach, March 2026) names this exact attack surface — third-party AI/dev tooling is part of the trusted computing base. The current devDependency tree includes `gitleaks` (binary, not npm — fine), `cspell` (npm, ^10.0.0), `eslint`/`prettier`/`vite`/`svelte-check`/`vitest`/`playwright` and their transitive dependencies.
- **Severity justification:** as long as no production runtime dependencies exist (Phase 1+ will add `@noble/curves` or `tweetnacl`, `idb` or raw IndexedDB, `@anthropic-ai/sdk`), the blast radius of a devDependency compromise is "developer machine + CI runner pipeline." Once production deps land, the blast radius extends to the user's browser. The right time to wire monitoring is now, before runtime deps arrive — so the discipline is in place when the stakes change.
- **Likelihood:** plausible at industry baseline rate (CASE-002 was a 40-minute window that pulled in thousands of victims).
- **Recommendation:** two layers. (a) Cheap-now: add `dependabot.yml` to the planned `.github/` directory with weekly devDependency scans + security alerts on critical CVEs. GitHub renders these as PRs the operator can review (and reject because PRs are closed per DEC-018, but the alerts surface in Issues which are open). (b) Phase 1 onwards: every new runtime dep gets `npm audit` run as part of the dep's introducing MS, with output captured in DONE entry per Procedure 3 proof discipline. Suggested form: small MS in the MS-010 cleanup band, ideally bundled with the SECURITY.md fix from HIGH-1.

**MEDIUM-5 — Doctrine reference path `/mnt/skills/user/eco-agentic-doctrine/SKILL.md` is operator-environment-specific but cited as canonical in repo files referenced by all agent roles.**

- **Evidence:** [GLOSSARY.md:49](GLOSSARY.md#L49) ("doctrine — operator's standing rules for agentic AI behaviour. Lives at `/mnt/skills/user/eco-agentic-doctrine/SKILL.md`."), [GLOSSARY.md:95](GLOSSARY.md#L95) (`LESSON-NNN` definition references the same path), [PROCEDURES.md:18](PROCEDURES.md#L18) ("Fresh Engineer sessions additionally start with `prompts/engineer-session-start.md` (the operator-pasted onboarding prompt that loads the agentic-doctrine context)."), [prompts/engineer-session-start.md:7](prompts/engineer-session-start.md#L7) (which acknowledges the env-specificity inline) and [prompts/engineer-session-start.md:19-21,44-46](prompts/engineer-session-start.md#L19-L21) (the actual paths). Inspector hit this first-hand at session start — RFI-011 in chat, resolved by operator pasting the doctrine inline (option a, INSP-001 only). Engineer's role-prompt to Inspector flagged this as MS-010+ candidate.
- **Severity justification:** the doctrine is named in `prompts/engineer-session-start.md:23-39` as load-bearing for the role's posture-guard ("you will exhibit the failure patterns" — sycophancy, pattern-matching, confidence-without-verification). Without the load, the guard is nominal. Engineer-role addendum in PROCEDURES.md:18 references the addendum-load step. Future Inspector / Builder / new-role sessions hit the same gap and have to either RFI through or proceed without the guard. Builder is presumably loaded via the operator's terminal where the path resolves; non-terminal roles (web-chat Engineer, Inspector) don't have access. The doctrine is also referenced in GLOSSARY.md:95 (`LESSON-NNN`) — anyone trying to look up a LESSON gets a path that resolves only sometimes. Inspector hit this first-hand at session start (RFI-011 in chat).
- **Likelihood:** probable for any non-Engineer-via-operator-terminal role.
- **Recommendation:** copy the doctrine into the repo as `docs/doctrine.md` (or `prompts/agentic-doctrine.md`), update the references in GLOSSARY.md / PROCEDURES.md / `prompts/engineer-session-start.md` to the in-repo path, and keep the `/mnt/skills/...` path documented as the upstream source-of-truth that gets synced into the repo at the operator's discretion. This converts a sometimes-resolvable reference into an always-resolvable one without breaking the Anthropic-environment workflow. Suggested form: small MS post-MS-009. Engineer's pre-existing MS-010+ note covers this.

#### LOW findings

**LOW-1 — `.gitleaks.toml` line 58 publishes the operator's primary @gmail.com address in the rule's regex (in escaped form).**

- **Evidence:** [.gitleaks.toml:58](.gitleaks.toml#L58) — the regex literal in that line is operator's primary @gmail.com address with the `.` escaped as `\.`. The escape prevents the rule from self-firing on the file content but does not prevent any reader from extracting the literal email by removing the backslash. A `git log` survey already shows this email in the auto-init commit's author metadata (commit `372902c`, author attribution to GitHub user `tyrienjones-tech` with the same address), so the email is already in public commit history regardless of this file. The .gitleaks.toml line is therefore a redundant disclosure, not an additive one. (Inspector deliberately does not quote the literal email value here; the locator points to the source of truth.)
- **Severity justification:** doesn't widen the disclosure footprint; does demonstrate an anti-pattern (the rule designed to prevent the secret leaking embeds the secret in detectable plaintext). The pattern matters more than the specific case — future expansions of `.gitleaks.toml` to cover additional sensitive strings should not embed those strings.
- **Likelihood:** the email is already exposed elsewhere; new exposure from this finding alone is not material. The pattern-risk for future rules is plausible.
- **Recommendation:** for future `.gitleaks.toml` additions of literal sensitive strings, prefer (a) hashing (gitleaks supports rule-specific entropy thresholds; for known fingerprints a hash-based detection or a partial-pattern that catches the literal without committing it), or (b) rule definition by-pattern-class rather than by-literal-value (e.g., "any commit author line not in `(noreply@github.com|some-allowlist)` triggers a warning" — this catches the same risk without naming the protected value). For the current rule on line 58, the value is already public via commit history; rotation isn't possible (the commit author email can't be retroactively changed without rewriting history, which is also banned per DEC-025 once content is public). Operator could either (i) accept the redundancy and leave the rule as-is, (ii) change the rule to use a partial pattern (`tyrien.*@gmail\.com` would catch both observed identities at the cost of false positives on prose mentions of "tyrien"), or (iii) drop the rule entirely on the basis that the email is already public and the rule provides no further protection. INFO-grade recommendation; operator's call.

**LOW-2 — Two distinct operator personal-email identities in commit history.**

- **Evidence:** `git log --all --format='%an <%ae>' | sort -u` returns two identities: operator's secondary @gmail.com address (the local git-config identity that authored every Builder commit from MS-001 through `586d6d0`) and operator's primary @gmail.com address (the GitHub UI auto-init commit `372902c`, attributed to GitHub user `tyrienjones-tech`; captured in INC-005). Inspector deliberately does not quote either literal address here — the `git log` command line above is the locator that resolves to the source of truth, and propagating the literal values into this report would be redundant exposure (and would also trigger the `.gitleaks.toml` operator-personal-email rule, as Inspector confirmed during the first commit attempt of this report — see Summary section + SITE_LOG sign-out for the full sequence). DEC-025 line 357 calls out personal-email exposure for ops accounts; the commit-author identity is not strictly an "ops account" but it is operator-identifying public metadata.
- **Severity justification:** widens the operator's identity surface across two emails. Not a confidentiality breach (both are linked to operator's public GitHub presence anyway — `tyrienjones-tech` is the GitHub username, the local-config identity shares the same username root).
- **Likelihood:** already exposed; future exposure depends on whether new commits continue to use the local-config identity vs a `noreply@users.noreply.github.com` style.
- **Recommendation:** if operator wants to consolidate going forward, set `git config user.email "[id]+tyrienjones-tech@users.noreply.github.com"` (GitHub's per-user noreply pattern) so future commits don't surface a personal email. The two existing identities in history would remain (rewriting history is destructive and banned per DEC-025 spirit). Optional cleanup; operator's call. Suggested form: not a separate MS — fold into the SECURITY.md / dependabot MS in the MS-010 cleanup band as a one-line `git config` step in the relevant DONE entry, if the operator wants it.

**LOW-3 — Validator check 10 (README ↔ state phase sync) passes despite stale `MS-005` / `MS-006 DONE` content in `README.md:85`.**

- **Evidence:** [README.md:85](README.md#L85) reads `Phase 0b complete. Infrastructure phase in progress (MS-005). Phase 1 begins after MS-006 DONE.` while `state/current.md:32` is `Current: Phase 0b complete. Infrastructure phase in progress (MS-009). Phase 1 blocked on MS-009 close.` Validator check 10 in [scripts/validate.sh:243-277](scripts/validate.sh#L243-L277) extracts the leading "Phase X status" identifier (`phase 0b complete`) from both files and compares case-insensitive substring. Both reduce to `phase 0b complete`, so the check passes despite the trailing `MS-005` / `MS-006 DONE` content being two MSes behind reality. Builder's MS-009 Section 2 in-progress findings (in working-tree `forms/SIGN_OFF.md`) flag this for Section 3 disposition.
- **Severity justification:** the validator's check 10 is doing its job per its specification; the gap is in the specification, not the implementation. README's `## Status` section deliberately captures more than just the phase identifier (it names the active MS and the next-phase trigger), but the validator only checks the prefix. Future check refinement could compare the full first-status-line, at the cost of more brittle line-format coupling. The drift between README's `MS-005` / `MS-006 DONE` content and state's `MS-009 in progress` is already on Engineer's radar via Section 3.
- **Likelihood:** the staleness is currently latent (real risk = "agent reads README to find current phase, gets two MSes-old picture, makes decisions on stale assumption"). Mitigated by the procedural discipline of reading `state/current.md` first per Procedure 1.
- **Recommendation:** Section 3 of MS-009 already targets this. No new recommendation from Inspector. Worth noting the validator's check-10 design choice (substring-prefix-match) was deliberate per the inline comment about "wording variation allowed" — tightening it would cost flexibility for marginal gain. INFO-grade observation rather than a fix recommendation.

**LOW-4 — No CI/CD configured (no `.github/workflows/`); all quality gates are local-only.**

- **Evidence:** `.github/` directory does not exist. The pre-commit hook chain is the only enforcement layer. Server-side, GitHub provides default secret-scanning for public repos (mentioned in DEC-024 as "defence in depth") but does not run validator / Prettier / ESLint / cspell.
- **Severity justification:** consistent with solo-operator posture. Becomes more material once the project enters Phase 1 (production code, real users) or if any operator-trust-boundary changes (additional contributors, automated build pipelines for hosting). Currently low-impact because the local discipline has been reliable.
- **Likelihood:** "skipped local hook" + "operator-only push" combine to keep the risk small now; expands at Phase 1 deploy.
- **Recommendation:** the same CI MS that addresses MEDIUM-2 / MEDIUM-3 / MEDIUM-4 covers this finding too. Single MS, multiple findings closed. Worth scheduling before Phase 1's first deploy so hosting credentials never sit alongside an unverified push surface.

**LOW-5 — `prepare` script in `package.json:10` runs `playwright install` on every `npm install`, downloading browser binaries from playwright.dev.**

- **Evidence:** [package.json:10](package.json#L10) (`"prepare": "playwright install && svelte-kit sync || echo ''"`). Playwright downloads Chromium / Firefox / WebKit binaries on first install. Downloads are over HTTPS from `playwright.dev` mirrors. No SHA pinning visible in this scaffold — Playwright manages browser versions internally based on the npm package version.
- **Severity justification:** standard Playwright behaviour. Not a per-commit risk; a per-`npm install` risk. Same supply-chain category as MEDIUM-4.
- **Likelihood:** rare event (only on fresh installs); Playwright themselves are a high-trust upstream.
- **Recommendation:** noted for completeness. If MEDIUM-4's CI MS lands, the CI runner will ALSO `npm install` and download browsers — the same trust assumption applies there. No separate fix recommended. INFO-leaning LOW.

#### INFO observations

**INFO-1 — Project posture is unusually well-instrumented for its stage.** Nine procedures + form-backed enforcement + 16 working agreements + 33 DECs + 6 INCs + a 289-line tested validator at MS-009 of a side-revenue product is more discipline than many funded startups carry to launch. The doctrine's CASE-010 (Claude Code silent degradation) and LESSON-019 (observability is non-optional) are reinforced by the procedural infrastructure: every session is signed in / out, every decision has a DEC, every break has an INC, every change has an MS-with-DONE-with-proof. This is the right posture; Inspector is calling it out because the absence of CRITICAL/HIGH findings is in part because of it, not in spite of it.

**INFO-2 — Validator synthetic-violation discipline (working agreement #8) is operating as designed.** Every check that ships gets a documented synthetic-violation test attached to its DONE entry. This catches the failure mode where validator code says it checks X but actually doesn't. The discipline is documented, not automated — there is no test runner that re-executes the synthetic violations on demand (which would convert the check into a pinned-test). For solo-operator workflow this is acceptable; if scope grows, a `scripts/verify-validator.sh` that re-runs all documented synthetics would convert documentation into mechanism.

**INFO-3 — The privacy claim ("conversations stay on your device") is a forward-looking architectural commitment rather than a currently-implemented behaviour.** No Phase 2-7 product code exists yet. The architecture decisions that support the claim — DEC-002 (BYOK direct, no proxy), DEC-008 (crisis classifier on user's own key), DEC-010 (`anthropic-dangerous-direct-browser-access` header), DEC-030 (no remote logging from client), the "no operator key in browser bundle" implication of DEC-007 — are all logged. Implementation verification is INSP-002 (post-Phase 1) and INSP-(later) (post-Phase 6) territory.

**INFO-4 — Crisis classifier (DEC-008 + DEC-020) ships on the user's own Anthropic API key.** This is the correct architectural answer per the doctrine's local-sovereignty principle (LESSON-023) and per the project's own banned-moves rule (no proxy). The fail-closed policy in DEC-008 ("if the moderation call fails, the chat call does not proceed") is the right posture for SB 243 §22602. Phase 6 implementation needs to verify this fail-closes correctly under realistic failure modes (rate-limited user keys, network drops mid-conversation, malformed responses from the moderation call) — INSP-(post-Phase-6) target.

**INFO-5 — The GitHub auto-init commit (`372902c`) at the base of `main` is documented in INC-005 with operator-decision-deferred-to-B8 framing; resolved at MS-003 close-out as option (b) "layer on top, accept the 31-byte fossil."** No action needed; just confirming the finding was caught and resolved through the procedural surface working as intended.

**INFO-6 — License-token economics: Ed25519 prevents forgery but does not prevent sharing.** A licensed user can copy their token and distribute it to N other users; each instance verifies offline against the public key (per DEC-007). At $9 per token this is the deliberately-low-friction posture; no per-user-binding mechanism exists or is planned in Phase 1. If post-launch metrics show meaningful sharing eroding revenue, future work could add (a) device fingerprinting at first-launch, (b) email verification at chat-key-entry time, or (c) stateless rate limiting via a separate Worker call that doesn't violate the privacy claim. Not a finding because the design is intentional; observation worth surfacing for future revenue analysis.

### Open questions for operator

1. **Two operator email identities in commit history (LOW-2):** is the local git-config secondary @gmail.com identity intentional going forward, or worth correcting alongside any noreply-email rotation? Inspector did not modify any git config.
2. **Lemon Squeezy webhook signing-secret regex (`.gitleaks.toml:34` + `.gitleaks.toml:74`):** the regexes assume secrets ≥20 chars in the env-var form and ≥40 chars after the `ls_(api|store)_` prefix in the literal form. Have these been verified against an actual Lemon Squeezy live key, or are the lengths placeholder-estimates from documentation? This is a Phase 1 readiness item — worth confirming before MS-N adds the webhook handler.
3. **License-sharing posture (INFO-6):** is the no-binding $9 model the deliberate v1 answer (and any anti-sharing work goes to v1.x metrics-driven), or is per-user binding planned for Phase 1? Documentation doesn't explicitly address it; finding a forward-looking DEC or a CO-NNN entry would help future inspectors verify the choice was intentional rather than defaulted.
4. **Doctrine in-repo placement (MEDIUM-5):** Engineer's pre-existing note ("MS-010+ candidate") covers the structural fix. Operator hasn't decided yet between (a) operator-paste-each-time and (b) commit doctrine to repo. INSP-001 was done via (a). Suggested operator decision before INSP-002 runs.

### Recommended next inspection

**Next inspection: INSP-002 — post-Phase-1 product-code review.** Engineer's lean (per role prompt) was the same. Inspector concurs.

Specific scope for INSP-002:

- The Ed25519 license-issuance flow end-to-end (Worker code, key-storage practice, public-key embedding in client bundle, offline verification implementation, regenerated-key migration story).
- The Lemon Squeezy webhook handler (signature verification, replay-protection, fail-closed on signature mismatch, no PII in Worker logs per DEC-030).
- The 5-step pre-commit hook chain re-tested against any Phase 1 code that introduces secret-shaped strings (Ed25519 public keys in client code should NOT trigger gitleaks; private keys MUST trigger it — synthetic violation against an actual Phase-1-shaped private key worth running before Phase 1 close).
- The first runtime npm dependency that lands in Phase 1 (likely `@noble/curves` or `tweetnacl` per DEC-007 / DEC-031) — license, maintenance status, supply-chain provenance, bundle-size impact verified.
- HIGH-1 (security contact) confirmed addressed.
- MEDIUM-1 / MEDIUM-2 / MEDIUM-3 / MEDIUM-4 / MEDIUM-5 status.

Cadence beyond INSP-002:

- **INSP-003 — post-Phase 6 (crisis classifier + provider abstraction).** Direct test of fail-closed behaviour, fixture-set FN/FP rates against real classifier output, deterministic-prompt content review, no-chat-call-on-trigger network-tab verification (per Phase 6 acceptance).
- **INSP-pre-launch — pre-Phase-8 comprehensive audit.** All findings from prior INSPs verified addressed or accepted-as-risk; ToS body verified to contain SB 243 §22602 disclosures + URL links to `/safety` and `/privacy`; footer line verified on every page.
- **INSP-quarterly post-launch.** Standard cadence for a public product.

Inspector did not file any RFI in `forms/RFI.md` this session — the doctrine question was resolved inline (RFI-011 in chat, option a), and the Open Questions above are for operator-direction-not-blocking-Inspector. RFI-011 is documented in this session's SITE_LOG sign-in entry but does not appear in `forms/RFI.md` because its scope was Inspector-environment-only, not project-state.

**Procedural note on cross-role state/current.md overlap:** at session start the working tree had two uncommitted Builder edits from MS-009 Section 2 in-progress work — `forms/SIGN_OFF.md` (Section 2 checklist + findings; outside Inspector write scope; not modified by Inspector) and `state/current.md` (one-line MS-chain-status update reflecting Sections 0+1 sign-offs; in the MS-chain section, outside Inspector's authorised write area within `state/current.md`). Inspector wrote its own additive edits to `state/current.md` (the `Latest INSP: INSP-001` counter line and a new dated paragraph at the top of `Last verified working state`) without disturbing Builder's pending line. Inspector originally proposed committing only `forms/INSPECTION.md` + `forms/SITE_LOG.md` and leaving `state/current.md` for Builder to fold into MS-009 Section 2 close-out, on the basis that selective hunk-staging via `git add -p` is interactive and forbidden by Inspector posture and `git stash` is destructive. **Operator overrode that proposal at commit time** and directed Inspector to commit `state/current.md` (combined Inspector + Builder edits) under the Inspector commit. Builder's MS-009 Section 2 close-out commit will therefore not include `state/current.md`. Engineer should note this cross-role overlap pattern (Builder mid-flight working-tree state intersecting Inspector cadence) for any future Inspector-role-prompt revision, or as a working-agreement-#17 candidate that names the pattern and its current resolution rule (operator-decision-at-commit-time).

---

## INSP-002 — External review consolidation (security + supply chain + architecture + procedural drift)

**Date:** 2026-04-28
**Inspector:** Independent external reviewer (audit conducted 
  against public repo HEAD 16a70c9)
**Filed by:** Builder (Reaper) on Engineer's instruction, 
  consolidating the external review's findings with 
  Engineer's verification and additional catches
**Scope:** Security + privacy + supply chain + architecture + 
  procedural drift
**Repo state:** commit 16a70c9 on main (MS-009 Section 3 
  work landed; chat sign-off applied at this session sign-in)
**Files reviewed:** comprehensive — entire repo cloned and 
  walked by external reviewer; verified by Engineer via 
  direct file fetch (per refined working agreement #14, 
  after the failure mode documented in INC-008)
**Methodology:** independent external audit; verified 
  against ground truth by Engineer; consolidated with 
  INSP-001 findings; cross-checked by operator via local 
  clone before filing. Full action plan in 
  /mnt/user-data/outputs/UnoAi_External_Review_Action_Plan_v1_1.pdf 
  (Engineer-produced, operator-reviewed, v1.1 corrected 
  per INC-008).

### Summary

Posture is sound but has actionable gaps. Zero CRITICAL 
findings. INSP-001's HIGH-1 (security contact missing) 
remains the only HIGH. The most important MEDIUM addition 
is Content Security Policy design for Phase 2 — without it, 
any XSS in the chat UI compromises the user's Anthropic API 
key, which is load-bearing for the BYOK privacy claim.

Several procedural gaps are embarrassing-but-real: CO-001 
numbering gap (validator's check_sequential covers 
DEC/RFI/INC/MS but not CO/DONE/INSP/SIGN_OFF; CO-002 exists 
without CO-001), cspell dictionary noise (asdfqwerty 
synthetic-test value remains in dictionary; multiple 
tokenization or bulk-add artifacts; judgement AND judgment 
both present despite en-GB lang setting).

Cloudflare's Pages-to-Workers consolidation is verified real 
(no formal deprecation but new features Workers-only; 
Workers Sites already deprecated in Wrangler v4) and 
warrants a migration decision before Phase 1 deploy. Filed 
as RFI-013.

License token revocation, webhook replay protection, webhook 
idempotency, and email delivery mechanism need explicit DECs 
before Phase 1 implementation. Email delivery filed as 
RFI-014.

### Findings

#### CRITICAL findings
None.

#### HIGH findings
None new beyond INSP-001's HIGH-1 (CONTRIBUTING.md security 
contact [TBD], unresolved).

#### MEDIUM findings

**MEDIUM-1**: No Content Security Policy or security headers. 
src/app.html is bare SvelteKit scaffold; no _headers file in 
static/. BYOK direct + browser-resident Anthropic API key + 
assistant-rendered output = XSS-to-key-exfiltration path. 
CSP is load-bearing for Phase 2. Recommendation: design CSP 
in MS-010; implement in Phase 2.

**MEDIUM-2**: No _headers file (Cloudflare Pages security 
headers). HSTS, X-Frame-Options DENY, X-Content-Type-Options 
nosniff, Referrer-Policy strict-origin-when-cross-origin 
all currently inheriting Cloudflare defaults rather than 
explicit project decisions. Recommendation: drop _headers 
in static/ during MS-010 or Phase 1 deploy.

**MEDIUM-3**: No webhook replay protection design. Lemon 
Squeezy sends signature without timestamp by default; 
Worker needs timestamp window check + nonce store for 
replay prevention. Recommendation: design DEC at MS-010; 
implement Phase 1.

**MEDIUM-4**: No webhook idempotency design. LS retries on 
transient failures; without idempotency, retried call = two 
license tokens issued. Recommendation: order-id 
deduplication layer (Worker KV or D1); design at MS-010, 
implement Phase 1.

**MEDIUM-5**: No lockfile integrity layer. No npm ci 
enforcement in pre-commit, no lockfile hash pinning. 
Recommendation: CI workflow enforces npm ci (covered by 
INSP-001 MEDIUM-3 work).

**MEDIUM-6**: CI absence is more significant than INSP-001 
treated. Pre-commit hooks run locally only; CI is the only 
place tests will actually run reproducibly. Without CI, you 
can't prove a commit was clean at the time it was pushed. 
Recommendation: MS-010 CI workflow scope expands beyond 
bypass detection to reproducible verification of every push.

**MEDIUM-7**: Banned moves divergence (RFI-012 territory). 
state/current.md banned moves labelled "(mirror of 
PROJECT.md)" but PROJECT.md has different items. 
"Co-Authored-By Claude footers" rule exists in 
state/current.md but not PROJECT.md. Recommendation: 
PROJECT.md becomes canonical; state/current.md mirrors 
verbatim; add Co-Authored-By rule as PROJECT.md 10th item. 
Filed as RFI-012; resolution at MS-010.

**MEDIUM-8**: Validator chain check forward-only. Goes 
MS → DONE direction only; a DONE entry referencing a 
non-existent MS would pass undetected. Combined with the 
CO/DONE/INSP/SIGN_OFF gap, the chain check has two 
distinct holes. Recommendation: validator hardening at 
MS-010.

#### LOW findings

**LOW-1**: CO-001 numbering gap. Validator's 
check_sequential covers DEC/RFI/INC/MS but not 
CO/DONE/INSP/SIGN_OFF. CO-002 exists in CHANGE_ORDER.md 
without CO-001. Recommendation: extend validator 
check_sequential to cover CO/DONE/INSP/SIGN_OFF, OR 
backfill retroactive CO-001 entry.

**LOW-2**: cspell dictionary noise. Dictionary contains 
asdfqwerty (synthetic-test value, dangerous if it appears 
in real commits), hase, rocedure, kickoff, roundtrip, 
oneline, vulns (tokenization or bulk-add artifacts), 
metallel, judgement AND judgment (en-GB inconsistency). 
Recommendation: audit dictionary at MS-010; remove 
asdfqwerty, retain documented tokenization artifacts (hase 
and rocedure are POSIX-character-class artifacts already 
documented in SIGN_OFF.md), resolve judgement vs judgment 
per en-GB.

**LOW-3**: prepare script silently swallows failures. 
"prepare": "playwright install && svelte-kit sync || 
echo ''" in package.json. Trade-off has legitimate reason 
(CI-without-Chromium environments) but is genuinely the 
wrong fail-mode for a prepare script. Real concern, lower 
severity. Recommendation: MS-010 may add a wrapper that 
distinguishes "playwright install failed (warn)" from 
"svelte-kit sync failed (error)".

**LOW-4**: engine-strict no-op. .npmrc has 
engine-strict=true but package.json lacks "engines" field. 
Strict-mode flag has nothing to enforce against. Trivial 
fix. Recommendation: MS-010 — add 
"engines": {"node": ">=22.0.0"}.

**LOW-5**: DEC-013 Tailwind v4 sign-off line missing. 
Operator chat-approved Tailwind v4 acceptance during 
MS-006 Decision 2 but DEC-013 body lacks explicit 
"Operator sign-off:" line. Decision is correct; 
documentation trail incomplete. Recommendation: MS-010 
small doc fix.

#### INFO observations

**INFO-1**: License token has no revocation mechanism. 
Verified per DEC-007 — Ed25519 signing, no expiry, no 
revocation, no per-user binding. INSP-001 INFO-6 noted; 
external review extends with sharing economics. 
Recommendation: explicit DEC at MS-010 — v1 accepts no-
revocation as trade-off, v1.x revocation mechanism filed 
as future work.

**INFO-2**: License sharing economics. $9 + no revocation 
+ no expiry + no per-user binding = sharing economically 
rational. Real but business model concern, not security. 
Recommendation: explicit DEC at MS-010 — v1 accepts trade-
off, monitor in production, address only if observed.

**INFO-3**: DEC-032 magic-string mechanism has no audit 
trail integrity. A magic-string is just text; anyone with 
write access could backdate "DONE-006 signed off by 
operator on 2026-04-25" to bypass real review. 
Recommendation: document as accepted v1 trade-off; revisit 
at v2 if scope expands beyond solo operator.

**INFO-4**: Reaper's MEMORY.md is private to the agent. 
Engineer working agreements (state/current.md) are public; 
Reaper-private memory is asymmetric. LESSON-019 
(observability) and LESSON-020 (operator-control-of-both) 
territory. Recommendation: surface for design discussion 
at MS-011 working agreements consolidation.

#### Engineer-additional findings beyond external review

**MEDIUM-7** above (banned moves) was Engineer-additional.
**MEDIUM-6** above (CI as reproducible verifier framing) 
was Engineer-additional.
**LOW-5** above (DEC-013 sign-off line) was Engineer-
additional.
**INFO-3** and **INFO-4** above were Engineer-additional.

### Open questions for operator

1. RFI-013: Cloudflare Pages → Workers migration timing. 
   Stay on Pages for v1 or migrate before v1 deploy? 
   Engineer's lean: migrate before v1 deploy.
2. RFI-014: Email delivery mechanism for license tokens. 
   Lemon Squeezy confirmation email or separate service 
   (Resend/Postmark)? Engineer has no lean.

### Recommended next inspection

INSP-003 after MS-010 closes, to verify MS-010 actioned 
both INSP-001 and INSP-002 findings. Then routine cadence 
per INSP-001's recommendation (post-Phase-1, ad-hoc on 
architectural changes, pre-launch comprehensive, quarterly 
post-launch).

### Cross-references

- INSP-001 (independent audit, c655dab) — supplemented, 
  not superseded, by INSP-002
- INC-008 (Engineer verification miss in v1.0 of action 
  plan PDF) — filed alongside this entry
- RFI-012 (banned moves divergence, open) — resolution 
  routed to MS-010 per MEDIUM-7
- RFI-013 (Cloudflare migration timing) — filed alongside 
  this entry
- RFI-014 (email delivery mechanism) — filed alongside 
  this entry
- Action plan PDF: 
  /mnt/user-data/outputs/UnoAi_External_Review_Action_Plan_v1_1.pdf 
  (v1.1, corrected per INC-008)
