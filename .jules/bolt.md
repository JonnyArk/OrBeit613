## 2026-05-13 - Cap flutter_animate delays in virtualized lists
**Learning:** When using `flutter_animate` with `ListView.builder` or long loops, using the raw item index for the delay duration (e.g., `index * 50ms`) causes massive visual delays for lazily loaded items deep in the list, making the UI appear unresponsive.
**Action:** Always cap the delay index using `dart:math`'s `min` function (e.g., `min(index, 10) * 50`) to ensure scrolled items appear promptly while preserving the staggered effect for the initial view.
