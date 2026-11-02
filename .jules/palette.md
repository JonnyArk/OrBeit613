## 2024-05-18 - Interactive Icon Accessibility
**Learning:** The codebase frequently uses GestureDetector wrapping an Icon for custom interactive icons, which strips out native keyboard accessibility, focus states, clear tap feedback, and screen reader labels.
**Action:** Use IconButton with padding: EdgeInsets.zero, constraints: const BoxConstraints(), and tooltip to provide native accessibility without altering the tight layout constraints of these components.
