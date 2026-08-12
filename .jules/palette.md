## 2024-08-12 - Dynamic Semantics for AI Components
**Learning:** AI interface components (like voice beacons) that change state visually must compute semantic labels dynamically based on their state to maintain accessibility context for screen readers.
**Action:** When creating or modifying stateful visual components, always wrap their interactive detectors in a `Semantics` widget and dynamically compute `label` and `hint` attributes based on the current state.
