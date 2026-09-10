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

Say what the branch does, and add a decision only when a reviewer reading the
diff would otherwise get it wrong — an unexpected choice, a constraint that
isn't visible in the code, a sequencing dependency. Not a record of what you
considered. If the diff already answers it, leave it out.

Don't invent a rationale for a change you weren't part of. For those, describe
what it does and leave it at that.

Title: same style as a commit subject — imperative mood, capitalized, no
trailing period. It names the branch's change as a whole, not its last commit.

Body: one or two sentences saying what the branch does, then bullets only for
the decisions that survived that filter, one sentence each. Often there are
none, and the body is just the summary — a PR body with no bullets is a good
one, not a lazy one. Never pad the list to have something in it.

When the branch does two or more separable things, give each its own sentence
or short paragraph in the summary instead of compressing them into one.

Reasoning about the code itself belongs in a code comment; scope and
alternatives belong in the Linear issue. The PR body is not where either gets
archived.

No section headers, no minor details, no test plan or checklist unless the
user asks for one.

Never link the Linear issue. The branch name already carries the issue
identifier, which is what links the two and closes the issue on merge.

When the diff touches the UI, judge whether screenshots would help the
reviewer. If so, capture them by running the app when that is possible;
when it isn't, create the PR without them and note that screenshots can
be added later. Don't block PR creation waiting on screenshots.

Attach images with the `gh image` extension when it is installed.

Report the PR URL. Do not merge it, and do not set the Linear issue to Done.
