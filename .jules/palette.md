## 2024-10-24 - Accessible Icon Buttons
**Learning:** Icon-only `GestureDetector` widgets in Flutter lack native keyboard accessibility, focus states, and screen reader labels.
**Action:** Replace them with `IconButton` using `padding: EdgeInsets.zero`, `constraints: const BoxConstraints()`, and a `tooltip` to provide semantics without altering visual layout.
