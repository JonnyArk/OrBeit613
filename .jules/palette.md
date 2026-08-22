
## 2026-08-22 - Dynamic Semantics for AI Visual Components
**Learning:** AI components with dynamic visual states (like a glowing orb) are completely opaque to screen readers if not properly labeled. Relying on visual changes alone breaks accessibility for visually impaired users who cannot see the "listening" or "speaking" animations.
**Action:** Always wrap stateful, visual AI components (like Voice Beacons) in a `Semantics` widget and dynamically update its properties (like `label` and `liveRegion`) based on the underlying status enum. This ensures the component narrates its current state.
