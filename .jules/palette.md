## 2024-03-20 - Icon Buttons instead of GestureDetectors wrapping Icons
**Learning:** Found an accessibility pattern where `GestureDetector` wrapped around `Icon` is frequently used in lists. This lacks semantic meaning for screen readers and avoids standard focus/ripple indicators.
**Action:** Replace `GestureDetector` wrapped `Icon` instances with `IconButton` for proper semantic ARIA roles, specifying `tooltip` for semantic labels and `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to maintain visual packing where tight alignment is required.
