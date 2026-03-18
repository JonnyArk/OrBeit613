## 2024-03-18 - Replacing GestureDetector with IconButton
**Learning:** In Flutter, wrapping an `Icon` with `GestureDetector` to make it clickable creates accessibility issues (no semantic label for screen readers) and lacks visual touch feedback (no ripple effect).
**Action:** Always prefer `IconButton` over `GestureDetector(child: Icon())`. To prevent the `IconButton`'s default large padding from breaking tight UI layouts, use `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()`, along with an explicit `tooltip` for accessibility.
