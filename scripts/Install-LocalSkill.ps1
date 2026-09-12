[CmdletBinding()]
param(
    [string]$DestinationRoot = (Join-Path $env:USERPROFILE '.codex\skills'),
    [switch]$Update
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$source = Join-Path $repoRoot '.codex\skills\konnect-archify-refresh'
$destination = Join-Path $DestinationRoot 'konnect-archify-refresh'

if (-not (Test-Path -LiteralPath (Join-Path $source 'SKILL.md') -PathType Leaf)) {
    throw "Repository skill package not found: $source"
}
if ((Test-Path -LiteralPath $destination) -and -not $Update) {
    throw "Local skill already exists: $destination. Pass -Update to refresh it from the repository copy."
}

New-Item -ItemType Directory -Path $destination -Force | Out-Null
Copy-Item -Path (Join-Path $source '*') -Destination $destination -Recurse -Force
Write-Output "Installed konnect-archify-refresh at $destination"
