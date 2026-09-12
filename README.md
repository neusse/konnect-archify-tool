# konnect-archify-tool

A standalone documentation workspace for producing source-backed diagrams of
[Konnect](https://github.com/mixelpixx/Konnect) without adding Archify or Node.js
to Konnect's runtime, repository, or release packages.

This repository vendors the Archify v2.16.0 Codex skill under
`.agents/skills/archify`. Konnect remains an external, read-only evidence source.

## What belongs here

- Typed Archify JSON specifications under `diagrams/sources/`.
- Validated standalone HTML under `diagrams/output/`.
- Machine-readable validation and visual-check receipts under
  `diagrams/receipts/`.
- Research and adoption notes under `research/`.

This project documents Konnect's software architecture and workflows. It does
not replace KiCad rendering, ERC, DRC, connectivity, layout, or manufacturing
acceptance evidence.

## Requirements

- PowerShell 7+
- Node.js 18+
- A local Konnect checkout

The local Archify runtime has no production npm install step.

## Quick start

Verify the pinned tool:

```powershell
pwsh -File .\scripts\Test-Tool.ps1
```

Validate a diagram against an exact Konnect checkout:

```powershell
pwsh -File .\scripts\Validate-Diagram.ps1 `
  -Type architecture `
  -InputPath .\diagrams\sources\konnect-runtime.architecture.json `
  -KonnectRepo C:\path\to\Konnect
```

Deliver a passing specification:

```powershell
pwsh -File .\scripts\Deliver-Diagram.ps1 `
  -Type architecture `
  -InputPath .\diagrams\sources\konnect-runtime.architecture.json `
  -OutputPath .\diagrams\output\konnect-runtime.html `
  -KonnectRepo C:\path\to\Konnect
```

See [docs/WORKFLOW.md](docs/WORKFLOW.md) for the evidence and acceptance rules.

## Current state

- Local Git repository initialized on `main`.
- Archify v2.16.0 copied project-locally and pinned by `skills-lock.json`.
- Archify doctor passes on this workstation.
- The initial Konnect runtime specification is a draft: its topology passes all
  nine artifact checks, but showcase validation still rejects desktop text
  readability. No HTML has been presented as accepted.

## Licensing

Archify retains its MIT license and third-party notices under
`.agents/skills/archify/`. No license has yet been selected for the original
documentation and scripts in this repository.
