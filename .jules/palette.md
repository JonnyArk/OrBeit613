## 2024-08-14 - Add semantics to OrBeacon for accessibility
**Learning:** Flutter's AI interface components (like voice beacons) that change state visually should wrap their interactive `GestureDetector` in a `Semantics` widget and compute the `label` and `hint` attributes dynamically based on the component's current state to maintain accessibility context for screen readers.
**Action:** Always ensure custom interactive UI widgets with dynamic state include a `Semantics` wrapper with context-aware labels.
