## 2024-06-25 - Accessible Close Buttons in Banners
**Learning:** Using `GestureDetector` around a small `Icon` for banner dismiss actions breaks accessibility by removing keyboard focus, native visual feedback (ripple), and screen reader announcements (like "Dismiss reminder button").
**Action:** Replace icon-only `GestureDetector` widgets with `IconButton`, using `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to maintain visual layout while gaining full native accessibility support.
