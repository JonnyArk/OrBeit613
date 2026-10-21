## 2024-10-21 - Accessible Dismiss Buttons in Banners
**Learning:** In Flutter, using an icon-only `GestureDetector` for dismiss actions (like in a banner) lacks semantics for screen readers and keyboard accessibility.
**Action:** Always replace icon-only `GestureDetector` widgets with an `IconButton` using a descriptive `tooltip`, and set `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to preserve the original visual footprint without layout shifts.
