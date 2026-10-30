## 2024-10-30 - Replace GestureDetector with IconButton
**Learning:** Icon-only `GestureDetector` widgets lack proper semantics and keyboard accessibility.
**Action:** Replace icon-only `GestureDetector` widgets with `IconButton` using `tooltip`, `padding: EdgeInsets.zero`, `constraints: const BoxConstraints()`, and `splashRadius: 16` or similar.
