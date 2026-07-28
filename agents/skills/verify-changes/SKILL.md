---
name: verify-changes
description: Verify the current changes actually work before commit/PR — run checks and exercise the change for real. Use when asked to test or verify the current changes.
---

Verify that the current changes (working tree and/or branch commits vs its
base — main, or the umbrella branch for sub-issue branches) actually work.

1. Read the diff — not to explain it, but to know what needs verifying.
2. Sanity-check it: flag files that don't belong, leftover debug code, or
   missing pieces the change implies (env vars, migrations, config).
3. Run typecheck/lint and the tests relevant to the change.
4. Exercise the change for real, not just in theory: check if a dev server
   is already running before starting one; use browser tooling for UI
   changes; hit the actual endpoint/flow the change affects.
5. Report results: what was verified and how, what passed, and anything
   that failed or couldn't be verified (say so plainly — no hedging).
   Do not commit or push — the user decides.
