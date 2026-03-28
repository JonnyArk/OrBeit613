
## 2024-05-28 - Virtualize Virtualizing heterogeneous Flutter lists
**Learning:** Virtualizing heterogeneous Flutter lists (e.g., grouped lists with section headers and items) using `ListView.builder` requires flattening the grouped data structure into a single array of wrapped objects with an explicit type enum to allow the builder to dynamically render the correct widget per index.
**Action:** When virtualizing heterogeneous lists, use an explicit type enum and wrapper class to flatten the data structure and enable dynamic widget rendering per index. Avoid using eager `ListView`s for long or unbounded lists, as they instantiate all widgets upfront, degrading performance.
