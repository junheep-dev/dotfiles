---
name: pair-programming
description: Write code collaboratively through brief discussion of the next change, focused implementation steps, and shared code review. Use when the user wants to code together with the agent writing the code and the user participating throughout, rather than executing a detailed plan all at once.
---

# Pair Programming

Discuss the next meaningful change briefly, implement the agreed step, then
review the actual code together and propose what comes next.

## Investigate and propose

Inspect relevant code, applicable repository guidance, and existing changes.
Preserve unrelated work. Ground the approach in actual code and verify external
API or tool behavior against official documentation or source.

Complete the read-only investigation needed to make a concrete proposal without
asking permission to continue researching. Resolve questions such as tool and
version compatibility yourself when the information is accessible. Do not end
with a promise to investigate when you can continue now. Pause when a user
choice is needed, access is blocked, or reasonable investigation leaves a
material uncertainty; explain what is known and what remains unresolved.
Ask only about choices that affect the current step. Defer decisions that
only affect later work until that work is proposed.

When findings materially differ from an explicit requirement or prior
agreement, explain the mismatch and its effect on the current step. Recommend
a direction and ask whether to retain or revise the requirement before acting
on that difference. Do not silently change the requirement, treat the mismatch
as a routine implementation detail, or defer an important decision until after
execution. Base the recommendation on the project's needs, not novelty alone.

Share the overall direction briefly, then propose the next reviewable step:
what will change, where, why, what the user will judge, and where you will stop.
Recommend an approach; discuss alternatives only when they materially affect
behavior or design. Do not require a detailed specification, implementation
plan document, or exhaustive task list.

Size the step around its purpose and review effort, not a line or file count.
Keep routine work for one agreed purpose together; separate decisions that
deserve their own discussion. Do not reduce useful work to trivial edits just
to make it small. Adjust the scope and explanation depth to user feedback.

Get agreement before editing. If the concrete approach and scope are already
agreed, proceed without asking again. Agreement on the overall goal does not
authorize every remaining step.

## Use standard setup workflows

For project setup, check for a framework or library's standard generator or
setup CLI and prefer it when it fits. Explain the command, important options,
destination, and expected result before execution. If it does not fit, explain
why and propose an alternative. Do not manually recreate a standard setup
file by file merely to make the steps smaller.

Generation can be one review step even when it creates many files. Run the
agreed command and check its result, then review the generated structure and
important settings. Keep subsequent custom changes separate: propose what
needs adaptation and why before modifying the generated output.

## Implement and verify

Implement only the agreed scope. Make routine implementation choices without
interrupting for each detail. If discoveries require a different approach,
change behavior beyond the agreement, expand the scope, or make the step too
large to review comfortably, discuss a revised boundary before proceeding.

For custom changes, prioritize manageable review scope over a runnable
intermediate state. Do not add unagreed changes merely to make the app run or
the build pass. Run checks appropriate to the current step and explain any
incomplete behavior or verification limits.

## Review and continue

Explain important changes with file and line references, focusing on behavior
and reasoning rather than narrating every line. Use short snippets when they
help. Summarize generated output rather than reviewing every generated file.
Report validation and its limits.

Include the next proposal in the same message when it follows naturally so the
user can review the current code and agree to the next step in one reply.
Then wait. Do not implement later steps while awaiting review, even when the
next action seems obvious. Questions are discussion, not approval. Clarify
when a reply approves the current code but leaves the next step uncertain.

Apply requested amendments, verify them, and present the updated result before
moving on. At the final step, resolve the review and summarize the outcome
and remaining limitations without inventing additional work.

## Preserve continuity

Carry forward agreements when resuming after an interruption, keeping the
current step and outstanding review clear. Review already completed work as it
stands; do not reset or rewrite it merely to recreate this workflow.

Review agreement does not itself request staging, committing, pushing, or
publishing. Follow the user's separate instructions for those actions.
