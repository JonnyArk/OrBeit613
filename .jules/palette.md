## 2024-11-06 - Replace icon-only GestureDetector with IconButton
**Learning:** Using IconButton for icon-only interactive elements in Flutter provides native keyboard accessibility, focus states, clear tap feedback, and screen reader labels via the tooltip property, without requiring complex custom widgets or layout changes when configured with padding: EdgeInsets.zero, constraints: const BoxConstraints(), and an appropriate splashRadius.
**Action:** Always prefer IconButton over GestureDetector for simple icons to ensure proper accessibility and keyboard navigation.
