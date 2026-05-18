## 2026-05-18 - Replaced GestureDetector with IconButton
**Learning:** Using GestureDetector around raw Icons lacks visual tap feedback (ripple effect) and semantic accessibility labels out of the box, leading to a poor UX and a11y.
**Action:** Prefer replacing GestureDetector + Icon combinations with IconButton for icon-only buttons to automatically handle tap ripples, focus indicators, and semantics via the tooltip property.
