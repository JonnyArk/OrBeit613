## 2026-02-18 - [Virtualized List Animations]
**Learning:** Naive index-based animation delays (`delay: index * 40ms`) in virtualized lists (like `SliverList`) cause items far down the list to be invisible for seconds when scrolled into view, as the delay is relative to the list start, not the viewport entry.
**Action:** Cap animation delays (e.g., `min(index, 10) * 40ms`) or use viewport-aware animation triggers when working with virtualized scrolling.
