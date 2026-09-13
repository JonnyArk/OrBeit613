## 2024-09-13 - Capping Staggered Animations in Lazy Lists
**Learning:** Using a linear delay based on `index` (e.g. `index * 50ms`) in a `ListView.builder` causes massive delays for items lazily loaded far down the list. This defeats the performance benefits of lazy loading and creates visual glitches where items pop in.
**Action:** Cap the stagger delay conditionally based on the list position (e.g. `index < 10`) so that only initial visible items animate sequentially, while off-screen items appear immediately when scrolled into view.
