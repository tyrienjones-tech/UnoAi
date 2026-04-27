# Contributing to UnoAi

Thanks for your interest in UnoAi.

## Repo setup (one-time per clone)

To activate the secrets-scan pre-commit hook (per DEC-024 / Procedure 8), run once after cloning:

```sh
git config core.hooksPath .githooks
```

Install `gitleaks` so it's on `PATH`. See https://github.com/gitleaks/gitleaks for binaries. The hook fails closed if `gitleaks` is missing or `.gitleaks.toml` is absent — that's intentional.

## Bug reports

Bug reports are welcome via the GitHub Issues tab. Please include reproduction steps and your environment details.

## Code contributions

Code contributions are not accepted at this time. This is a solo-maintained project. If you'd like to fork the repo for your own use, the PolyForm Noncommercial license permits personal self-hosting — see LICENSE for terms.

## Security issues

For security-sensitive issues, please do not open a public issue. Email [security contact TBD] instead.
