---
name: setup-writing-style
description: >-
  Build a personal writing-voice skill by interviewing the user and analysing samples of their own writing, then saving it as a reusable skill Claude loads before drafting anything in their name. Use on "set up a writing style skill", "help Claude sound like me", "learn my writing voice", "make drafts sound like me", or Dutch equivalents like "leer mijn schrijfstijl". Covers register, sentence rhythm, per-format rules and hard bans, derived from the user's own samples and answers, never from someone else's rules. Do NOT use this for visual brand identity, that is setup-brand.
---

# Set up a writing-voice skill

Two people who both say "write like me" mean different things. This skill exists to find out
which, from actual samples and direct questions, not by assuming any one register is correct.
`references/worked_example.md` shows one real, filled-in voice guide, for shape only.

## When to use this skill

- Drafts keep coming back edited for tone, even when the content is right
- The user is about to have Claude write regularly under their name (posts, emails, reports) and
  wants that decided once, not corrected every time
- Do NOT use this for logos, colours or visual identity, that is `setup-brand`. Do NOT use it to
  apply someone else's voice guide (including the worked example) to a new user.

## Procedure

1. **Ask for two to four samples** of writing the user is genuinely proud of, in whatever
   languages and formats they actually write (an email, a post, a report, a proposal). Real
   samples beat a description of style every time; most people describe their voice inaccurately
   but write it accurately without noticing.

2. **Ask which formats they write most often**, since the register that works for a LinkedIn post
   is often wrong for a client email or a status update. If they only ever write one kind of
   thing, one set of rules is enough; if they write several, ask for the differences directly
   ("what changes between how you write to your team and how you write to a client?").

3. **Ask about register directly**: formal or casual, first person or not, how they feel about
   humour, how direct they want to be when delivering bad news or disagreeing with someone.

4. **Ask about hard bans**: specific words, punctuation (an em dash ban is common but is not
   universal, ask rather than assume), habits they actively dislike in their own past drafts.

5. **Ask what "not my voice" looks like for them specifically.** Too stiff, too enthusiastic, too
   hedged, too long-winded, these are different failure modes and the fix for each is different.

6. **Analyse the samples** for concrete, checkable patterns: sentence length variance (short and
   long mixed, or uniform), how they open a piece (with the conclusion, with context, with a
   question), how much hedging or qualification appears, vocabulary level, and how directly they
   state disagreement or bad news.

7. **Write the skill**, following this shape: a short statement of what the voice is for, a
   numbered list of the most checkable, most often broken rules (the ban list belongs here,
   specific and short), a per-format section only if step 2 surfaced real differences between
   formats, and a note on what "not this voice" looks like so a reviewing pass has something
   concrete to check against.

8. **Show the draft back against one of their own samples**: does the summary of their voice
   actually predict what they already wrote? If not, revise before saving.

9. **Say where it lives**: a project skill if it only applies to one context, personal or account
   level if it should apply to everything they write.

## Pitfalls

- Applying the worked example's actual rules (its specific bans, its register) to a new user who
  never confirmed them. It is one person's voice, not a template.
- Working from a description of style instead of real samples. People are unreliable narrators of
  their own writing; the samples are the ground truth.
- Producing a generic "clear and concise" guide that would fit anyone. If it does not name a
  specific, checkable rule, it will not change what gets drafted.
- Skipping step 8. A voice guide that was never checked against a real sample is a guess.
