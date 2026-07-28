---
name: resolve-pr-comments
description: Fetch unresolved review comments on the current branch's PR and address each one. Use when told that review comments were left on the PR.
---

Address the review comments on the current branch's open PR.

1. Fetch unresolved review comments and threads via `gh` (include the code
   context each comment is anchored to).
2. For each comment, either make the fix, or — if you believe the current
   code is right — explain why instead of changing it. Never change more
   than the comment asks for.
3. Commit following the commit style in CLAUDE.md and push. Group related
   fixes into one commit; don't make one commit per comment mechanically.
4. Reply to each comment/thread on GitHub with what was done (or the
   reasoning for no change), and resolve threads that are settled.
5. Report a summary: each comment → action taken. If any comment was
   ambiguous, say how you interpreted it.
