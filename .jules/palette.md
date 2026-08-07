## YYYY-MM-DD - Dynamic Semantics for State-changing AI Components
**Learning:** AI interface components (like voice beacons) that change state visually must have dynamic `label` and `hint` attributes to maintain accessibility context for screen readers.
**Action:** Wrap interactive visual components in a `Semantics` widget and compute semantic properties dynamically based on the component's state.
