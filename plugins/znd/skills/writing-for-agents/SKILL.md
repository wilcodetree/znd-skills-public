---
name: writing-for-agents
description: How to write documents agents consume, skills, AGENTS.md, CLAUDE.md, and any doc reached by a pointer. Use when creating a new skill, rewriting or reviewing an existing one, sharpening a skill description that misfires or never fires, or editing AGENTS.md or CLAUDE.md. Do NOT use for scaffolding and packaging mechanics, that is skill-creator, or for plugin shipping gotchas, that is cowork-plugin-pitfalls.
---

# Writing for agents

Reference for any document an agent runs: a skill, an instruction file, a doc behind a pointer.
The goal is a predictable process every run, not identical output. Adapted from Matt Pocock's
writing-for-agents skill (github.com/mattpocock/skills, MIT, fetched 2026-09-01) and merged with
the ZeroNonsense.dev house rules. Self-contained: everything it needs is in this file.

## The two loads

Every document and pointer spends one of two budgets. Context load: always-loaded material (a
skill description, an AGENTS.md line) costs tokens and attention every turn, fires or not.
Cognitive load: what the human must remember exists. Spend cognitive load where human judgement
matters; spend context load only on pointers that earn it.

## Descriptions are context pointers

The description is the only thing the agent sees until the skill activates, so it carries all
routing weight. Front-load the leading words: distinctive trigger vocabulary in the first
sentence. One trigger per branch: synonyms renaming the same branch are duplicates, collapse
them. Cut identity the body already carries; the description routes, the body explains. Where a
neighbouring skill could catch the same phrase, keep an explicit "Do NOT use for X, that is
skill Y" line. Never reword a trigger phrase people actually type, or one a trigger eval tests:
that is a regression. Caps: the open spec allows 1024 chars; Claude Code cuts the listing at
1,536 chars and gives all skill descriptions together about 1% of the context window, dropping
the least-used ones first. So aim under 500: every character is paid in every session.

## Information hierarchy

Two content types: steps (ordered actions) and reference (rules, facts, definitions). Steps
first, imperative, each with explicit input and output. Pin the first action ("Your first tool
call is X"). Every step ends on a checkable completion criterion: "every modified file accounted
for" beats "produce a list"; vague bounds invite premature completion. Inline what every branch
needs; push what only some branches reach into a references/ file behind a pointer (progressive
disclosure). Co-locate a concept's definition, rules and caveats under one heading. A body of
flat reference (a rules catalogue) is a legitimate arrangement, not a smell; bind it with an
exhaustiveness bar ("every rule applied").

## Failure branches

State what to do when the work cannot be done. A skill without a failure branch invents a
plausible substitute instead of stopping. Name the acceptable outcomes, including "say what is
missing and stop". Give any subagent a refusal token such as CANNOT RUN. One canonical path
beats a search order: "look in these places in order" invites filesystem scanning.

## Language

Prompt the positive: state the target behaviour so the banned one is never spoken; a prohibition
earns its place only as a hard guardrail you cannot phrase positively, and even then pair it
with the positive target. Exception, field-proven near-misses the model actually does get banned
by name. Use leading words: a compact pretrained concept (tight, red, sweep) replaces a
spelled-out triad and anchors behaviour; reuse the same word in description, body and prompts.
Hunt no-ops sentence by sentence: an instruction the model already obeys by default says
nothing, delete the whole sentence. The test is model-relative: settle disagreements by running
the document, not by debate.

## Pruning

Single source of truth per meaning; duplication costs maintenance and inflates prominence. The
environment (config files, --help, directory layout) is a source of truth too: a document
restating it is a cache that goes stale, so cache only what the agent cannot look up (the
unwritten convention, the reason, the gotcha). Remove sediment: superseded notes and dated
fix-logs that no longer change behaviour belong in git history. Shorter documents are easier to
keep relevant.

## House rules (ZeroNonsense.dev, adapt to your own)

Name equals directory name, kebab-case, never containing "claude" or "anthropic". Frontmatter
fields only from the open spec: name, description, license, compatibility, metadata,
allowed-tools. Harness-only fields such as Claude Code's `disable-model-invocation` or
`when_to_use` go only in skills that ship to that harness alone. No em dashes anywhere. Full
absolute paths in prose. Command snippets labeled with where they run, restating cwd and vars.
evals/ folders are frozen fixtures: keep any phrase they test, never edit them. Skill names
never change after shipping (renames orphan installs and break slash commands). Keep one master
copy of every skill and generate the published copies from it; never edit a published copy.
A skill that ships publicly holds no machine paths: take the root as an argument or from an
environment variable.

## Checklist for a new skill

1. Description: triggers front-loaded, one per branch, under 500 chars, sibling boundaries named.
2. Body: steps first, first action pinned, completion criterion per step.
3. Failure branch present, with named acceptable outcomes.
4. Reference co-located or disclosed behind a pointer that resolves.
5. No em dashes, no no-ops, no duplication, no sediment.
6. Trigger test written before shipping: at least three prompts that must fire the skill and
   three near-misses that must not, run with `claude plugin eval` (a `tool_used: Skill` grader)
   or skill-creator's eval mode. Rerun them on every new model release.
7. Done when every checklist item passes and your repo's validator passes.
