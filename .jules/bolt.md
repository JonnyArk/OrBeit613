## 2026-05-16 - Flutter Animate List View Delay Cap
**Learning:** Using raw item indices for staggered animation delays in `ListView.builder` causes massive visual delays for lazily loaded items deep in the list.
**Action:** Cap the delay index using `math.min(index, 10)` to ensure scrolled items appear promptly without losing the staggered effect for the initial load.
