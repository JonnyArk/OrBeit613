## 2026-08-24 - Dynamic Accessibility Context for AI Beacons
**Learning:** In Flutter, AI interface components (like voice beacons) that change visual state must dynamically update their Semantics properties (such as `label` and `hint`) based on the component's state to maintain proper accessibility context for screen readers. Static semantic labels fail to convey the dynamic operational state of AI helpers.
**Action:** Always wrap stateful AI components with a `Semantics` widget and bind its `label` and `hint` properties to a computed getter based on the active state enum.
