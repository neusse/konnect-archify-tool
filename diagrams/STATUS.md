# Konnect diagram status

Evidence source: `neusse/Konnect` revision
`8ed319a3677118e6e056712363cede1adc1245f4`.

| Archify mode | Diagram | Showcase validation | Delivery | Browser visual-check |
| --- | --- | --- | --- | --- |
| Architecture | [Konnect Runtime Architecture](output/konnect-runtime.html) | Pass: 9 checks, 0 errors, 0 warnings | Pass | Pass at all required desktop viewports |
| Workflow | [Konnect Guarded PCB Mutation](output/konnect-guarded-pcb-mutation.html) | Pass: 9 checks, 0 errors, 0 warnings | Pass | Fail: 8 px vertical overflow at 1440x900 |
| Sequence | [Konnect Live PCB Tool Call](output/konnect-live-pcb-tool-call.html) | Pass: 9 checks, 0 errors, 0 warnings | Pass | Fail: vertical overflow at 1440x900 |
| Data flow | [Konnect Manufacturing Evidence Flow](output/konnect-manufacturing-evidence.html) | Pass: 9 checks, 0 errors, 0 warnings | Pass | Fail: vertical overflow at 1440x900 |
| Lifecycle | [Konnect Schematic Transaction Lifecycle](output/konnect-schematic-transaction.html) | Pass: 9 checks, 0 errors, 0 warnings | Pass | Fail: vertical overflow at 1440x900 |

All five artifacts passed automated readability, screenshot capture, and viewer
chrome checks. Light and dark screenshots were visually inspected. The diagrams
are clear at 2048x1320, but the strict no-scroll result above means this project
is not yet ready to push as a fully accepted Archify integration.

The manufacturing evidence diagram deliberately keeps structural release
evidence separate from fabrication-house physical-model preview. It must not be
read as claiming that clean ERC or DRC alone proves manufacturing readiness.
