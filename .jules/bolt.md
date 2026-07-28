## YYYY-MM-DD - Cap Staggered Animation Delay in Lazy Lists
**Learning:** In Flutter, applying unconstrained index-based animation delays (e.g., `delay: index * 50ms`) inside a lazy-loaded `ListView.builder` causes off-screen items to have massive delays when scrolled into view, degrading perceived performance.
**Action:** Always cap the index for animation delays (e.g., `math.min(index, 10) * 50`) in lazy-loaded lists so that initial items stagger correctly but scrolled items appear immediately.
