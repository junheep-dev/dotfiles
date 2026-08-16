---
name: resolve-pr-comments
description: Fetch unresolved review comments on the current branch's PR and address each one. Use when told that review comments were left on the PR.
allowed-tools: Bash(gh *)
---

Address the review comments on the current branch's open PR.

1. Fetch the review threads. Only GraphQL carries resolution state — REST review
   comments have no resolved flag — so query `reviewThreads` on the pull request
   for `isResolved` and each comment's `diffHunk`. Work on the threads where
   `isResolved` is false; `diffHunk` is the code the thread is anchored to.
2. For each thread, either make the fix, or — if you believe the current code is
   right — explain why instead of changing it. Never change more than the
   comment asks for.
3. Commit following the commit style in the global instructions and push.
   Group related fixes into one commit; don't make one commit per comment
   mechanically. Push before replying, so each reply refers to code that is
   already on the PR.
4. Reply to every thread with what was done (or the reasoning for no change),
   then resolve the ones that are settled — `addPullRequestReviewThreadReply`
   (input field `pullRequestReviewThreadId`) and `resolveReviewThread`
   (`threadId`). Leave a thread unresolved when you pushed back instead of
   changing the code — that is the reviewer's call to close.
5. Report a summary: each comment → action taken. If any comment was ambiguous,
   say how you interpreted it.
