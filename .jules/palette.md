## 2024-10-24 - Accessible Icon Buttons in Flutter
**Learning:** In Flutter, icon-only `GestureDetector` widgets lack semantic meaning, keyboard accessibility, and focus states, leading to poor UX for screen reader and keyboard users.
**Action:** Replaced icon-only `GestureDetector` widgets with `IconButton` using `tooltip` for semantics, `padding: EdgeInsets.zero`, and `constraints: const BoxConstraints()` to preserve visual layout while adding full accessibility support.
