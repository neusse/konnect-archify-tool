[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$cli = Join-Path $repoRoot '.agents\skills\archify\bin\archify.mjs'
$lock = Join-Path $repoRoot 'skills-lock.json'

if (-not (Test-Path -LiteralPath $cli -PathType Leaf)) {
    throw "Pinned Archify CLI not found: $cli"
}
if (-not (Test-Path -LiteralPath $lock -PathType Leaf)) {
    throw "Skill lock file not found: $lock"
}

$lockData = Get-Content -LiteralPath $lock -Raw | ConvertFrom-Json
if ($lockData.skills.archify.ref -ne 'v2.16.0') {
    throw "Expected Archify v2.16.0, found '$($lockData.skills.archify.ref)'."
}

& node $cli doctor
if ($LASTEXITCODE -ne 0) {
    throw "Archify doctor failed with exit code $LASTEXITCODE."
}
