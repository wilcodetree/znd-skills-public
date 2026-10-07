# ZND Skills Setup (`znd-setup`)

One-time setup skills from [ZeroNonsense.dev](https://zerononsense.dev). Install the plugin,
run the skills once, then disable it so its descriptions stop costing context in every
session. Turn it back on when you add a department or a project, or want to redo a step.

## Order of use

| Step | Skill | Result |
|---|---|---|
| 1 | `siteoffice-setup` | A folder structure for your holding, company, department or project, plus the Claude project description, instructions and work folder for each |
| 2 | `setup-claude-instructions` | Your own custom instructions for Claude, from an interview |
| 3 | `setup-writing-style` | A writing-voice skill built from samples of your own writing |
| 4 | `setup-brand` | A brand skill with your colours, type and logo rules |

Every skill interviews you and writes your own answers down. None of them copies someone
else's rules onto you.

## After setup: scheduled tasks worth creating

Two light checks keep the setup from drifting. Paste a prompt into a Cowork chat to create the
task. Replace `<root>` with your top folder and `<report folder>` with where reports go.

### Weekly instruction-file check

```text
Create a Cowork scheduled task. taskId: weekly-instruction-check. Title: Weekly instruction
check. Cron: 0 9 * * 1. Notify on completion: yes. Prompt:

Read-only check of <root>. For every CLAUDE.md and AGENTS.md up to three folders deep, report:
files over 200 lines or 25 KB, @imports that do not resolve, and folder paths that no longer
exist. For every project folder, report a missing CLAUDE.md or AGENTS.md. Change nothing.
Write the report to <report folder>\<date>_instruction_check.md and start the reply with a
three-line summary.
```

### Monthly context audit

Needs the sibling plugin `znd` (skill `audit-my-context`). The prompt is in that plugin's
README.
