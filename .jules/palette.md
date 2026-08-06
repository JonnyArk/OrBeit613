## YYYY-MM-DD - Dynamic Semantics for Voice Beacons
**Learning:** AI interface components (like voice beacons) that change state visually must have their semantic labels and hints updated dynamically based on the component's current state (e.g., listening, speaking).
**Action:** Always wrap interactive visual AI elements in a `Semantics` widget and compute the `label` and `hint` attributes dynamically based on state to maintain accessibility context for screen readers.
