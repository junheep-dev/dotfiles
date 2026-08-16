---
name: verify-changes
description: Verify the current changes actually work before commit/PR — run checks and exercise the change for real. Use when asked to test or verify the current changes.
---

Verify that the current changes (working tree and/or branch commits vs their
base) actually work.

1. Determine the base. Default to `main`. If the branch is part of a stack —
   an open PR targeting a branch other than `main`, or a Linear sub-issue whose
   parent has its own branch — diff against that branch instead. Say which base
   you picked; ask if it's genuinely ambiguous.
2. Read the diff — not to explain it, but to know what needs verifying.
3. Sanity-check it: flag files that don't belong, leftover debug code, or
   missing pieces the change implies (env vars, migrations, config).
4. Run typecheck/lint and the tests relevant to the change.
5. Exercise the change for real, not just in theory: check if a dev server
   is already running before starting one; drive UI changes through the
   `agent-browser` skill; hit the actual endpoint/flow the change affects.
6. Report results: what was verified and how, what passed, and anything
   that failed or couldn't be verified (say so plainly — no hedging).
   Do not commit or push — the user decides.
