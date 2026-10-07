## 2024-10-24 - Accessible Interactive Icons
**Learning:** Icon-only `GestureDetector` widgets in Flutter lack built-in semantic labels, keyboard focus indicators, and screen reader announcements, creating an inaccessible experience.
**Action:** Always replace icon-only `GestureDetector` widgets with `IconButton`. Use `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to maintain the original layout, and ensure a meaningful `tooltip` is provided for accessibility.
