## 2024-05-24 - Accessibility labels for custom IconButtons
**Learning:** Found custom `GestureDetector` based icon-only buttons (`radio_button_unchecked`, `close`) in the Flutter app's UI elements (`task_list_panel`, `reminder_banner`). These lacked semantic information, making them inaccessible to screen readers as interactive buttons.
**Action:** When implementing custom icon-only buttons with `GestureDetector`, always wrap the interactive element in `Semantics(button: true, label: 'Descriptive Action')` to ensure screen readers announce them properly as buttons with their intended action.
