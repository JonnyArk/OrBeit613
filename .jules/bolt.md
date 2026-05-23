## 2026-05-23 - Cap staggered animation delays in lazy lists
**Learning:** Using raw indices for staggered animation delays in lazy-loaded lists (like ListView.builder) causes items deep in the list to have massive visual delays before appearing when scrolled into view.
**Action:** Always cap the delay index (e.g., `min(index, 10)`) when using `flutter_animate` in virtualized lists to ensure scrolled items appear promptly.
