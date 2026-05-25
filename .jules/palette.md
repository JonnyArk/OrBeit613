## 2026-05-25 - Replace GestureDetector with IconButton for Icon-Only Buttons
**Learning:** Icon-only buttons wrapped in `GestureDetector` lack critical accessibility features like ARIA labels (semantics) and hover/focus indicators.
**Action:** Always prefer `IconButton` (adjusting `padding` and `constraints` as needed) to ensure automatic tap ripples, focus states, and tooltips are present.
