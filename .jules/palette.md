
## 2026-05-23 - Convert icon-only GestureDetectors to IconButtons
**Learning:** Using GestureDetector around an Icon for clickable UI elements results in poor accessibility (no semantic label/tooltip) and poor UX (too small touch targets, no tap ripples).
**Action:** Always prefer IconButton with constraints over GestureDetector for icon-only actions to get automatic tooltips, accessible touch targets, and ink splash feedback.
