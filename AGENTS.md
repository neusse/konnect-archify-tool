# Agent instructions

## Boundary

Treat the Konnect checkout as a read-only evidence source. Write specifications,
artifacts, receipts, screenshots, and notes only in this repository.

## Diagram work

When creating or changing a diagram, read `.agents/skills/archify/SKILL.md`
completely and follow its validation, delivery, and visual-review contract.
Read `docs/WORKFLOW.md` when the task uses Konnect source evidence, updates a
diagram after Konnect changes, or prepares an artifact for publication.

## Evidence

Resolve the Konnect checkout's `origin` URL and exact `HEAD` before authorship.
Pin that full commit in `meta.repository`, attach narrowly relevant source paths
to components, and pass the same checkout through `--repo-root` during
validation and delivery. Describe authored interpretation as interpretation;
repository evidence proves referenced revisions and locations, not architectural
completeness.

## Completion

A deliverable is complete only when showcase validation passes with all nine
artifact checks, delivery exits zero, browser evidence is recorded, and visual
review status is reported truthfully. Preserve a failing specification as a
draft and keep its generated output out of accepted documentation.

For commercial or public material, omit bundled third-party brand marks unless
their exact use has been reviewed against `.agents/skills/archify/THIRD_PARTY_NOTICES.md`.
