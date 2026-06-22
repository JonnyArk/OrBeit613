## 2024-06-22 - Replaced GestureDetector Icon with IconButton for A11y
**Learning:** Small custom tap targets like a `GestureDetector` wrapping an `Icon` lack ARIA equivalents, visual tap feedback, and are difficult for screen readers to interpret.
**Action:** Replace these with native `IconButton` widgets using the `tooltip` property to provide context. Ensure `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` are applied to avoid breaking the existing UI layout.
