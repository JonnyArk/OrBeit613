
## 2024-05-24 - Virtualize Heterogeneous Lists
**Learning:** Virtualizing heterogeneous Flutter lists (like those with headers, items, and spacers) cannot be achieved directly with eager `ListView` and complex internal loops without sacrificing memory scaling and performance.
**Action:** Flatten complex UI structures into a single array of wrapped objects with an explicit type enum, and map them inside a lazily evaluated `ListView.builder` or `SliverChildBuilderDelegate`. Remove index-based animation delays as virtualized items should animate immediately when scrolled into view.
