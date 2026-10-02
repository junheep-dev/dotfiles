---
name: create-issue
description: Create a Linear issue with the right assignment, status, project, and labels. Use whenever asked to create an issue, sub-issue, or follow-up.
---

Create the Linear issue, then set its fields based on how it relates to the
user's current work — judge this from the conversation and the current
branch:

- An offshoot of that work (a sub-issue, a follow-up, a prerequisite):
  assign it to the user as "Todo", and put it in the same project when
  that fits.
- Unrelated to it: leave it unassigned in Triage.

Keep the issue description factual and terse — no ceremonial headers. Write only
what someone picking it up needs to start: what's wanted, and the facts or
decisions that shape it. Leave out the investigation, option comparisons and
line numbers; whoever picks the issue up will look those up against the code as
it is then.

Always inspect the team's existing labels and apply every label that fits the
issue. Do not create a new label unless the user explicitly asks for one.
