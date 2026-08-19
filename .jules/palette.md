## 2024-05-24 - Dynamic Semantics for Voice Status Beacon
**Learning:** AI interface components (like voice beacons) that change state visually must wrap their interactive `GestureDetector` in a `Semantics` widget and compute the `label` and `hint` attributes dynamically based on the component's current state (e.g., listening, speaking) to maintain accessibility context for screen readers.
**Action:** Always wrap interactive stateful visual widgets in `Semantics` and provide dynamic contextual hints and labels.
