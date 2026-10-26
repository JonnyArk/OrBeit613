## 2024-10-26 - Accessible Close Icons
**Learning:** Icon-only `GestureDetector` widgets in Flutter lack native keyboard focus states, hover states, and screen reader labels. This was particularly evident on the close buttons within components like `LifeEventTimeline` and `ReminderBanner`.
**Action:** Replace icon-only `GestureDetector` widgets with `IconButton` widgets. Set the `tooltip` property for screen reader support, and use `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to preserve the original visual sizing and layout.
