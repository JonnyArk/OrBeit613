## 2024-05-18 - Capping staggered animation delays in ListView.builder
**Learning:** Applying staggered index-based animation delays (e.g., `delay: i * 50ms`) inside a lazy-loaded `ListView.builder` causes off-screen items to have massive delays when they are scrolled into view.
**Action:** When migrating or creating such lists, cap the delay (e.g., `math.min(i, 10) * 50`) so that initial items stagger correctly but items scrolled into view appear immediately.
