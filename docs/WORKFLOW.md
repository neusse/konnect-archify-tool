# Konnect documentation workflow

## 1. Bind the evidence source

Run `scripts/Get-Konnect-Revision.ps1` against the intended Konnect checkout.
Use the reported `origin` URL and full commit in the diagram's
`meta.repository`. A dirty checkout is acceptable for exploration, but a
publishable source-backed artifact must describe whether its claims include
uncommitted work; Archify's repository evidence is commit-bound.

## 2. Author one bounded view

Keep each specification focused on one reader question. Prefer 8–12 primary
nodes, one obvious main path, short side branches, and cards for supporting
detail. Place specifications in `diagrams/sources/`.

Useful Konnect views include:

- Runtime architecture from MCP client through the chosen KiCad backend.
- Toolset discovery, loading, dispatch, and failure behavior.
- Schematic mutation and transaction recovery.
- Live PCB mutation and file-fallback safety gates.
- ERC, DRC, review, and manufacturing evidence flow.
- Before/Delta/After views for substantial architectural changes.

## 3. Validate and deliver

Use `scripts/Validate-Diagram.ps1` after every edit. Only a showcase pass with
nine artifact checks, zero composition errors, and zero warnings can advance to
delivery. Use `scripts/Deliver-Diagram.ps1` once for the accepted source.

Keep the three claims separate:

- Delivery proves deterministic artifact checks.
- Visual-check proves bounded browser behavior and containment.
- Human or image-capable review assesses perceptual polish.

Store accepted HTML in `diagrams/output/` and machine receipts in
`diagrams/receipts/`.

## 4. Review truth and drift

Review every node and relationship against the pinned Konnect revision.
Validation cannot prove that an architectural interpretation is complete.
Regenerate or retire diagrams when their source revision no longer represents
the documented behavior.
