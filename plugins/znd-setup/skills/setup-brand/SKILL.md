---
name: setup-brand
description: >-
  Build a personal or company brand skill by interviewing the user about their colours, type, logo rules and per-surface decisions, then writing it as a reusable skill Claude can load on future work. Use on "set up a brand skill", "help me define my brand", "create a brand guide for Claude", "what should our brand rules be", or Dutch equivalents like "help me met onze huisstijl". Do NOT invent colours or rules the user has not confirmed; ask, or read their existing assets.
---

# Set up a brand skill

A brand skill is not a mood board, it is a lookup table an agent can act on without guessing:
exact colour values for dark and light, which logo file for which surface, and the two or three
mistakes that keep happening. `references/worked_example.md` shows ZeroNonsense.dev's own, filled
in, as one example of the shape. Build the new one from this interview, not from that content.

## When to use this skill

- The user is about to produce visual or written material under a brand (deck, website, PDF,
  social image, invoice) and Claude keeps guessing colours or logo choices
- They already have brand assets somewhere (a style guide, a Figma file, hex codes) but nothing
  Claude can read on its own
- Do NOT use this for the writing voice specifically, that is `setup-writing-style`. This skill
  covers everything visual and the hard per-surface rules, not tone of voice.

## Procedure

1. **Ask what they are branding**: a company, a product, or a personal practice, plus a one-line
   description of what it is and who it is for. Output: a one-line brief that steers every later
   answer.

2. **Ask for existing assets first.** A logo file, a style guide, hex codes already in use on a
   website. Read them rather than asking the user to retype colour values by hand; people get
   this wrong from memory more often than they expect. Output: real values sourced from the
   asset, never recalled from memory.

3. **If there are no existing assets, help pick them, and say the trade-off out loud each time**:
   - Primary and accent colour, checked for contrast as body text, not just as decoration. A
     colour that looks good as a logo fill can be illegible as body text; this is the single most
     common brand mistake, name it during the interview, not after the fact.
   - Typography: one face for headings, one for body, at most one more for small print or code.
   - Whether dark and light versions are both needed, or the brand is one look everywhere
     (print-only or single-channel brands gain nothing from a dark mode, and maintaining one is
     wasted effort).
   Output: a primary and accent colour with contrast checked, and a type and dark/light decision,
   each confirmed by the user, not assumed.

4. **Ask which surfaces actually get produced**: website, slide decks, PDFs, social images,
   invoices, print. Not every surface needs full theming; ask rather than theme everything by
   default. A surface that strips inline styles elsewhere (many chat and social platforms do)
   needs no themed version at all. Output: a confirmed surface list, not a guess.

5. **Ask for hard no's**: any asset, photo, colour combination or logo variant that must never be
   used in a given context, and why. This is usually the most valuable part of the interview,
   these are mistakes that already happened once and should not happen again. Output: a list of
   hard no's, each carrying its reason.

6. **Write the skill**, following this shape: a short header naming what it is for, exact colour
   tokens for dark, light and print if all three exist, type choices, a numbered "most often got
   wrong" list built directly from the hard no's in step 5, and a quick-reference block at the
   bottom so an agent does not have to reread the whole file for a hex code. Output: a draft skill
   file matching that shape.

7. **Show the draft back, then say where it lives**: as a project skill (`.claude/skills/`,
   `.agents/skills/`, or the equivalent for their harness) if it only applies to one codebase, or
   at the personal/account level if it should apply everywhere they work. Output: the user
   confirms the draft and its save location.

## Pitfalls

- Inventing colours or claiming a contrast ratio without checking it. State the ratio, or say it
  was not checked.
- Theming a surface nobody actually produces. Ask what exists before designing for what might.
- Copying ZeroNonsense.dev's actual colour values, logo rules or hard no's into someone else's
  skill. The worked example is for shape and inspiration only.
- Skipping the "why" behind a hard no. "Never use the transparent portrait" is a rule with no
  teeth; "it is a draft with fringing in the hair" is one an agent can reason from later.
