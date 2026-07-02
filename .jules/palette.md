## 2026-07-02 - Replace GestureDetector with IconButton for close icons
**Learning:** Using `GestureDetector` around an `Icon` lacks proper accessibility semantics, keyboard focus, and visual tap feedback.
**Action:** Replace `GestureDetector` with `IconButton` and use `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to prevent layout breakage while ensuring accessibility requirements are met.
