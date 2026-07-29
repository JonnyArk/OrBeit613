## 2024-05-13 - Staggered Animations in Lazy Lists
**Learning:** Applying a linearly increasing animation delay (e.g., `delay: i * 40ms`) inside a lazy-loaded `ListView.builder` causes items that are initially off-screen to have massive, multi-second delays when scrolled into view.
**Action:** When migrating lists with staggered animations, cap the delay factor (e.g., `math.min(i, 10) * 40`) so initial items stagger correctly but lower items appear instantly upon scroll.
