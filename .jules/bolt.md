## 2026-05-22 - Capped staggered delays in virtualized lists
**Learning:** Using raw indices for staggered animation delays in ListView causes massive visual delays for lazily loaded items scrolled deep in the list.
**Action:** Always cap the index (e.g., min(index, 10)) when calculating delay durations for list items to ensure they appear promptly upon scrolling.
