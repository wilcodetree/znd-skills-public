---
name: setup-claude-instructions
description: >-
  Write a personal set of custom instructions for Claude by interviewing the user about how they want replies structured, formatted and delivered, never by copying someone else's rules onto them. Use on "set up my Claude instructions", "help me write custom instructions", "what should I put in Settings for Claude", "create a CLAUDE.md for me", "how should I tell Claude to talk to me", or Dutch equivalents like "help me met mijn instructies voor Claude". Produces a paste-in text for Claude.ai or Cowork settings, or a CLAUDE.md/AGENTS.md file for a project. Do NOT use this to apply someone else's existing instructions to a new user; the point is to ask, not to reuse.
---

# Set up personal Claude instructions

One person's rules are not another person's rules. This skill exists to ask, not to hand over a
template. `references/worked_example.md` shows one real, filled-in result, from ZeroNonsense.dev's
own founder, so you have something concrete to react to. It is an example of the shape a good
answer can take, never a default to apply to someone else.

## When to use this skill

- The user wants Claude to behave more predictably for them across sessions
- They already tried instructions once and they did not stick, or felt generic
- They are setting up a new Claude Code project, Cowork account, or Claude.ai profile and want to
  start deliberately instead of by trial and error
- Do NOT use this when the user hands you instructions they already wrote and just wants them
  saved or pasted somewhere, that is a plain file-save task, not an interview

## Procedure

1. **Ask about reply shape**, one question at a time, plain conversation, not a form:
   - Do they want the conclusion first, then the reasoning, or do they prefer to follow the
     reasoning and land on the conclusion?
   - For a finished piece of work, do they want a full recap of what changed, or just the outcome
     and a pointer to the file?
   - Any hard length preference, such as "keep routine answers short, only go long when I ask"?

2. **Ask how they want actions delivered.** Do they run commands themselves afterward? If so, in
   what shell (PowerShell, bash, zsh) and do they want every command as a complete, copyable block,
   or is a short description enough? Do they want to know exactly what changed even when Claude
   makes the edit itself, or is a summary fine?

3. **Ask about tone and language.** Formal or casual, first name or not, one language or does it
   switch with them. Ask directly whether they want Claude to flag its own mistakes plainly at the
   top of a reply rather than softening or burying them, most people do once asked, but it is their
   call.

4. **Ask about hard rules**, the kind that would be a correction if broken: things Claude should
   never do without asking first, things it should always do (cite a source before stating a fact,
   confirm before an irreversible action, name a model check before starting a task). Do not
   suggest Wilco's own rules from the worked example as defaults, ask what THIS person's version
   of each rule is, if they have one at all. Many people will not have a hard rule for every
   category, that is a valid answer.

5. **Ask about working context worth Claude knowing by default**: role, company, the tools or
   platforms they use most, anything they would otherwise have to repeat in every conversation.
   Keep this generic and short, this is not a full company hub, just the facts that change how
   Claude should answer.

6. **Draft the instructions**, organised under clear headings (reply shape, formatting, tone,
   working rules, about me), using their own words and examples wherever they gave one. Keep it
   as short as it can be while still being specific, a instructions file nobody rereads is dead
   weight.

7. **Show the draft back before saving anything.** Ask what to change. This is the step most
   likely to be skipped and most likely to produce a instructions file that does not actually fit.

8. **Save it to the right place**, and say which:
   - Claude.ai or Cowork: paste-in text for Settings, Profile, Preferences (or the equivalent
     "Custom instructions" field)
   - A specific project in Claude Code or another harness: a `CLAUDE.md` (or `AGENTS.md`, the
     open, cross-tool format, with a one-line `@AGENTS.md` import in `CLAUDE.md` if both exist)
   - Say plainly if the platform they use has no such setting, rather than leaving it unclear
     whether a save step happened

## Pitfalls

- Defaulting to the worked example's rules (no em dashes, TLDR-first, PowerShell-only) for someone
  who never asked for them. Those are one person's preferences, not the spec.
- Writing a long, thorough document nobody will reread. Specific and short beats exhaustive.
- Saving before showing the draft back. The interview is only half the value, the review is the
  other half.
- Assuming the user's platform supports a settings field for this. Some harnesses only read a
  project file. Ask, or check, before promising a save location that does not exist.
