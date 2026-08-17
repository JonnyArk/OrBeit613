## 2026-08-17 - Dynamic Semantics for AI State Components
**Learning:** AI interface components (like voice beacons) that change state visually must have dynamic semantics labels and hints to maintain accessibility context for screen readers. Static labels do not communicate state changes (e.g., listening vs speaking) to non-visual users.
**Action:** When creating components with interactive states (like `VoiceStatus`), wrap them in a `Semantics` widget and compute the `label` and `hint` attributes dynamically based on the component's current state enum.
