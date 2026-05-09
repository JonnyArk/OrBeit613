## 2026-05-09 - Capped ListView Animation Delays
**Learning:** When virtualizing lists in Flutter with `ListView.builder` and `flutter_animate` staggered delays, do not use the raw item index for the delay duration, as it causes massive visual delays for lazily loaded items deep in the list.
**Action:** Cap the delay index (e.g., using `min(indexInGroup, 10) * 40` with `dart:math`) to ensure scrolled items appear promptly.
