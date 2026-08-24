## 2026-08-24 - Bounded Animation Delays in Lazily Loaded Lists
**Learning:** When using staggering animations inside a lazily loaded `ListView.builder`, unbounded index-based delays cause list items scrolled into view to remain invisible for seconds.
**Action:** Always cap the index multiplier when calculating animation delays in `ListView.builder` callbacks to preserve a smooth and responsive scrolling experience.
