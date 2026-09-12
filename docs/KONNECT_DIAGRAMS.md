# Konnect architecture diagrams

This repository keeps architecture visualization separate from Konnect's Rust
runtime and KiCad integration. It vendors Archify v2.16.0 as a documentation
build tool and produces five self-contained HTML files that Konnect can publish
or open without Node.js, a web server, or an Archify installation.

## What the set explains

- Runtime architecture: MCP request dispatch, on-demand tools, schematic/file
  operations, live KiCad IPC, and independent `kicad-cli` checks.
- Guarded PCB mutation: live-board identity, IPC commit, bounded file fallback,
  and fail-closed refusal paths.
- Live PCB sequence: the request/return chain for one observed tool call.
- Manufacturing evidence: ERC, DRC, BOM, release packaging, and the separate
  fabrication preview boundary.
- Schematic transaction lifecycle: journal-before-write, recovery, divergence,
  and explicit abandonment.

The HTML viewer contains its own CSS, JavaScript, SVG, theme controls, guided
views, search, pan/zoom, presentation mode, and exports. Opening a file in a
modern browser is sufficient.

## Sources and evidence

Typed JSON under `diagrams/sources/` is authoritative. The architecture source
records the exact Konnect repository URL and revision used for the review. The
other modes express focused views of the same evidence base. Relevant source
material includes Konnect's architecture, tool-development, troubleshooting,
and JLCPCB correction documentation plus the implementation paths they name.

Archify validates geometry and artifact integrity; it cannot prove that an
architectural interpretation is complete. A refresh therefore begins by
reviewing the Git change range since the pinned Konnect revision.

## Reproducible refresh

The project skill `.codex/skills/konnect-archify-refresh/` records the evidence
map and update decisions. Its PowerShell script validates and delivers all five
sources, writes SHA-256 receipts, runs browser checks, and compares visual
results with `diagrams/visual-baseline.json`.

From the installed skill or its repository copy:

```powershell
pwsh -File .\.codex\skills\konnect-archify-refresh\scripts\Refresh-KonnectDiagrams.ps1 `
  -ToolRepo C:\path\to\konnect-archify-tool `
  -KonnectRepo C:\path\to\Konnect
```

Use `-VisualPolicy strict` to require Archify's no-scroll result at every tested
desktop size. The default project baseline is intentionally transparent: the
raw visual-check receipt remains failed when a detailed page scrolls, while the
wrapper accepts only known vertical overflow with passing readability,
viewer-chrome, and capture checks. Any horizontal overflow or larger scroll
height is a regression.

## Konnect integration

Konnect should contain only the delivered HTML files and a short documentation
index. The generator, typed sources, receipts, screenshots, and local refresh
skill remain here. This keeps Konnect's build, dependencies, releases, and MCP
runtime unchanged.

## Verification boundaries

These diagrams document behavior. They do not replace KiCad rendering, ERC,
DRC, connectivity inspection, PCB layout-physics review, or manufacturing
acceptance. In particular, clean structural checks and a complete upload
package do not validate fabrication-house component models or placements.
