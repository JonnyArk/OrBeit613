## 2026-05-17 - Cap animation delay for virtualized lists
**Learning:** Using raw indices for `flutter_animate` staggered delays in lazily loaded virtualized lists (`ListView.builder`) causes massive visual delays for items rendered deep in the list, as their calculated delay grows unboundedly.
**Action:** Always cap the stagger delay index (e.g., `min(index, 10)`) to ensure newly scrolled items appear promptly without sacrificing the initial staggered effect.
