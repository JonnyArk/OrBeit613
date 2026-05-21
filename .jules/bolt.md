## 2024-05-21 - Capped Animation Delay for Deep List Items
**Learning:** When virtualizing lists in Flutter with `ListView.builder` and `flutter_animate` staggered delays, using the raw item index for the delay duration causes massive visual delays for lazily loaded items deep in the list.
**Action:** Cap the delay index (e.g., using `min(indexInGroup, 10) * 40` with `dart:math`) to ensure scrolled items appear promptly.
