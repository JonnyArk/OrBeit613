## 2024-05-30 - Accessible Icon Buttons in Flutter
**Learning:** Using `GestureDetector` around an `Icon` in Flutter lacks keyboard accessibility, screen reader support, and visual touch feedback (ripples).
**Action:** Use `IconButton` with a `tooltip` property to ensure ARIA/Semantics support and built-in interactive feedback. For tight spaces, use `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()`.
