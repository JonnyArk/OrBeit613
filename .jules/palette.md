## 2026-11-11 - Accessible Icon Buttons in Flutter
**Learning:** Custom UI components in this app frequently use icon-only GestureDetector widgets (e.g., in TaskListPanel and ReminderBanner), which lack keyboard focus states, clear tap feedback, and screen reader labels.
**Action:** Replace icon-only GestureDetector widgets with IconButton using tooltip for semantics, padding: EdgeInsets.zero, and constraints: const BoxConstraints() to provide native accessibility without altering the visual layout.
