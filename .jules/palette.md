## 2024-05-28 - Avoid GestureDetector for Icon Buttons
**Learning:** Using `GestureDetector` to wrap an `Icon` creates interactive elements that lack accessibility semantics (like screen reader labels) and standard visual feedback (like Material ripples), degrading the experience for all users.
**Action:** Always prefer `IconButton` with a `tooltip` for interactive icons. If tight packing is needed, use `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` on the `IconButton` instead of falling back to a raw `GestureDetector`.
