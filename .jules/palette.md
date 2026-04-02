## 2024-04-02 - Icon Buttons vs GestureDetector
**Learning:** Using `GestureDetector` wrapped around an `Icon` creates an inaccessible click target without proper ARIA semantics or visual feedback. This is a common pattern in this app's UI elements.
**Action:** Always prefer `IconButton` with a `tooltip` property to provide semantic labels for screen readers and native touch feedback. For tight spacing, use `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()`.
