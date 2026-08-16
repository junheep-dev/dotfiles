---
name: start-issue
description: Start work on a Linear issue — understand it, discuss the approach, then set up the branch. Use whenever the user sets out to work on an issue, whether by full ID or number alone (e.g. "/start-issue PROD-1066", "let's start 1060", "picking up PROD-1064 next").
---

Start work on the Linear issue the user named. A bare number means the issue
with that number in the team already in play.

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
   `gitBranchName`, switch to that branch — creating it if it doesn't exist —
   then assign the issue to the user and set it to "In Progress".

Translate the branch slug to English when Linear generated it from a Korean
title, keeping the same format. The issue identifier in it (`prod-1066`) is what
links the branch back to Linear and closes the issue on merge — never translate,
renumber, or drop that part.

If the scope discussion surfaces work that doesn't belong in this issue,
propose splitting it into a sub-issue instead of expanding scope.
