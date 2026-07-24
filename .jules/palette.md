## YYYY-MM-DD - Accessible Icon-only Gestures in Flutter
**Learning:** In Flutter, `GestureDetector` does not provide implicit semantics for accessibility tools (like screen readers). When using it for icon-only interactive elements (like close buttons or custom radio buttons), the element remains silent to assistive technologies, causing a poor accessibility experience.
**Action:** Always wrap icon-only `GestureDetector` elements in a `Semantics` widget with an appropriate descriptive `label` and `button: true` to ensure they are properly announced by screen readers as interactive buttons.
