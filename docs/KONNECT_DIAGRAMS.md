# Konnect architecture diagrams

This repository keeps architecture visualization separate from Konnect's Rust
runtime and KiCad integration. It vendors Archify v3.0.1 as a documentation
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
map and update decisions. Its PowerShell script finalizes all five sources,
writes portable SHA-256 receipts, runs browser checks, and captures four visual
viewports per diagram under `diagrams/evidence/archify-3.0.1/`.

From the installed skill or its repository copy:

```powershell
pwsh -File .\.codex\skills\konnect-archify-refresh\scripts\Refresh-KonnectDiagrams.ps1 `
  -ToolRepo C:\path\to\konnect-archify-tool `
  -KonnectRepo C:\path\to\Konnect
```

Use `-VisualPolicy strict` to reject Archify's readable-scroll allowance. The
current five-diagram set passes that stricter condition: all required light and
dark desktop captures are contained without horizontal or vertical scroll.

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
