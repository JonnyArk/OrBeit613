## 2024-05-24 - Flutter Icon Button Semantics
**Learning:** The Flutter app extensively uses `GestureDetector` wrapped around an `Icon` for custom icon buttons (e.g., in `reminder_banner.dart`, `task_list_panel.dart`). This strips the buttons of native semantic meaning, keyboard focusability, and visual tap feedback.
**Action:** Replace these custom implementations with the native `IconButton`, adjusting `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to match the original compact visual footprint while regaining accessibility features.
