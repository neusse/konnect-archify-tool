# Archify assessment for Konnect

Research date: 2026-09-12
Archify `main` examined at: `6db72a9aea3d0f67a6a034e41f8a5491476a11c1`
Konnect local checkout examined at: `8ed319a3677118e6e056712363cede1adc1245f4`

## Bottom line

Yes, we can use Archify with Konnect. The best fit is to install or temporarily invoke it as a **Codex skill** and run it while Codex is working in the Konnect repository. It does not need to be compiled into Konnect, exposed as an MCP tool, or added to the Rust workspace.

Archify is MIT-licensed and its license expressly permits use, modification, distribution, sublicensing, and sale. There is no Archify license fee or required Archify hosted service in the repository's documented workflow. The practical prerequisites are Node.js 18 or later and an already-available compatible coding agent. The current workstation has Node.js `v24.15.0`, so it satisfies Archify's runtime requirement.

My recommendation is **pilot it, but do not make it a Konnect runtime dependency**. It could be useful for high-level software architecture, MCP request flows, tool-loading workflows, KiCad integration boundaries, and Before/Delta/After design reviews. It is not a KiCad schematic/PCB tool and adds no electrical, ERC, DRC, connectivity, fabrication, or layout-physics validation.

## What Archify is

Archify is an agent-facing Node.js renderer and validator. An agent authors a typed JSON intermediate representation and Archify deterministically compiles it to a self-contained HTML/SVG artifact. Its supported diagram types are architecture, workflow, sequence, data flow, and lifecycle. Generated viewers can provide search, focus, authored relationship tracing, guided views, presentation mode, and static/motion exports. ([README](https://github.com/tt-a1i/archify/blob/6db72a9aea3d0f67a6a034e41f8a5491476a11c1/README_EN.md), [skill contract](https://github.com/tt-a1i/archify/blob/6db72a9aea3d0f67a6a034e41f8a5491476a11c1/archify/SKILL.md))

The basic flow is:

1. Codex examines a repository or receives a bounded system description.
2. Codex authors Archify JSON according to the selected diagram schema.
3. The local Node.js CLI validates schema and geometry and renders a standalone HTML artifact.
4. Optional repository evidence can be checked against the Git origin, commit, blobs, files, and line ranges for architecture diagrams.
5. Optional browser checking records bounded behavior evidence, while perceptual review remains a separate human or image-review step.

The repository describes this as a portable, local artifact workflow rather than a hosted diagram editor. ([Authoring cookbook](https://github.com/tt-a1i/archify/blob/6db72a9aea3d0f67a6a034e41f8a5491476a11c1/docs/authoring-cookbook.md), [product contract](https://github.com/tt-a1i/archify/blob/6db72a9aea3d0f67a6a034e41f8a5491476a11c1/PRODUCT.md))

## License, commercial use, and purchases

### Archify itself

- **License:** MIT.
- **Commercial use:** Permitted. The license explicitly permits using, modifying, publishing, distributing, sublicensing, and selling copies.
- **Conditions:** Preserve the copyright and permission notice in copies or substantial portions.
- **Warranty/support:** None is promised by the license; the software is supplied “as is.”
- **Required purchase:** None found for Archify itself.

Primary source: [Archify LICENSE](https://github.com/tt-a1i/archify/blob/6db72a9aea3d0f67a6a034e41f8a5491476a11c1/LICENSE).

### Runtime and service costs

- The packaged skill requires **Node.js 18+**. Its `package.json` declares no production dependencies; AJV, parse5, saxes, and Simple Icons appear only as development dependencies used to generate/check shipped material. The shipped runtime uses standalone validators. ([package.json](https://github.com/tt-a1i/archify/blob/6db72a9aea3d0f67a6a034e41f8a5491476a11c1/archify/package.json), [roadmap](https://github.com/tt-a1i/archify/blob/6db72a9aea3d0f67a6a034e41f8a5491476a11c1/ROADMAP.md))
- The optional automated `visual-check` needs a locally installed Google Chrome or Chromium executable. Ordinary render/validate/deliver use does not depend on a browser automation package. ([visual-check implementation](https://github.com/tt-a1i/archify/blob/6db72a9aea3d0f67a6a034e41f8a5491476a11c1/archify/bin/visual-check.mjs#L75-L128))
- There is no required Archify cloud account or hosted backend. The delivered HTML is self-contained. ([README](https://github.com/tt-a1i/archify/blob/6db72a9aea3d0f67a6a034e41f8a5491476a11c1/README_EN.md), [product contract](https://github.com/tt-a1i/archify/blob/6db72a9aea3d0f67a6a034e41f8a5491476a11c1/PRODUCT.md))
- Archify may make a periodic GET request to a fixed stable manifest for update notices. The README says it sends no version, agent, project, prompt, account/device identifier, or ETag; it can be disabled with `ARCHIFY_UPDATE_CHECK_DISABLED=1`. It does not auto-install updates. ([README update-check disclosure](https://github.com/tt-a1i/archify/blob/6db72a9aea3d0f67a6a034e41f8a5491476a11c1/README_EN.md#quick-start))
- A compatible agent such as Codex supplies the reasoning and authors the JSON. Any existing Codex subscription/API cost is external to Archify, not an Archify purchase.
- Supercode is named as a sponsor, not a required dependency or purchase. The DeepSeek Harness integration is also optional. ([README](https://github.com/tt-a1i/archify/blob/6db72a9aea3d0f67a6a034e41f8a5491476a11c1/README_EN.md))

### Important commercial-use caveat: bundled brand marks

Archify's MIT license covers its own code and content, but the repository explicitly warns that third-party logos remain subject to their own copyright, trademark, and brand rules. Of particular note, the bundled Vue.js artwork is recorded as `CC-BY-NC-SA-4.0`, which carries non-commercial and share-alike conditions. Other marks have attribution or trademark constraints. For commercial Konnect material, the safe default is to omit third-party brand marks unless their exact intended use has been cleared. ([Third-party notices](https://github.com/tt-a1i/archify/blob/6db72a9aea3d0f67a6a034e41f8a5491476a11c1/THIRD_PARTY_NOTICES.md))

This is a licensing caution, not legal advice.

## How it would fit Konnect

The local Konnect documentation describes a Rust MCP server whose client talks to the `konnect` binary; that binary routes MCP calls through `McpHandler`, domain handlers, KiCad access layers, and a thin Python KiCad launcher plugin. Konnect already installs client guidance/skills separately from MCP server startup. ([Konnect developer overview](https://github.com/neusse/Konnect/blob/8ed319a3677118e6e056712363cede1adc1245f4/docs/DEVELOPER_OVERVIEW.md), [Konnect architecture](https://github.com/neusse/Konnect/blob/8ed319a3677118e6e056712363cede1adc1245f4/docs/ARCHITECTURE.md), [Konnect README](https://github.com/neusse/Konnect/blob/8ed319a3677118e6e056712363cede1adc1245f4/README.md))

That makes Archify a natural **authoring-time companion**:

```text
Codex examines Konnect source/docs
        |
        v
Codex authors typed Archify JSON
        |
        v
local Archify Node CLI validates and renders
        |
        v
self-contained HTML/SVG diagram for docs or review
```

It should stay outside this runtime path:

```text
MCP client -> konnect binary -> MCP routing/domain logic -> KiCad integrations
```

Archify is neither an MCP server nor a KiCad integration. Adding it to the Rust server would couple production/plugin packaging to Node.js without improving Konnect's KiCad operations.

### Sensible uses

- A source-backed high-level map of `crates/konnect`, `crates/konnect-core`, KiCad adapters, IPC/file access, the ActionPlugin bridge, and packaging.
- A sequence diagram of `tools/call` through tool discovery/loading, routing, mutation gating, and the selected KiCad backend.
- Workflow diagrams for schematic authoring, PCB routing, manufacturing export, or contributor/release procedures.
- Data-flow diagrams showing MCP JSON, local project files, KiCad IPC/file adapters, revision evidence, and generated manufacturing artifacts.
- Before/Delta/After maps for major architectural PRs, with the important limitation that Archify reports authored structural changes rather than automatically inferring risk or merge safety.
- More presentable maintainer/onboarding artifacts than plain-text diagrams, while keeping a reviewable JSON source and deterministic validation receipt.

### Poor fits / non-goals

- Rendering or editing `.kicad_sch` or `.kicad_pcb` files.
- Replacing Konnect's schematic/PCB overlap checks, ERC/DRC, connectivity checks, transaction safeguards, manufacturing checks, or rendered KiCad inspection.
- Automatically discovering a complete, unquestionably correct architecture. The agent still decides what nodes and relationships to author; source evidence verifies referenced files/revisions, not every architectural interpretation.
- Acting as a product capability contract or roadmap. A polished map can communicate a system, but it does not prove that an advertised end-to-end workflow is complete.
- WYSIWYG editing, hosted collaboration, general-purpose auto-layout, or automatic Mermaid parsing; the project lists these outside its current scope. ([README scope](https://github.com/tt-a1i/archify/blob/6db72a9aea3d0f67a6a034e41f8a5491476a11c1/README_EN.md#reference-and-scope))

## Integration choices

### Recommended: temporary pilot

Run from the Konnect checkout without permanently integrating it:

```powershell
npx skills use tt-a1i/archify@archify --agent codex
```

Then ask Codex for one bounded, source-backed architecture diagram of Konnect with roughly 8–12 core components and one primary runtime path. This is the lowest-commitment way to judge output quality. The temporary-use command is documented by Archify. ([README quick start](https://github.com/tt-a1i/archify/blob/6db72a9aea3d0f67a6a034e41f8a5491476a11c1/README_EN.md#quick-start))

### If the pilot succeeds: install as a Codex skill

```powershell
npx skills add tt-a1i/archify -g
```

Archify documents Codex CLI skill installation under `~/.agents/skills/`. Keeping it there lets Codex use it across repositories and avoids changing Konnect's runtime or release packages. ([README installation options](https://github.com/tt-a1i/archify/blob/6db72a9aea3d0f67a6a034e41f8a5491476a11c1/README_EN.md#installation-options))

The examined `main` branch identifies itself as `v2.17.0-dev.1`, while GitHub identifies `v2.16.0` as the latest immutable release and shows continued commits after it. For repeatable Konnect documentation, prefer a pinned released Archify version or archive instead of silently tracking the fast-moving development branch. ([v2.16.0 release](https://github.com/tt-a1i/archify/releases/tag/v2.16.0), [development package version](https://github.com/tt-a1i/archify/blob/6db72a9aea3d0f67a6a034e41f8a5491476a11c1/archify/package.json#L1-L12))

### Not recommended initially: bundle it with Konnect

Konnect already has a curated skill installer. Bundling Archify there would require decisions about vendor updates, licensing notices, package size, client-specific installation, tests, documentation, and whether Konnect maintainers want to support a separate Node-based visualization system. That overhead is unjustified until repeated real use shows that Archify artifacts are worth maintaining.

## Usefulness assessment

| Area | Likely value | Assessment |
|---|---:|---|
| Maintainer onboarding | High | Konnect has multiple Rust crates, adapters, plugin code, transports, and packaging boundaries that suit a compact architecture map. |
| Architecture review | High | Typed JSON, deterministic validation, source-pinned evidence, and Before/Delta/After views are useful for major refactors. |
| User documentation | Medium | Attractive standalone artifacts can explain workflows, but interactive HTML may not belong in every docs host and must be regenerated as code changes. |
| Release/PR communication | Medium to high | Share cards and focused route/reach views can communicate a bounded change clearly. |
| Day-to-day KiCad design | Low | It does not understand or validate electrical/PCB design artifacts. |
| Production Konnect runtime | None | It should not sit in the MCP/KiCad execution path. |

The main ongoing cost is not licensing; it is **truth maintenance**. A diagram can pass schema and geometry checks while still being incomplete or semantically wrong if the agent authored the wrong boundaries. Source-pinned evidence reduces drift and improves auditability, but maintainers still need to review scope and meaning and regenerate diagrams after relevant architecture changes.

## Recommendation

Proceed with a small, reversible evaluation:

1. Use the temporary command rather than changing Konnect.
2. Produce one source-backed Architecture artifact for Konnect's MCP-to-KiCad runtime path.
3. Compare it against `docs/DEVELOPER_OVERVIEW.md` and `docs/ARCHITECTURE.md` for accuracy, readability, and maintenance burden.
4. Accept it only if it adds comprehension beyond the existing text diagrams and if its JSON source is understandable enough for maintainers to update.
5. If successful, install Archify globally as a Codex skill. Do not bundle it into the Konnect binary or PCM package.

Overall judgment: **useful optional documentation/review tooling, worth a pilot; not a Konnect feature or dependency. No Archify purchase is required, with third-party logo rights as the one commercial-use caveat to manage.**
