# Agent instructions

## Boundary

Treat the Konnect checkout as a read-only evidence source. Write specifications,
artifacts, receipts, screenshots, and notes only in this repository.

## Diagram work

When creating or changing a diagram, read `.agents/skills/archify/SKILL.md`
completely and follow its validation, delivery, and visual-review contract.
Read `docs/WORKFLOW.md` when the task uses Konnect source evidence, updates a
diagram after Konnect changes, or prepares an artifact for publication.
For a scheduled or milestone refresh of the complete five-diagram set, use
`.codex/skills/konnect-archify-refresh/SKILL.md` and its deterministic runner.

## Evidence

Resolve the Konnect checkout's `origin` URL and exact `HEAD` before authorship.
Pin that full commit in `meta.repository`, attach narrowly relevant source paths
to components, and pass the same checkout through `--repo-root` during
validation and delivery. Describe authored interpretation as interpretation;
repository evidence proves referenced revisions and locations, not architectural
completeness.

## Completion

A delivered artifact requires showcase validation with all nine artifact
checks, zero composition errors or warnings, and a successful transactional
delivery. Record browser evidence and report its raw status truthfully. The
project's documented readable-scroll policy may accept a delivered detailed
page for publication, but it never converts a failing Archify visual-check into
a pass.

For commercial or public material, omit third-party brand marks unless their
exact use has been reviewed against the mark owner's terms.
