## 2023-10-27 - Add dynamic semantics to OrBeacon
**Learning:** AI interface components (like voice beacons) that change state visually must have dynamic `Semantics` labels and hints so screen readers have full accessibility context.
**Action:** Always wrap interactive state-changing widgets in `Semantics` and compute the label and hint attributes dynamically based on the current component state.
