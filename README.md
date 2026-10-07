# ZeroNonsense.dev skills

Agent Skills from [ZeroNonsense.dev](https://zerononsense.dev), following the open
[Agent Skills specification](https://agentskills.io/specification). They work in any
skills-compatible agent: Claude Code, Cowork, Codex, Copilot, Cursor, Gemini CLI, Amp, Zed and
the rest.

## Install as a plugin

This marketplace holds two plugins:

| Plugin | Display name | What it is for |
|---|---|---|
| `znd` | ZND Skills Public | Day-to-day skills. Install and keep on. |
| `znd-setup` | ZND Skills Setup | One-time setup skills. Install, run once, then disable. |

Each plugin has its own README with the skills and the scheduled tasks worth creating.

Claude Code:

```
/plugin marketplace add wilcodetree/znd-skills-public
/plugin install znd@znd-skills-public
/plugin install znd-setup@znd-skills-public
```

Cowork: Customize, Plugins, Add marketplace, then paste `wilcodetree/znd-skills-public`.

## Install as plain files

Copy any directory from `plugins/znd/skills/` or `plugins/znd-setup/skills/` into whichever location your agent reads. For most
agents that is `~/.agents/skills/`. For Claude Code it is `~/.claude/skills/`.

## Do not edit here

Everything under `plugins/*/skills/` is generated from a private master repo. Pull requests
against those files will be overwritten on the next publish. Open an issue instead.
