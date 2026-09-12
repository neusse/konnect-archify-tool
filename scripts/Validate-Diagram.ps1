[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateSet('architecture', 'workflow', 'sequence', 'dataflow', 'lifecycle')]
    [string]$Type,

    [Parameter(Mandatory)]
    [string]$InputPath,

    [string]$KonnectRepo
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$cli = Join-Path $repoRoot '.agents\skills\archify\bin\archify.mjs'
$resolvedInput = (Resolve-Path -LiteralPath $InputPath).Path
$arguments = @($cli, 'validate', $Type, $resolvedInput, '--quality', 'showcase', '--json')

if ($Type -eq 'architecture') {
    if (-not $KonnectRepo) {
        throw '-KonnectRepo is required for source-backed architecture validation.'
    }
    $arguments += @('--repo-root', (Resolve-Path -LiteralPath $KonnectRepo).Path)
}

& node @arguments
exit $LASTEXITCODE
