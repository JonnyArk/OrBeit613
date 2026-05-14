## 2026-05-14 - ListView staggered animation delay
**Learning:** Using the raw item index for `flutter_animate` delays inside a lazily loaded `ListView.builder` causes massive visual delays (e.g., seconds) for items deep in the list as the user scrolls.
**Action:** Cap the delay index using `math.min(index, 10)` to ensure scrolled items appear promptly.
