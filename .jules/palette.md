## 2026-02-08 - Icon-Only Buttons Accessibility
**Learning:** Icon-only buttons (like task completion circles) are completely invisible to screen readers if not labeled, and lack discoverability without tooltips. A simple `GestureDetector` provides no feedback.
**Action:** Always wrap icon-only interactive elements in `Tooltip` for desktop/hover and `Semantics` with `button: true` and a clear `label`. Use `InkWell` or `IconButton` to provide visual touch feedback (ripples).
