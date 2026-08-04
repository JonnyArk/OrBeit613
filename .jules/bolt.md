## 2024-08-04 - Cap Staggered Animations in Lazy Lists
**Learning:** Applying staggered index-based animation delays (e.g., `delay: i * 50ms`) inside a lazy-loaded `ListView.builder` causes off-screen items to have massive multi-second delays when they are scrolled into view because their absolute index is high.
**Action:** When adding staggered entry animations to `ListView.builder`, always cap the multiplier (e.g., using `math.min(index, 10)`) so the initial visible items stagger correctly but newly scrolled items appear immediately.
