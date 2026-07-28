---
name: start-issue
description: Start work on a Linear issue — understand it, discuss the approach, then set up the branch. Use whenever the user sets out to work on an issue, whether by full ID or number alone (e.g. "/start-issue PROD-1066", "let's start 1060", "picking up PROD-1064 next").
---

Start work on the Linear issue given as `$ARGUMENTS`.

1. Fetch the issue from Linear, including its description, comments, parent
   issue, and sub-issues.
2. Explore the code relevant to the issue so the discussion is grounded in
   the actual codebase, not assumptions.
3. Report back: what the issue asks for, a rough approach (big picture
   first, not a detailed plan), and any open questions or decisions that
   need the user's input.
4. Stop and discuss. Do not write code, create branches, or change issue
   state yet.
5. Only after the user agrees on the direction: take the issue's
   `gitBranchName` (translated to English if it's in Korean, same format),
   switch to that branch — creating it if it doesn't exist — then assign
   the issue to the user and set it to "In Progress".

If the scope discussion surfaces work that doesn't belong in this issue,
propose splitting it into a sub-issue instead of expanding scope.
