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
$baselinePath = Join-Path $toolRoot 'diagrams\visual-baseline.json'
$outputRoot = Join-Path $toolRoot 'diagrams\output'
$receiptRoot = Join-Path $toolRoot 'diagrams\receipts'
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

$architectureSource = Join-Path $toolRoot 'diagrams\sources\konnect-runtime.architecture.json'
$architecture = Get-Content -LiteralPath $architectureSource -Raw | ConvertFrom-Json
if ($architecture.meta.repository.revision -ne $revision) {
    throw "The architecture source pins $($architecture.meta.repository.revision), but Konnect is at $revision. Review source drift and update the affected diagram specifications before regeneration."
}

$baseline = Get-Content -LiteralPath $baselinePath -Raw | ConvertFrom-Json
$items = @(
    @{ Type = 'architecture'; Base = 'konnect-runtime'; Source = $architectureSource; RepositoryEvidence = $true },
    @{ Type = 'workflow'; Base = 'konnect-guarded-pcb-mutation'; Source = (Join-Path $toolRoot 'diagrams\sources\konnect-guarded-pcb-mutation.workflow.json'); RepositoryEvidence = $false },
    @{ Type = 'sequence'; Base = 'konnect-live-pcb-tool-call'; Source = (Join-Path $toolRoot 'diagrams\sources\konnect-live-pcb-tool-call.sequence.json'); RepositoryEvidence = $false },
    @{ Type = 'dataflow'; Base = 'konnect-manufacturing-evidence'; Source = (Join-Path $toolRoot 'diagrams\sources\konnect-manufacturing-evidence.dataflow.json'); RepositoryEvidence = $false },
    @{ Type = 'lifecycle'; Base = 'konnect-schematic-transaction'; Source = (Join-Path $toolRoot 'diagrams\sources\konnect-schematic-transaction.lifecycle.json'); RepositoryEvidence = $false }
)

New-Item -ItemType Directory -Path $outputRoot -Force | Out-Null
New-Item -ItemType Directory -Path $receiptRoot -Force | Out-Null
$results = @()

foreach ($item in $items) {
    $extra = @()
    if ($item.RepositoryEvidence) {
        $extra = @('--repo-root', $konnectRoot)
    }

    $validationArgs = @($cli, 'validate', $item.Type, $item.Source, '--quality', 'showcase', '--json') + $extra
    $validationText = (& node @validationArgs | Out-String).Trim()
    if ($LASTEXITCODE -ne 0) {
        throw "Validation failed for $($item.Base):`n$validationText"
    }
    (ConvertTo-PublicReceipt $validationText) | Set-Content -LiteralPath (Join-Path $receiptRoot "$($item.Base).validation.json") -Encoding utf8

    $outputPath = Join-Path $outputRoot "$($item.Base).html"
    $deliveryArgs = @($cli, 'deliver', $item.Type, $item.Source, $outputPath, '--quality', 'showcase', '--json') + $extra
    $deliveryText = (& node @deliveryArgs | Out-String).Trim()
    if ($LASTEXITCODE -ne 0) {
        throw "Delivery failed for $($item.Base):`n$deliveryText"
    }
    (ConvertTo-PublicReceipt $deliveryText) | Set-Content -LiteralPath (Join-Path $receiptRoot "$($item.Base).delivery.json") -Encoding utf8

    $visualText = (& node $cli visual-check $outputPath --json | Out-String).Trim()
    $visualExit = $LASTEXITCODE
    $visualReceipt = $visualText | ConvertFrom-Json
    (ConvertTo-PublicReceipt $visualText) | Set-Content -LiteralPath (Join-Path $receiptRoot "$($item.Base).visual-check.json") -Encoding utf8

    $acceptedVisual = $visualExit -eq 0
    $visualStatus = if ($acceptedVisual) { 'pass' } else { 'fail' }
    if (-not $acceptedVisual -and $VisualPolicy -eq 'baseline') {
        $diagramBaseline = $baseline.diagrams.($item.Base)
        $onlyVerticalOverflow = @($visualReceipt.diagnostics | Where-Object { $_.code -ne 'viewer/viewport-overflow' }).Count -eq 0
        $supportingChecksPass = $visualReceipt.readability.status -eq 'pass' -and $visualReceipt.captures.status -eq 'pass' -and $visualReceipt.viewerChrome.status -eq 'pass'
        $withinBaseline = $true
        foreach ($viewport in $visualReceipt.containment.viewports) {
            $key = "$($viewport.width)x$($viewport.height)"
            $limit = $diagramBaseline.maxScrollHeight.$key
            if ($viewport.overflowX -or $null -eq $limit -or $viewport.scrollHeight -gt $limit) {
                $withinBaseline = $false
            }
        }
        $acceptedVisual = -not $diagramBaseline.strict -and $onlyVerticalOverflow -and $supportingChecksPass -and $withinBaseline
        if ($acceptedVisual) {
            $visualStatus = 'known-readable-scroll'
        }
    }

    if (-not $acceptedVisual) {
        throw "Visual evidence for $($item.Base) does not satisfy the '$VisualPolicy' policy. The Archify receipt remains '$($visualReceipt.status)'."
    }

    $results += [pscustomobject]@{
        Diagram = $item.Base
        Validation = 'pass'
        Delivery = 'pass'
        Visual = $visualStatus
    }
}

$results | Format-Table -AutoSize
Write-Output "Konnect revision: $revision"
Write-Output "Visual policy: $VisualPolicy"
