
## 2026-05-19 - Cap staggered animation delays in virtualized lists
**Learning:** When virtualizing lists in Flutter with `ListView.builder` and `flutter_animate` staggered delays, using the raw item index for the delay duration causes massive visual delays for lazily loaded items deep in the list.
**Action:** Always cap the delay index (e.g., using `math.min(index, 10) * 40`) to ensure scrolled items appear promptly.
