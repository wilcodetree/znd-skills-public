# Scoring rules

Apply every rule to every inventory row. Each verdict carries the number that produced it.

## Rank

`rank = standing_tokens / (invocations_in_window + 1)`. Sort descending. The top of the list
is what costs most for least. Unpriced rows sort by invocations ascending, after priced rows.

## Verdicts

| Verdict | Rule | What the human does |
|---|---|---|
| `KEEP` | Invoked in 3 or more distinct sessions in the window, or invoked in every week of the window. | Nothing. |
| `DROP` | 0 invocations in a window of 14 days or more, not a rare-event item, not a dependency of a `KEEP` item (a skill another skill loads by name). | Uninstall or disable in the harness. |
| `DEMOTE` | Invoked only by slash command or by name (never by the model picking it from the description), or 1 to 2 invocations in the window for a description over 400 characters. | Keep installed; in Claude Code set `disable-model-invocation: true` or list it in `skillOverrides`; in Cowork turn off auto-trigger where the UI offers it; shorten the description. |
| `ACTIVATE` | A workaround pattern repeats in 3 or more sessions: `Bash` calls to `curl`, `gh`, `az`, `git log` on a remote, or browser navigation to a site, where an installed-but-disabled connector or a known MCP server covers the same call. | Enable that connector or server, and re-audit in 30 days. |
| `REVIEW` | Any of: 0 invocations but the item exists for rare events (handover, incident response, recovery, backup, sign-off); a misfire; a redundancy pair; thin data (window under 14 days). | Answer the question the skill asks, one item at a time. |

Rare-event list, extend when the human names more: handover, incident, postmortem, deploy
checklist, recovery, rollback, backup, sign, security review.

## Misfire

A skill or tool counts as a misfire in a session when its invocation is followed within two
human turns by a correction: the human's next message contains "not that", "wrong skill",
"I meant", "stop", "undo", "wait what", or the model invokes a sibling skill for the same task
straight after. Two or more misfires in the window: `REVIEW`, with the fix being a sharper
description boundary ("Do NOT use for X, that is Y"), not removal.

## Redundancy pair

Two items whose invocations in the window co-occur in the same sessions on the same task
class (both web search, both file read, both PDF), or whose descriptions share three or more
trigger phrases. Report as a pair; recommend keeping the one with more invocations and the
smaller standing cost. Verdict `REVIEW` on both until the human picks.

## Saving

Per `DROP` and `DEMOTE`: standing tokens of that item per turn. Sum per harness. Report as
tokens per turn and as a percentage of the harness's measured or typical baseline (Claude Code
`/context` total if the human pastes it; otherwise state the sum alone, no percentage).

## Report shape

```
AUDIT MY CONTEXT, <window>, <harnesses>, <sessions> sessions
Saving if applied: <n> tokens per turn (Claude Code), <n> (Cowork)
Biggest three: <item> <tokens>, <item> <tokens>, <item> <tokens>

| Item | Kind | Harness | Standing tokens | Invocations | Sessions | Last seen | Verdict | Why |

DROP, in plain words: one paragraph per item.
ACTIVATE, in plain words: one paragraph per item.
REVIEW: the questions, one per item, with a recommendation each.
Files written: <list>
Unpriced rows: <count>, reason.
```
