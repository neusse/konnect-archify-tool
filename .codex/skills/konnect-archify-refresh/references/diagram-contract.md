# Konnect diagram contract

## Stable set

| Mode | Source | Reader question |
| --- | --- | --- |
| Architecture | `konnect-runtime.architecture.json` | How does an MCP request reach the appropriate KiCad backend and independent checks? |
| Workflow | `konnect-guarded-pcb-mutation.workflow.json` | Which gates allow live IPC mutation, safe file fallback, or refusal? |
| Sequence | `konnect-live-pcb-tool-call.sequence.json` | What happens during one live PCB tool call and observed return? |
| Data flow | `konnect-manufacturing-evidence.dataflow.json` | Which design and check evidence feeds a manufacturing handoff? |
| Lifecycle | `konnect-schematic-transaction.lifecycle.json` | How does a journaled schematic mutation commit, recover, or stop on divergence? |

Keep filenames, IDs, diagram modes, and main reader questions stable across
refreshes. Change topology only when the corresponding Konnect behavior changes.

## Evidence map

Start with these Konnect files, then follow only directly relevant code links:

- `docs/ARCHITECTURE.md`
- `docs/DEVELOPING_TOOLS.md`
- `docs/TROUBLESHOOTING.md`
- `docs/JLCPCB_CPL_CORRECTIONS.md`
- `src/server.rs` and the tool router it invokes
- schematic transaction and PCB IPC/file-backend modules named by the docs

The architecture source pins the exact Konnect commit. Compare that revision to
the refresh target before editing. Unrelated changes do not justify diagram
churn.

## Acceptance truth

- Finalize: validate, transactional delivery, artifact check, and browser-check
  all pass with zero composition errors or warnings.
- Receipts: retain exact source and artifact SHA-256 identities using portable
  repository-root markers.
- Visual evidence: retain the raw Archify status. Baseline policy accepts an
  Archify pass that uses its documented readable-scroll allowance; strict
  policy additionally requires every tested viewport to fit without scrolling.
- Visual inspection: review every light and dark contact-sheet capture. Record
  clipped content, overlaps, weak hierarchy, or unreadable labels as failures.
- Manufacturing boundary: ERC, DRC, BOM, and package structure are evidence;
  fabrication-house model/placement preview remains a separate physical check.
