[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateSet('architecture', 'workflow', 'sequence', 'dataflow', 'lifecycle')]
    [string]$Type,

    [Parameter(Mandatory)]
    [string]$InputPath,

    [Parameter(Mandatory)]
    [string]$OutputPath,

    [string]$KonnectRepo
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$cli = Join-Path $repoRoot '.agents\skills\archify\bin\archify.mjs'
$resolvedInput = (Resolve-Path -LiteralPath $InputPath).Path
$outputParent = Split-Path -Parent $OutputPath

if ($outputParent) {
    New-Item -ItemType Directory -Path $outputParent -Force | Out-Null
}

$absoluteOutput = [System.IO.Path]::GetFullPath($OutputPath)
$arguments = @($cli, 'deliver', $Type, $resolvedInput, $absoluteOutput, '--quality', 'showcase', '--json')

if ($Type -eq 'architecture') {
    if (-not $KonnectRepo) {
        throw '-KonnectRepo is required for source-backed architecture delivery.'
    }
    $arguments += @('--repo-root', (Resolve-Path -LiteralPath $KonnectRepo).Path)
}

& node @arguments
exit $LASTEXITCODE
