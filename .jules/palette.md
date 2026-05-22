
## 2026-05-22 - Improved Icon-only Button Accessibility
**Learning:** Custom GestureDetector + Icon combinations for primary actions (like task completion) lack keyboard focus, screen reader labels, and visual tap feedback.
**Action:** Replace GestureDetector with IconButton (using constraints: BoxConstraints() for tight layouts) to automatically gain accessibility semantics, focus states, and tooltips.
