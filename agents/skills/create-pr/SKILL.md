---
name: create-pr
description: Open a pull request for the current branch, and decide what goes in its title and body. Use whenever asked to open, create, or raise a PR.
allowed-tools: Bash(gh *) Bash(git *)
---

Open a pull request for the current branch with `gh pr create`, targeting the
branch this one was cut from — `main` unless it is stacked on another branch.
Push first if the branch has no upstream.

Take the scope from the full diff against the base branch — the PR covers the
whole branch, including commits made before this session or by someone else.
Take the reasoning from this session: why this approach, what was ruled out,
which trade-off the reviewer would otherwise have to reconstruct from the diff.

Don't invent a rationale for a change you weren't part of. For those, describe
what it does and leave it at that.

Title: same style as a commit subject — imperative mood, capitalized, no
trailing period. It names the branch's change as a whole, not its last commit.

Body: a 1–2 sentence summary, then bullets for the important changes only. No
section headers, no minor details, no test plan or checklist unless the user
asks for one.

Never link the Linear issue. The branch name already carries the issue
identifier, which is what links the two and closes the issue on merge.

Attach images with the `gh image` extension when it is installed.

Report the PR URL. Do not merge it, and do not set the Linear issue to Done.
