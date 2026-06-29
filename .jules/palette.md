## 2024-06-25 - Replace GestureDetector with IconButton for accessible icons
**Learning:** Custom icon buttons built with `GestureDetector` lack accessibility semantics (like tooltips for screen readers) and interactive feedback (like ink splashes).
**Action:** Replace `GestureDetector` wraps with native `IconButton` elements, adding a semantic `tooltip` and using `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to prevent unintended layout expansion.
