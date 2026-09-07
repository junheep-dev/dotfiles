---
name: incremental-code-review
description: Implement changes in small, meaningful review batches, explain and verify each batch, and stage only user-approved changes. Use when the user requests step-by-step implementation with approval before continuing. Not for ordinary read-only code review.
---

# Incremental Code Review

Implement one reviewable batch at a time. Do not finish the whole change and
merely explain it in pieces.

## Prepare

Inspect existing changes and approvals. Preserve unrelated user work.
If restarting review of completed work, back it up and obtain authorization for
any necessary reset, then reapply one batch at a time.

## Choose and implement a batch

- Group changes by one purpose and the reasoning needed to review them, not by
  file, operation type, or a broad label such as "cleanup".
- Group changes that need each other's context to be reviewed, including cleanup
  made necessary by the change. Separate work that requires independent judgment.
- Target roughly 200 changed lines, counting additions and deletions. Smaller
  batches are welcome. Go larger only when review remains straightforward,
  such as repetitive changes serving one purpose, and explain why.
- Prefer intermediate states that work, but do not force them at the expense of
  meaningful review boundaries. If a batch leaves the implementation incomplete,
  explain what does not yet work and how the following batch will complete it.
- Apply only the current batch, leave it unstaged, and run appropriate focused
  checks. Keep previously approved changes staged.

## Explain and wait

Scale the explanation to the review effort. For simple changes, a brief
explanation is enough. For more involved changes, lead with the intent, then
walk through the relevant code changes with file and line references. Include
short code snippets when they help, with annotations or explanatory comments
in the displayed snippets if useful; this does not call for adding comments to
the source code. Do not mechanically narrate every line or repeat the full diff.

Identify the affected files and added/deleted line count relative to the staged
state. Explain why the changes belong together and how important existing
behavior is preserved, grounded in the actual code. Report validation performed
and its limits.

Ask for approval and stop. Questions are discussion, not approval. If the user
requests an amendment, change the current batch, verify it, and present it again.
Do not apply the next batch before approval.

## Stage and continue

After approval, stage the current batch, verify the index, and proceed to the
next batch. Do not include unrelated user work.

After the final approval, stage that batch and check for remaining unreviewed
task changes. When re-reviewing previously completed work, compare the final
staged file contents, including additions, deletions, and binary files, against
the original saved result. Report whether they match exactly; explain any
intentional differences approved during review and investigate unexpected ones.
Summarize the result and validation. Approval of a batch authorizes staging;
committing, pushing, and other external actions require separate authorization.
