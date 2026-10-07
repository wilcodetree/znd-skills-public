# ZND Skills Public (`znd`)

Day-to-day agent skills from [ZeroNonsense.dev](https://zerononsense.dev). Install it and keep
it on. For the one-time setup skills, see the sibling plugin `znd-setup`.

| Skill | Use it when |
|---|---|
| `audit-my-context` | You want to know which skills, MCP servers, connectors and plugins earn their place in your context window, from 30 days of real usage |
| `handover` | A chat has grown long and needs to continue in a fresh one without losing anything |
| `markitdown` | You are about to read a PDF, Word, PowerPoint, Excel or HTML file: convert it to Markdown first and save tokens |
| `humanize` | A text or reply reads like an AI wrote it: strip the tells, keep the meaning |
| `wait-what` | You type "wait what" because the last answer lost you: it re-pitches in plain words |
| `writing-for-agents` | You write or review a skill, AGENTS.md or CLAUDE.md and want it to fire and run predictably |
| `llm-council` | A hard decision needs independent answers that review each other, not one agreeable answer. Cross-vendor mode needs an OpenRouter key |
| `audit-ai-instructions` | You want to find missing, conflicting or stale instructions across Codex, Claude Code, Cowork and Copilot, or a new model just shipped |

## Scheduled tasks

Two of these skills work well on a timer. In Cowork, paste the prompt into a chat. In Claude Code, run
the same prompt through your own scheduler. Replace `<report folder>` with a folder you keep.

### Monthly context audit

```text
Create a Cowork scheduled task. taskId: monthly-context-audit. Title: Monthly context audit.
Cron: 0 10 1 * *. Notify on completion: yes. Prompt:

Run the audit-my-context skill over the last 30 days of usage. Report only: propose keep,
drop, demote or activate per skill, MCP server, connector and plugin, and never toggle
anything. Write the report to <report folder>\<date>_context_audit.md. Start the reply with
a three-line summary, then the top five proposals with their evidence.
```

### Instruction audit after a model release

```text
Create a Cowork scheduled task. taskId: model-release-instruction-audit. Title: Instruction
audit on model release. Cron: 0 9 * * 1. Notify on completion: yes. Prompt:

Check which Claude model you run on and compare it with the last line of
<report folder>\model_seen.txt. If it is the same, reply "no new model" and stop. If it
differs, run the audit-ai-instructions skill in model release mode over my skills and
instruction files, write the report to <report folder>\<date>_model_release_audit.md, append
the new model ID to model_seen.txt, and start the reply with a three-line summary. Report only,
change nothing.
```
