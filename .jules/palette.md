## 2024-06-16 - Replace GestureDetector with IconButton for close action

**Learning:** Custom icon buttons in Flutter created by wrapping an `Icon` widget in a `GestureDetector` lack proper accessibility semantics, keyboard focus, and visual tap feedback. The `reminder_banner.dart` contained a dismiss button constructed this way, failing accessibility requirements.

**Action:** Replaced the `GestureDetector` pattern with native `IconButton` widgets configured with `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to maintain visual sizing while providing proper ARIA-equivalent semantics, visual feedback, and screen reader labels via `tooltip`.
