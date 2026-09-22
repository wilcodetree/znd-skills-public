<#
.SYNOPSIS
Fallback usage collector for audit-my-context. Walks Claude Code and Cowork transcript
folders on this machine and writes one usage.json with invocation counts per tool, MCP
server, skill and plugin agent, split by harness and project, for the last N days.
Read only. No network. Use BurnMon (burnmon-cli.exe tools --json) instead when installed.

.EXAMPLE
# PowerShell on the laptop, from the skill folder
cd <skill folder>\scripts
.\collect-usage.ps1 -Since 30 -Out .\usage.json -ExcludeProject 'C:\dev\Work'
#>
[CmdletBinding()]
param(
    [int]$Since = 30,
    [string]$Out = ".\usage.json",
    [string[]]$ExtraRoot = @(),
    [string[]]$ExcludeProject = @()
)

$ErrorActionPreference = 'Stop'
$cutoff = (Get-Date).ToUniversalTime().AddDays(-$Since)

# Trail folders, same list BurnMon's scan uses.
$roots = New-Object System.Collections.Generic.List[string]
function Add-Root([string]$p) { if ($p -and (Test-Path -LiteralPath $p -PathType Container)) { $roots.Add($p) } }
Add-Root (Join-Path $HOME '.claude\projects')
if ($env:CLAUDE_CONFIG_DIR) { Add-Root (Join-Path $env:CLAUDE_CONFIG_DIR 'projects') }
foreach ($name in @('local-agent-mode-sessions', 'claude-code-sessions')) {
    if ($env:APPDATA) { Add-Root (Join-Path $env:APPDATA "Claude\$name") }
    if ($env:LOCALAPPDATA) {
        Add-Root (Join-Path $env:LOCALAPPDATA "Claude\$name")
        foreach ($mapped in @('Roaming', 'Local')) {
            Get-ChildItem -Path (Join-Path $env:LOCALAPPDATA 'Packages') -Filter 'Claude_*' -Directory -ErrorAction SilentlyContinue |
                ForEach-Object { Add-Root (Join-Path $_.FullName "LocalCache\$mapped\Claude\$name") }
        }
    }
}
foreach ($r in $ExtraRoot) { Add-Root $r }
if ($roots.Count -eq 0) { Write-Error 'No transcript folders found. Checked ~\.claude\projects and the Claude Desktop session folders.'; exit 2 }

# -ExcludeProject drops every session whose cwd contains one of these fragments, so a walled
# tree (client work, an employer's repos) never appears in the output.

$items = @{}   # key -> stats
$sessions = @{}
$filesRead = 0
$filesSkipped = 0
function Touch([string]$key, [string]$kind, [string]$harness, [string]$project, [string]$session, [datetime]$at) {
    if (-not $items.ContainsKey($key)) {
        $items[$key] = [ordered]@{ name = $key; kind = $kind; invocations = 0; sessions = @{}; harness = @{}; projects = @{}; first_seen = $at; last_seen = $at }
    }
    $s = $items[$key]
    $s.invocations++
    $s.sessions[$session] = 1
    $s.harness[$harness] = 1 + [int]$s.harness[$harness]
    if ($project) { $s.projects[$project] = 1 + [int]$s.projects[$project] }
    if ($at -lt $s.first_seen) { $s.first_seen = $at }
    if ($at -gt $s.last_seen) { $s.last_seen = $at }
}

