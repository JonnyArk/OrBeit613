## 2024-05-24 - Accessible Icon Buttons in Flutter
**Learning:** Discovered a recurring pattern in the app's components where icon-only buttons are built using GestureDetector, which lacks native accessibility features like semantic labels, keyboard focus states, and screen reader support.
**Action:** Replace icon-only GestureDetector widgets with IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), tooltip: '...') to provide native accessibility without altering the established visual layout.
