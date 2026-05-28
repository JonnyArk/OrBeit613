## 2026-05-28 - Replace GestureDetector with IconButton for Semantic Roles
**Learning:** Using GestureDetector around raw Icons removes built-in accessibility features (like tap targets, semantics labels, and focus indicators). IconButton natively provides these features and its tooltip acts as the screen reader label.
**Action:** Always prefer IconButton over GestureDetector + Icon for icon-only buttons, adjusting padding and constraints if needed to maintain visual dimensions.
