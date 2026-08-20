## 2026-08-20 - Dynamic Semantics for Voice Interface Components
**Learning:** AI interface components (like voice beacons) that change state visually must wrap their interactive `GestureDetector` in a `Semantics` widget and compute the `label` and `hint` attributes dynamically based on the component's current state (e.g., listening, speaking).
**Action:** Always wrap `GestureDetector` in `Semantics` and use state variables to provide context-aware labels for screen readers.
