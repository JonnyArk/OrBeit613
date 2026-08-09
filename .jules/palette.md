## 2024-05-18 - Dynamic Semantics for Stateful UI
**Learning:** AI interface components (like voice beacons) that change state visually must wrap their interactive `GestureDetector` in a `Semantics` widget and compute the `label` and `hint` attributes dynamically based on the component's current state to maintain accessibility context for screen readers.
**Action:** Always verify if visual state changes should map to dynamic ARIA labels or `Semantics` attributes in interactive components.
