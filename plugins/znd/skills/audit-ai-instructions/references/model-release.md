# Model release mode

Run this mode when a new model reaches a harness the skills run in. It answers one question:
which instructions did the new model make unnecessary or harmful. It is a test, never a wipe.
Anthropic and OpenAI both advise re-evaluating instructions per release; the "delete every six
months" advice (Boris Cherny, Claude Code) is an ablation: remove, observe, restore what earns
its place.

## Classify the release

Your first action is to read the vendor's migration guide and model prompting guide for the new
model, fetched live. Record their URLs and the release date.

| Class | Test | Deadline after release |
|---|---|---|
| Point | Same family, vendor says existing prompts work unchanged (Opus 5 to 5.5) | 7 days |
| Major | New family or generation (GPT-6 Astra, a future Opus 6) | 14 days |
| Time floor | Six months since the last major-class pass, no major release since | when due |

Done when the class, the guide URLs and the deadline are written in the report header. If the
guides cannot be fetched, say so, mark the class UNVERIFIED and stop: this mode without the
vendor's own list is guesswork.

## Point pass

1. Extract from the guides every named instruction to remove or retest. Output: a list, each
   item with its guide citation.
2. Run the vendor's own audit where it exists (Anthropic: `/claude-api prompt-audit` in Claude
   Code over the skills folder). From Cowork, hand the human the command; do not simulate it.
3. Sweep every SKILL.md and reference file in scope for those instructions plus the standing
   crutch list below. Output: one finding per hit, `file:line | pattern | guide citation |
   proposed change`.

Done when every file in scope is listed with a finding count, zero included.

## Major and time-floor pass

Everything in the point pass, then:

4. Pick the five most used skills (usage from `audit-my-context` or `/skill-doctor`).
5. For each, run `claude plugin eval` with and without the skill on the new model. Output:
   score with, score without, verdict keep, shrink or retire.
6. For any skill also run by a lighter model (Haiku, Sonnet, Codex via agents-dir), rerun the
   eval on that model before proposing a cut.

Done when each of the five has both scores on every model that runs it, or UNVERIFIED with the
reason.

## Standing crutch list

Instructions that compensated for older models: "verify twice" or "double-check" rituals,
separate verification steps, ALWAYS or NEVER in capitals for judgment calls, numbered recipes
for judgment work, "think step by step" or "think carefully", instructions to write reasoning
into the reply (Opus 5.5 can refuse these as `reasoning_extraction`), long skill descriptions
that fire on a whole domain, instructions to read many docs before every edit.

Keep what no model can infer: paths, folder maps, house conventions, gates, voice rules,
security boundaries. A hard guardrail stays even if the new model seems not to need it.

## Report and repair

Report as in the main skill, one row per finding. Repair only on approval, one finding ID at a
time. Ship every accepted change as a version bump of the plugin that carries the skill
(patch for wording, minor when a skill is retired or a mode changes), so installed copies
update. Log the pass in the decisions log of the repo: model, class, date, what was cut, what
was kept on purpose.
