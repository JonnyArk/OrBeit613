## 2024-05-23 - Dynamic Semantics for AI Components
**Learning:** AI interface components (like voice beacons) that change state visually must dynamically update their Semantics properties (label/hint) to maintain accessibility context for screen readers.
**Action:** When creating or updating interactive components with visual state changes, always wrap them in a Semantics widget and compute the label and hint attributes dynamically based on the component's current state.
