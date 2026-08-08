## YYYY-MM-DD - AI Component Accessibility
**Learning:** AI interface components (like voice beacons) that change state visually must wrap their interactive `GestureDetector` in a `Semantics` widget and compute the `label` and `hint` attributes dynamically based on the component's current state (e.g., listening, speaking) to maintain accessibility context for screen readers.
**Action:** When migrating or creating stateful interactive components that lack visual labels, always wrap them in a `Semantics` widget with dynamically computed attributes based on state, and set `button: true`.