foreach ($root in $roots) {
    $harness = if ($root -like '*\projects') { 'claude-code' } else { 'cowork' }
    Get-ChildItem -Path $root -Filter '*.jsonl' -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object { $_.LastWriteTimeUtc -ge $cutoff } |
        ForEach-Object {
            $file = $_
            $sessionId = "$($file.Directory.Name)/$($file.BaseName)"
            $project = ''
            # Live sessions hold their transcript open for writing; share Read+Write+Delete or the walk dies on the first busy file.
            try {
                $stream = [System.IO.File]::Open($file.FullName, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]([System.IO.FileShare]::ReadWrite -bor [System.IO.FileShare]::Delete))
                $reader = New-Object System.IO.StreamReader($stream)
            } catch {
                $script:filesSkipped++
                Write-Verbose "Skipped (locked): $($file.FullName)"
                return
            }
            $filesRead++
            try {
                while ($null -ne ($line = $reader.ReadLine())) {
                    if ($line.IndexOf('"tool_use"') -lt 0 -and $line.IndexOf('"cwd"') -lt 0) { continue }
                    try { $o = $line | ConvertFrom-Json } catch { continue }
                    if ($o.cwd -and -not $project) {
                        $project = [string]$o.cwd
                        foreach ($x in $ExcludeProject) { if ($project -like "*$x*") { $project = '__excluded__' } }
                    }
                    if ($project -eq '__excluded__') { break }
                    if ($o.type -ne 'assistant' -or -not $o.message -or -not $o.message.content) { continue }
                    $at = $cutoff
                    if ($o.timestamp) { try { $at = ([datetime]$o.timestamp).ToUniversalTime() } catch { } }
                    if ($at -lt $cutoff) { continue }
                    $sessions[$sessionId] = $harness
                    foreach ($b in $o.message.content) {
                        if ($b.type -ne 'tool_use') { continue }
                        $n = [string]$b.name
                        if ($n -eq 'Skill' -and $b.input.skill) {
                            # Strip the plugin namespace so "znd-private:hub-update" and a personal "hub-update" join on one row; the namespace is kept as a separate row too.
                            $sk = [string]$b.input.skill
                            Touch "skill:$($sk.Split(':')[-1])" 'skill' $harness $project $sessionId $at
                            if ($sk.Contains(':')) { Touch "plugin:$($sk.Split(':')[0])" 'plugin' $harness $project $sessionId $at }
                            continue
                        }
                        if ($n -eq 'Agent' -and $b.input.subagent_type) { Touch "agent:$($b.input.subagent_type)" 'agent' $harness $project $sessionId $at }
                        if ($n -eq 'Read' -and ([string]$b.input.file_path) -like '*SKILL.md' -and ([string]$b.input.file_path) -match '[\\/]skills[\\/]') {
                            # Only a SKILL.md under a skills folder counts; a template or a copy in an assets folder does not.
                            $skillName = Split-Path (Split-Path ([string]$b.input.file_path) -Parent) -Leaf
                            Touch "skill:$skillName" 'skill' $harness $project $sessionId $at
                        }
                        if ($n -notmatch '^[A-Za-z0-9_:.-]+$') { continue }  # harness-internal pseudo tools carry free text as a name
                        if ($n -like 'mcp__*') {
                            $parts = $n -split '__', 3
                            Touch "server:$($parts[1])" 'mcp-server' $harness $project $sessionId $at
                            Touch $n 'mcp-tool' $harness $project $sessionId $at
                        } else {
                            Touch $n 'builtin' $harness $project $sessionId $at
                        }
                    }
                }
            } finally { $reader.Dispose(); $stream.Dispose() }
        }
}

$rows = foreach ($s in $items.Values) {
    [ordered]@{
        name = $s.name; kind = $s.kind; invocations = $s.invocations
        sessions = $s.sessions.Count
        harness = $s.harness; projects = $s.projects
        first_seen = $s.first_seen.ToString('o'); last_seen = $s.last_seen.ToString('o')
    }
}
$result = [ordered]@{
    generated_at = (Get-Date).ToUniversalTime().ToString('o')
    window_days = $Since
    roots = $roots
    files_read = $filesRead
    files_skipped_locked = $filesSkipped
    sessions = $sessions.Count
    sessions_by_harness = ($sessions.Values | Group-Object | ForEach-Object { @{ $_.Name = $_.Count } })
    coverage_note = 'Local Claude Code and Cowork trails on this machine only. Claude deletes trails after about 30 days. Cloud Cowork sessions leave no local file. No token figures; that is BurnMon.'
    items = @($rows | Sort-Object invocations -Descending)
}
$result | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $Out -Encoding UTF8
Write-Host ("Wrote {0}: {1} items from {2} sessions in {3} files ({5} skipped, locked), window {4} days." -f $Out, $items.Count, $sessions.Count, $filesRead, $Since, $filesSkipped)
