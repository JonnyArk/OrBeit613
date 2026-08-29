## 2026-08-29 - Dynamic Semantics for Stateful AI Components
**Learning:** In Flutter, AI interface components (like voice beacons) that change visual state must dynamically update their Semantics properties (such as label and hint) based on the component's state to maintain proper accessibility context for screen readers.
**Action:** Always wrap interactive stateful AI components in a Semantics widget with dynamically derived label and hint properties that correspond to the current state (e.g. idle, listening, processing).
