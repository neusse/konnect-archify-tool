[CmdletBinding()]
param(
    [string]$ToolRepo,
    [string]$KonnectRepo,
    [ValidateSet('baseline', 'strict')]
    [string]$VisualPolicy = 'baseline'
)

$ErrorActionPreference = 'Stop'

function Resolve-Repository {
    param(
        [string]$RequestedPath,
        [string[]]$Candidates,
        [string]$Marker,
        [string]$Name
    )

    $paths = @()
    if ($RequestedPath) {
        $paths += $RequestedPath
    }
    $paths += $Candidates

    foreach ($path in $paths) {
        if (-not $path -or -not (Test-Path -LiteralPath $path -PathType Container)) {
            continue
        }
        $resolved = (Resolve-Path -LiteralPath $path).Path
        if (Test-Path -LiteralPath (Join-Path $resolved $Marker) -PathType Leaf) {
            return $resolved
        }
    }

    throw "Unable to locate $Name. Pass its path explicitly."
}

$profileRoot = $env:USERPROFILE
$toolRoot = Resolve-Repository -RequestedPath $ToolRepo -Candidates @(
    (Get-Location).Path,
    (Join-Path $PSScriptRoot '..\..\..\..'),
    (Join-Path $profileRoot 'Codex_Projects\konnect-archify-tool'),
    (Join-Path $profileRoot 'Codex_Projects\archify')
) -Marker 'skills-lock.json' -Name 'konnect-archify-tool'

$konnectRoot = Resolve-Repository -RequestedPath $KonnectRepo -Candidates @(
    (Join-Path $profileRoot 'Documents\Codex\Konnect'),
    (Join-Path $profileRoot 'Codex_Projects\Konnect')
) -Marker 'docs\ARCHITECTURE.md' -Name 'Konnect'

$cli = Join-Path $toolRoot '.agents\skills\archify\bin\archify.mjs'
$releaseManifest = Join-Path $toolRoot '.agents\skills\archify\skill-release.json'
$archifyRelease = Get-Content -LiteralPath $releaseManifest -Raw | ConvertFrom-Json
$evidenceVersion = "archify-$($archifyRelease.version)"
$outputRoot = Join-Path $toolRoot 'diagrams\output'
$receiptRoot = Join-Path $toolRoot 'diagrams\receipts'
$rawEvidenceRoot = Join-Path $toolRoot "diagrams\.raw-evidence\$evidenceVersion"
$publicEvidenceRoot = Join-Path $toolRoot "diagrams\evidence\$evidenceVersion"
$revision = (& git -C $konnectRoot rev-parse HEAD).Trim()
if ($LASTEXITCODE -ne 0) {
    throw 'Unable to read the Konnect revision.'
}

