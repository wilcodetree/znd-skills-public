# What each item costs, per harness

Standing cost is what a session pays on every turn before any work. Estimates use 4 characters
per token. Where a number below comes from one measured install, it is an example of the order
of magnitude, not a constant; measure your own with `/context` in Claude Code.

| Item | Claude Code (tool search on, 4.5+ models) | Cowork / Claude Desktop | Codex |
|---|---|---|---|
| Skill | Full description every turn, body on invocation. `disable-model-invocation: true` hides even the description until called by name. | Full description every turn. Toggle per account in Customize > Skills only. | Name and description, list capped at 2 percent of context or 8,000 characters; beyond that descriptions truncate and skills drop with a warning. |
| Plugin | Adds its skills (as above) and its agents. One measured install: 67 agents cost 6.4k tokens, about 95 tokens each. `enabledPlugins` in `.claude\settings.json` scopes per repo. | Adds its skills to the account-wide list. Per account only. | n/a |
| MCP server | Tool names and server instructions only; schemas deferred through tool search, measured 0 tokens for 254 tools. `alwaysLoad` opts out per server. | Tool names deferred, schemas loaded through ToolSearch on demand. Per-chat toggle in the composer. | Deferred behind `tool_search` since June 2026. `enabled = false` per server in the project `.codex\config.toml` can subtract a user-level server. |
| Connector (claude.ai) | Same as MCP. `disableClaudeAiConnectors: true` in a project settings file removes them. | Per account, per-chat toggle. | n/a |
| Memory / instruction files | The whole CLAUDE.md chain, every turn. One measured hub: 4 files, 15.1k tokens. Out of scope here; see audit-ai-instructions. | Project instructions plus mounted CLAUDE.md chain. | AGENTS.md chain. |

Measured example, one repo, Claude Code v2.1.258: `enabledPlugins` plus `skillOverrides` took
skills from 399 (9.9k tokens) to 41 (3.8k) and removed 67 agents (6.4k); MCP scoping changed
0 tokens. Total per turn 68.8k to 61.8k, about 10 percent.

## Where the trails are

Claude Code: `%USERPROFILE%\.claude\projects\<encoded-cwd>\<session>.jsonl`, subagents in a
subfolder per session. Honour `CLAUDE_CONFIG_DIR` when set. Claude deletes trails after about
30 days, so a 30-day window is the most a raw scan can see; BurnMon's store keeps them longer.
Cowork and Desktop chat: `%APPDATA%\Claude\local-agent-mode-sessions\` (regular install) or
`%LOCALAPPDATA%\Packages\Claude_*\LocalCache\Roaming\Claude\local-agent-mode-sessions\` (Store
install); macOS `~/Library/Application Support/Claude/`, Linux `~/.config/Claude/`. Cloud
Cowork sessions leave no local trail.

## What a tool_use block tells you

Every assistant message in a trail carries `content[].type == "tool_use"` with `name`. Prefix
`mcp__<server>__<tool>` gives the server. `Skill` with `input.skill` gives the skill name; a
`Read` of a path ending in `SKILL.md` is a second, weaker signal for skills invoked by file.
`ToolSearch` with a `select:` query names deferred tools the model wanted; frequent ToolSearch
for the same tool is the design working, not waste. `Agent` with `subagent_type` names plugin
agents. Token counts per message sit in `message.usage` and are BurnMon's job, not this skill's.
