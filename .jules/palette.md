## 2024-05-24 - Accessible Icon Buttons in Flutter
**Learning:** Using GestureDetector for icon-only actions lacks native accessibility features like semantic labels, keyboard focus, and screen reader feedback.
**Action:** Replace icon-only GestureDetector widgets with IconButton using a descriptive tooltip, padding: EdgeInsets.zero, constraints: const BoxConstraints(), and splashRadius: 16 to preserve layout while gaining native accessibility.