function ConvertTo-PublicReceipt {
    param([string]$Text)

    $escapedToolRoot = $toolRoot.Replace('\', '\\')
    $escapedKonnectRoot = $konnectRoot.Replace('\', '\\')
    return $Text.Replace($escapedToolRoot, '<tool-repo>').Replace($escapedKonnectRoot, '<konnect-repo>').Replace($toolRoot, '<tool-repo>').Replace($konnectRoot, '<konnect-repo>')
}

function Write-PublicReceipt {
    param(
        [string]$Path,
        [string]$Text
    )

    $content = (ConvertTo-PublicReceipt $Text).TrimEnd() + [Environment]::NewLine
    [System.IO.File]::WriteAllText($Path, $content, [System.Text.UTF8Encoding]::new($false))
}

$architectureSource = Join-Path $toolRoot 'diagrams\sources\konnect-runtime.architecture.json'
$architecture = Get-Content -LiteralPath $architectureSource -Raw | ConvertFrom-Json
if ($architecture.meta.repository.revision -ne $revision) {
    throw "The architecture source pins $($architecture.meta.repository.revision), but Konnect is at $revision. Review source drift and update the affected diagram specifications before regeneration."
}

$items = @(
    @{ Type = 'architecture'; Base = 'konnect-runtime'; Source = $architectureSource; RepositoryEvidence = $true },
    @{ Type = 'workflow'; Base = 'konnect-guarded-pcb-mutation'; Source = (Join-Path $toolRoot 'diagrams\sources\konnect-guarded-pcb-mutation.workflow.json'); RepositoryEvidence = $false },
    @{ Type = 'sequence'; Base = 'konnect-live-pcb-tool-call'; Source = (Join-Path $toolRoot 'diagrams\sources\konnect-live-pcb-tool-call.sequence.json'); RepositoryEvidence = $false },
    @{ Type = 'dataflow'; Base = 'konnect-manufacturing-evidence'; Source = (Join-Path $toolRoot 'diagrams\sources\konnect-manufacturing-evidence.dataflow.json'); RepositoryEvidence = $false },
    @{ Type = 'lifecycle'; Base = 'konnect-schematic-transaction'; Source = (Join-Path $toolRoot 'diagrams\sources\konnect-schematic-transaction.lifecycle.json'); RepositoryEvidence = $false }
)

New-Item -ItemType Directory -Path $outputRoot -Force | Out-Null
New-Item -ItemType Directory -Path $receiptRoot -Force | Out-Null
New-Item -ItemType Directory -Path $rawEvidenceRoot -Force | Out-Null
New-Item -ItemType Directory -Path $publicEvidenceRoot -Force | Out-Null
$results = @()

foreach ($item in $items) {
    $extra = @()
    if ($item.RepositoryEvidence) {
        $extra = @('--repo-root', $konnectRoot)
    }

    $outputPath = Join-Path $outputRoot "$($item.Base).html"
    $rawItemEvidence = Join-Path $rawEvidenceRoot $item.Base
    $publicItemEvidence = Join-Path $publicEvidenceRoot $item.Base
    New-Item -ItemType Directory -Path $rawItemEvidence -Force | Out-Null
    New-Item -ItemType Directory -Path $publicItemEvidence -Force | Out-Null

    $finalizeArgs = @($cli, 'finalize', $item.Type, $item.Source, $outputPath, '--quality', 'showcase', '--out-dir', $rawItemEvidence, '--json') + $extra
    $finalizeText = (& node @finalizeArgs | Out-String).Trim()
    if ($LASTEXITCODE -ne 0) {
        throw "Finalize failed for $($item.Base):`n$finalizeText"
    }
    $finalizeReceipt = $finalizeText | ConvertFrom-Json
    if (-not $finalizeReceipt.ok -or $finalizeReceipt.status -ne 'pass' -or
        $finalizeReceipt.gates.validate -ne 'pass' -or
        $finalizeReceipt.gates.deliver -ne 'pass' -or
        $finalizeReceipt.gates.check -ne 'pass' -or
        $finalizeReceipt.gates.'browser-check' -ne 'pass') {
        throw "Finalize receipt for $($item.Base) did not pass every required gate."
    }
    Write-PublicReceipt -Path (Join-Path $receiptRoot "$($item.Base).finalize.json") -Text $finalizeText

    $visualText = (& node $cli visual-check $outputPath --out-dir $rawItemEvidence --summary --require-provenance | Out-String).Trim()
    $visualExit = $LASTEXITCODE
    $visualSummary = $visualText | ConvertFrom-Json
    if ($visualExit -ne 0 -or -not $visualSummary.ok -or $visualSummary.status -ne 'pass') {
        throw "Visual evidence for $($item.Base) failed: $visualText"
    }
    $visualReceiptText = Get-Content -LiteralPath $visualSummary.evidence.receipt -Raw
    $visualReceipt = $visualReceiptText | ConvertFrom-Json
    Write-PublicReceipt -Path (Join-Path $receiptRoot "$($item.Base).visual-check.json") -Text $visualReceiptText

    $usesReadableScroll = @($visualReceipt.containment.viewports | Where-Object { $_.verticalScrollAccepted }).Count -gt 0
    if ($VisualPolicy -eq 'strict' -and $usesReadableScroll) {
        throw "Visual evidence for $($item.Base) passes Archify's readable-scroll contract but does not satisfy the requested strict no-scroll policy."
    }

    Copy-Item -LiteralPath $visualSummary.evidence.contactSheet -Destination (Join-Path $publicItemEvidence (Split-Path -Leaf $visualSummary.evidence.contactSheet)) -Force
    foreach ($screenshot in $visualSummary.evidence.screenshots) {
        Copy-Item -LiteralPath $screenshot.path -Destination (Join-Path $publicItemEvidence (Split-Path -Leaf $screenshot.path)) -Force
    }

    $visualStatus = if ($usesReadableScroll) { 'readable-scroll-pass' } else { 'pass' }

    $results += [pscustomobject]@{
        Diagram = $item.Base
        Finalize = 'pass'
        Browser = 'pass'
        Visual = $visualStatus
    }
}

$results | Format-Table -AutoSize
Write-Output "Konnect revision: $revision"
Write-Output "Visual policy: $VisualPolicy"
