# Konnect diagram status

Evidence source: `mixelpixx/Konnect` revision
`f0f5ad045c97f02f51d1f54efd3965a1aa4e4215`.

| Archify mode | Diagram | Showcase finalize | Browser visual-check |
| --- | --- | --- | --- |
| Architecture | [Konnect Runtime Architecture](output/konnect-runtime.html) | Pass: validate, deliver, check, browser-check | Pass: 4/4 light/dark desktop captures, no scroll |
| Workflow | [Konnect Guarded PCB Mutation](output/konnect-guarded-pcb-mutation.html) | Pass: validate, deliver, check, browser-check | Pass: 4/4 light/dark desktop captures, no scroll |
| Sequence | [Konnect Live PCB Tool Call](output/konnect-live-pcb-tool-call.html) | Pass: validate, deliver, check, browser-check | Pass: 4/4 light/dark desktop captures, no scroll |
| Data flow | [Konnect Manufacturing Evidence Flow](output/konnect-manufacturing-evidence.html) | Pass: validate, deliver, check, browser-check | Pass: 4/4 light/dark desktop captures, no scroll |
| Lifecycle | [Konnect Schematic Transaction Lifecycle](output/konnect-schematic-transaction.html) | Pass: validate, deliver, check, browser-check | Pass: 4/4 light/dark desktop captures, no scroll |

All five artifacts were finalized with Archify v3.0.1. Every finalize gate
passed, every visual-check receipt reports pass at 1440x900 and 2048x1320 in
light and dark themes, and no viewport used the readable-scroll allowance. All
20 screenshots were visually inspected for route clarity, clipping, contrast,
and viewer chrome.

The manufacturing evidence diagram deliberately keeps structural release
evidence separate from fabrication-house physical-model preview. It must not be
read as claiming that clean ERC or DRC alone proves manufacturing readiness.
