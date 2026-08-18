## 2026-08-18 - Dynamic Semantics for Voice Beacon
**Learning:** AI interfaces like voice beacons that change state visually must wrap their interactive `GestureDetector` in a `Semantics` widget and compute the `label` and `hint` attributes dynamically based on the component's current state to maintain accessibility context for screen readers.
**Action:** Always wrap state-dependent visual and interactive custom components in Flutter with a dynamic `Semantics` widget.
