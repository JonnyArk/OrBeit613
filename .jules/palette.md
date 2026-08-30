## 2026-08-30 - Dynamic Semantics for AI Interfaces
**Learning:** AI interface components (like voice beacons) that change visual state must dynamically update their Semantics properties (such as label and hint) based on the component's state to maintain proper accessibility context for screen readers.
**Action:** Always map the visual state enum to dynamic accessibility labels and hints when building custom interactive components, and wrap the gesture detectors in a Semantics widget.
