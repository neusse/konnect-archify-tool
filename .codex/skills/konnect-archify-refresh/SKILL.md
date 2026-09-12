---
name: konnect-archify-refresh
description: Refresh the stable five-diagram Konnect Archify documentation set from a current Konnect checkout. Use when Konnect architecture, mutation safety, tool-call flow, manufacturing evidence, or transaction recovery has changed and the standalone HTML documentation needs reproducible regeneration; do not use for ordinary KiCad design work.
---

# Konnect Archify Refresh

Regenerate source-backed documentation without adding Archify or Node.js to the
Konnect runtime repository.

## Refresh

1. Locate the `konnect-archify-tool` and Konnect checkouts. Read
   [references/diagram-contract.md](references/diagram-contract.md), the tool
   repository's `AGENTS.md`, and its vendored `.agents/skills/archify/SKILL.md`.
2. Read the pinned revision from
   `diagrams/sources/konnect-runtime.architecture.json`. Compare it with the
   target checkout using `git diff --stat <pinned>..HEAD` and inspect only the
   documentation and implementation that can change one of the five reader
   questions.
3. If relevant behavior changed, update only the affected typed JSON sources.
   Preserve stable IDs and filenames where the represented concept still
   exists. Update the architecture repository revision after the evidence
   review. If no relevant behavior changed, update only the revision pin and
   provenance status.
4. Run the deterministic pipeline:

   ```powershell
   pwsh -File .\scripts\Refresh-KonnectDiagrams.ps1 `
     -ToolRepo C:\path\to\konnect-archify-tool `
     -KonnectRepo C:\path\to\Konnect
   ```

   Use `-VisualPolicy strict` only when the user requires every artifact to fit
   without scrolling. The default baseline policy preserves raw failing
   Archify receipts and accepts only the documented readable vertical-scroll
   envelope; it never labels those receipts as visual-check passes.
5. Inspect every generated light and dark screenshot. The refresh is incomplete
   if content is clipped, relationships overlap nodes, hierarchy is unclear, or
   text is unreadable.
6. Update `diagrams/STATUS.md` with the target revision and observed receipt
   statuses. Report source/artifact hashes and any baseline exception.

## Publishing boundary

Generation changes only `konnect-archify-tool`. Copy delivered standalone HTML
into Konnect only when the user explicitly asks for a Konnect documentation
change. Konnect needs no Node.js dependency to open those files. Create and link
an issue before opening a non-trivial Konnect PR, and preserve unrelated local
changes.
