## 2026-08-26 - Dynamic Accessibility for AI Beacons
**Learning:** In Flutter, AI interface components (like voice beacons) that change visual state must dynamically update their `Semantics` properties (such as `label` and `hint`) based on the component's state to maintain proper accessibility context for screen readers.
**Action:** When creating stateful visual components, bind `Semantics` properties to the same state values that drive visual updates (e.g., changing colors or icons) to ensure assistive technologies reflect the current context.
