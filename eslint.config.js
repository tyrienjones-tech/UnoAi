import prettier from 'eslint-config-prettier';
import path from 'node:path';
import { includeIgnoreFile } from '@eslint/compat';
import js from '@eslint/js';
import svelte from 'eslint-plugin-svelte';
import { defineConfig } from 'eslint/config';
import globals from 'globals';
import ts from 'typescript-eslint';
import svelteConfig from './svelte.config.js';

const gitignorePath = path.resolve(import.meta.dirname, '.gitignore');

export default defineConfig(
	includeIgnoreFile(gitignorePath),
	js.configs.recommended,
	ts.configs.recommended,
	svelte.configs.recommended,
	prettier,
	svelte.configs.prettier,
	{
		languageOptions: { globals: { ...globals.browser, ...globals.node } },
		rules: {
			// typescript-eslint strongly recommend that you do not use the no-undef lint rule on TypeScript projects.
			// see: https://typescript-eslint.io/troubleshooting/faqs/eslint/#i-get-errors-from-the-no-undef-rule-about-global-variables-not-being-defined-even-though-there-are-no-typescript-errors
			'no-undef': 'off'
		}
	},
	{
		files: ['**/*.svelte', '**/*.svelte.ts', '**/*.svelte.js'],
		languageOptions: {
			parserOptions: {
				projectService: true,
				extraFileExtensions: ['.svelte'],
				parser: ts.parser,
				svelteConfig
			}
		}
	},
	{
		// Naming-convention rule (per DEC-027 + MS-006 Scope B/F).
		// Enforces identifier naming inside files. Filename naming stays at
		// review-level discipline because framework conventions (+page.svelte,
		// +layout.svelte, +server.ts) take precedence over project conventions
		// for filenames.
		//
		// Carve-outs:
		// - `$`-prefix variables (Svelte 5 runes: $state, $derived, $props,
		//   $bindable, $effect) — leading underscore filter doesn't catch this;
		//   we use a custom filter to allow $-prefixed names.
		// - Module-scope `const FOO = ...` — allowed as UPPER_CASE for project
		//   constants per Scope B.
		// - SvelteKit framework exports (load, prerender, ssr, csr, actions,
		//   handle, handleError, etc.) — these are framework-dictated and stay
		//   exempt from camelCase enforcement; they happen to already be
		//   camelCase, so no rule action needed unless they trip the rule.
		rules: {
			// 'error' severity (not 'warn') — pre-commit hook blocks on rule
			// violations only if eslint exits non-zero, which requires errors.
			'@typescript-eslint/naming-convention': [
				'error',
				// Default: variables/functions/parameters camelCase.
				{
					selector: 'variableLike',
					format: ['camelCase'],
					leadingUnderscore: 'allow',
					filter: { regex: '^\\$', match: false }
				},
				// Module-scope const: allow UPPER_CASE for project constants.
				{
					selector: 'variable',
					modifiers: ['const', 'global'],
					format: ['camelCase', 'UPPER_CASE', 'PascalCase']
				},
				// Types and interfaces PascalCase.
				{
					selector: 'typeLike',
					format: ['PascalCase']
				}
			]
		}
	}
);
