## 2024-05-18 - Replaced icon-only GestureDetector with IconButton
**Learning:** Icon-only GestureDetector widgets lack proper semantics and visual feedback.
**Action:** Always use IconButton instead with tooltip, padding, constraints: BoxConstraints(), and splashRadius for accessibility and keyboard focus support without visual regression.
