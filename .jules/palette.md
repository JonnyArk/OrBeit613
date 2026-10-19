## 2024-10-19 - Accessible Icon Buttons
**Learning:** Icon-only `GestureDetector` widgets used for tight layouts lack keyboard accessibility, focus states, and screen reader labels.
**Action:** Replace icon-only `GestureDetector` widgets with `IconButton` using `tooltip`, `padding: EdgeInsets.zero`, and `constraints: const BoxConstraints()` to preserve visual layout while providing native accessibility.
