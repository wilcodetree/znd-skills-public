---
name: audit-ai-instructions
description: Audit an environment for missing, conflicting, or stale AI instructions across Codex, Claude Code, Claude Desktop/Cowork, and GitHub Copilot. Use when checking instruction discovery, shared-rule drift, hooks, or unwanted punctuation, or after a new model release ("new model is out, audit my skills"). Reports evidence and enforcement gaps without automatically changing settings.
---

# Audit AI instructions

Separate three questions: which rules exist, which the client loads, and which
software enforces. Audit the environment where this skill runs. Do not assume
the machine, paths, preferences, or configuration from a prior conversation.

## Establish scope

Identify the active client, model, workspace, OS, and execution boundary
(local, remote, container, or desktop sandbox). Use read-only version information
where available. Ask only if the target remains ambiguous. A Claude model inside
Copilot still uses Copilot's instruction channels.

Read the user's maintained reply contract and the applicable company/project
instructions. Do not replace their preferences with this skill's preferences.
Read ancestors only inside the authorized company boundary. Avoid recursive
scans of other projects, archives, chats, or credentials.

## Model release mode

When the trigger is a new model release, follow
[references/model-release.md](references/model-release.md) instead of the sections below,
then report as in "Report and repair boundary".

## Gather file evidence

Use [scripts/audit_environment.py](scripts/audit_environment.py) with an absolute
`--root` and optional explicit `--home`. Use an available Python 3 interpreter,
preferably the host's supplied runtime. This helper reads known entry points,
prints JSON, and writes nothing. It does not execute configured hooks.

Optional `--manifest` checks a selected manifest containing `files` entries with
`path` and `sha256`. Targets outside the chosen root/home are not read.
Optional `--reply` checks a user-selected UTF-8 sample. Add `--forbid-em-dash`
only when the actual policy forbids U+2014. It checks the whole sample, including
quotes and code. Explain policy exceptions; never silently change evidence.

Exit 0 means no detected file-level failure, 1 means a detected failure, and 2
means an incomplete/error check. Exit 0 does not prove loading or enforcement.
The helper intentionally omits nested rules, editor JSONC, TOML overrides,
account preferences, and plugin configuration. Inspect these separately when
relevant. If tools or files are inaccessible, report UNVERIFIED rather than
inventing an inventory. Do not dump configuration contents or secrets.

## Diagnose discovery and conflicts

- Distinguish canonical sources, generated copies, imports, and prose pointers.
  Check targets and import cycles. Prose pointers depend on model/tool behavior.
- Compare actual rule meanings: opening, footer, punctuation, code exceptions,
  and audience. Do not flag a quoted prohibited example as a reply violation.
- Check discovery roots, overrides, disabled settings, instruction-size limits,
  and fresh-session requirements for the installed client version.
- A matching generated hash proves copy equality, not authority or loading.
- Inspect the client's supported diagnostics for actual instruction loading and
  hook events, trust, and execution. Never execute an unknown hook as a test.

Check current official documentation before declaring support or its absence:

- [Codex instructions](https://learn.chatgpt.com/docs/agent-configuration/agents-md)
  and [hooks](https://learn.chatgpt.com/docs/hooks).
- [Claude Code instructions](https://code.claude.com/docs/en/memory)
  and [hooks](https://code.claude.com/docs/en/hooks).
- [VS Code instructions](https://code.visualstudio.com/docs/agent-customization/custom-instructions)
  and [hook reference](https://code.visualstudio.com/docs/agents/reference/hooks-reference).
- [Claude personalization](https://support.claude.com/en/articles/10185728-understanding-claude-s-personalization-features)
  and [Cowork](https://support.claude.com/en/articles/13345190-get-started-with-claude-cowork).

When browsing is unavailable, date the available knowledge and mark current
compatibility UNVERIFIED. A discovered configuration is not a trusted hook.

## Verify enforcement

Inspect a validator before running it. Use synthetic valid and invalid fixtures
in a temporary directory. Check actual exit codes or structured results,
missing-input handling, and retry limits. Separate fixture tests from live-client
evidence. Inspect a user-selected reply or run a harmless current-session probe
if available. Do not launch paid parallel model sessions just for this audit.

A Stop hook may request correction after text was already streamed. A guarantee
requires validation on every relevant delivery path before rendering or
publication. Assess commentary, artifacts, and final replies separately.
Neither a compliant sample, temperature setting, repeated prompt, skill, nor
an apology proves deterministic compliance.

## Report and repair boundary

Lead with the finding. Use a compact matrix:
`surface | source | discovery evidence | drift | enforcement | verdict`.
Use PASS, FAIL, or UNVERIFIED for each claim. Include exact paths or citations,
specific conflicts, inaccessible scope, tested behavior, and the smallest next
fix. Keep unrelated company context and configuration dumps out of the report.
Save a report only if requested or required by the established local workflow.

Default to read-only diagnosis. An audit does not authorize changing preferences,
trusting hooks, publishing, or modifying instructions. If repair is requested,
preserve unrelated configuration, back up affected files, use the canonical
distribution workflow, and rerun the audit. Never substitute the model's claim
that it read the rules for discovery evidence.
