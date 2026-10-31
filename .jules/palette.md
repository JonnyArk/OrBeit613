## 2024-03-24 - Accessibility for icon-only buttons
**Learning:** Using GestureDetector for icon-only buttons removes native keyboard accessibility, focus states, and screen reader labels.
**Action:** Replace icon-only GestureDetector widgets with IconButton using tooltip for semantics, padding: EdgeInsets.zero, constraints: const BoxConstraints(), and an appropriate splashRadius (e.g., 16).
