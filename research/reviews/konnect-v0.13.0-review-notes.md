# Konnect v0.13.0 review publication

Reviewed 2026-10-05. This is a release snapshot, not current main.
Source: https://github.com/mixelpixx/Konnect/tree/6bbe3e4f890ba1d37c0e5d5f38ccd03d90958c9e
Baseline: v0.12.1 at 59a20e5ba93056c82cab4cd2d3c30361a3a0214a.
Diff: 116 commits / 124 changed files.

## Reports

- [Architecture deepening review](../../diagrams/output/konnect-v0.13.0-architecture-review.html): five bounded opportunities; schematic commit/readback sequencing, in-memory placement computation, exact board targeting, installed-guidance reconciliation, footprint transform semantics.
- [Thermonuclear quality review](../../diagrams/output/konnect-v0.13.0-thermonuclear-review.html): independent Spec and Standards findings, actual validation and historical-finding reconciliation.

These are standalone static review reports. No Archify generator, showcase checks or transactional diagram delivery was run or claimed. Existing Archify artifacts were not regenerated.
The standalone thermonuclear skill was unavailable. The saved September full-project review method was repeated with the available code-review skill's independent axes.
Architecture uses improve-codebase-architecture and codebase-design instructions.
No Konnect production code, issue, PR, branch, release or installed binary changed.

## Findings and scope

Spec: manufacturing audit advertised coverage exceeds implementation; rough fixed-average costs remain incomplete against #793 and recommend nonexistent generate_bom; malformed field placements can be silently skipped during a reported successful rotation.
Standards: new KiCAD spelling; rotation preflight/evidence breach (same defect as Spec); stale live/file board-reader inventory.
Observed validation failure: Windows clippy -D warnings rejects ungated REPLACED_BINARY_CHILD test constant at crates/konnect-core/src/router/meta_tools.rs:862.
Inherited risk: bare-PID cleanup in legacy Python plugin remains; coordinate with #731 removal rather than expand plugin ownership.

Do not add these counts together as distinct bugs. The rotation path overlaps both axes.
Source findings are static evidence, not runtime reproductions.
Prefer capability-description correction and narrow no-write refusal over broad manufacturing or recovery expansion.
Old config-overwrite concern is resolved; shared BoardSource materially improves previous live/file source handling.
No line-by-line proof of all changed files, security certification, manufacturing qualification, live-IPC release gate or benchmark is claimed.

## Direct Windows validation

- cargo fmt --all -- --check: PASS, exit 0.
- cargo clippy --workspace --locked --all-targets -- -D warnings: FAIL, exit 1; unused REPLACED_BINARY_CHILD.
- cargo test --workspace --locked --lib --tests: PASS, exit 0. Core suite: 1597 passed, 21 ignored; other suites passed, including real KiCad CLI rendering.
- cargo test --workspace --locked --doc: PASS, exit 0; nine passed and three ignored across workspace.
- Live IPC, full KiCad E2E and benchmark: NOT RUN.
- Rust/Cargo 1.96.0; installed KiCad CLI 10.0.6.
- Exact release checkout remained clean.
