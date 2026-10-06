## 2024-05-24 - Accessible Icon Buttons
**Learning:** Icon-only `GestureDetector` widgets lack native keyboard accessibility, focus states, and screen reader labels.
**Action:** Always use `IconButton` (with `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to preserve visual layout) and provide a `tooltip` for semantics.
