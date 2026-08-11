## 2024-08-11 - Dynamic Semantics for Stateful AI Components
**Learning:** In Flutter, AI interface components (like voice beacons) that change state visually rely heavily on visual cues (glows, ripples, colors) which are completely inaccessible to screen readers.
**Action:** Always wrap interactive `GestureDetector` widgets in AI components with a `Semantics` widget, and compute the `label` and `hint` attributes dynamically based on the component's current state (e.g., listening, speaking, idle) to maintain context for visually impaired users.
