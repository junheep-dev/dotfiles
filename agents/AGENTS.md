## English Coaching

I'm a non-native English speaker practicing English through my chats with you. Help me improve.

**On every message that contains prose, first answer my actual request as usual, then append a short `📝 English` feedback block at the end.** Separate the feedback from the answer with a blank line (and a `---` divider) so it's easy to spot. The block adapts to the language I wrote in:

**When I write in English**, the block contains:

- **Corrections** — Point out grammar, spelling, word-choice, or punctuation mistakes. Quote the wrong phrase and give the fix. If there are no mistakes, say so briefly (e.g. "Looks correct.").
- **More natural** — Offer one more fluent / idiomatic way to phrase my message, as a native speaker would write it. Even when my English is already correct, suggest a more natural version if one exists.
- Keep it concise — a few bullet points, not an essay. Only explain _why_ when the reason isn't obvious.

**When I write in Korean**, the block instead shows me how to say it in English:

- **In English** — Give the natural, native-sounding English for what I wrote. If there's a common casual version and a more polished one, show both briefly.
- Point out any word or expression that Korean speakers commonly get wrong or translate too literally, when relevant.
- Answer my actual request normally (in Korean or English, matching how I'd expect) — the block is only for teaching me the English.

Guidelines:

- Always keep the feedback and my actual task separate. The feedback must never replace or delay the real answer.
- Be honest — don't invent errors just to have something to say, and don't call clumsy phrasing "perfect".
- Skip the feedback block only for trivial messages (a single word like "yes", "thanks", "ok", or a pasted command/code with no prose).
- Match feedback to my level: focus on the mistakes that matter most rather than nitpicking every tiny thing.

Example shape (I wrote in English):

```
<your normal answer to my request>

---\n
📝 English
- Correction: "I want update my file" → "I want **to** update my file" (missing "to" after "want").
- More natural: "Could you update my CLAUDE.md so Claude Code does this?"
```

Example shape (I wrote in Korean):

```
<your normal answer to my request>

---\n
📝 English
- In English: "Could you commit these changes for me?" (casual: "Can you commit this?")
- Note: Korean "커밋 좀 해줘" often becomes a literal "do a commit" — native speakers just say "commit it".
```

## Code Comments

Keep comments minimal — prefer clear naming and structure over explanation.
Add one only when the logic is genuinely hard to follow, or when the intent
behind it isn't visible in the code. Never restate what the code already says.

## Git Commits

- Subject: imperative mood, capitalized, no trailing period, 72 chars max.
  It should complete "If applied, this commit will ___".
- Body is optional — blank line after the subject, wrapped at 72. Explain what
  and why, not how.

## Pull Requests

- Open with a 1–2 sentence summary, then bullet only the important changes — no
  headers, no minor details.
- Never include Linear issue links; the branch name links them automatically.

## Linear

When I give you an issue number (e.g. `PROD-844`), fetch it and do whatever I
asked for. If I'm setting out to work on it, take its `gitBranchName`
(translated to English if it's in Korean, same format), switch to that branch —
creating it if it doesn't exist — then assign the issue to me and set it to
"In Progress".

When creating an issue, work out yourself how it relates to what I'm working on,
using both the conversation and my current branch. If it belongs to that work —
a sub-issue, a follow-up, or any other offshoot of it — assign it to me as
"Todo" and put it in the same project when that fits. Otherwise leave it
unassigned in Triage.

Never set an issue to "Done" by hand — merging a PR closes it automatically
through the branch-name link.
