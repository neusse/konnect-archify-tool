[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$KonnectRepo
)

$ErrorActionPreference = 'Stop'
$resolvedRepo = (Resolve-Path -LiteralPath $KonnectRepo).Path

$origin = (& git -C $resolvedRepo remote get-url origin).Trim()
if ($LASTEXITCODE -ne 0) {
    throw 'Unable to resolve the Konnect origin remote.'
}

$revision = (& git -C $resolvedRepo rev-parse HEAD).Trim()
if ($LASTEXITCODE -ne 0) {
    throw 'Unable to resolve the Konnect HEAD revision.'
}

$dirty = [bool](& git -C $resolvedRepo status --porcelain)

[pscustomobject]@{
    RepositoryPath = $resolvedRepo
    Origin = $origin
    Revision = $revision
    Dirty = $dirty
} | Format-List
