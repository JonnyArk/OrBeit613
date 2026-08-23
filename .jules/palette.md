
## 2026-08-23 - Dynamic Accessibility Labels for Interactive Elements
**Learning:** AI interface components (like voice beacons) that change visual state must dynamically update their `Semantics` properties (such as `label` and `hint`) based on the component's state to maintain proper accessibility context for screen readers.
**Action:** Always wrap interactive stateful components in a `Semantics` widget and dynamically update its properties based on the component's internal state.
