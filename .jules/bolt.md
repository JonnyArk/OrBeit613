## 2026-05-12 - Cap Animation Delays in Virtualized Lists
**Learning:** Using raw item indices for staggered animation delays in `ListView.builder` or dynamically generated long lists causes massive visual delays for items rendered later, making the app feel slow and unresponsive when scrolling.
**Action:** Always cap the delay index using `math.min(index, 10)` (via `dart:math`) so that lazily loaded or deeply scrolled items animate promptly upon entering the viewport.
