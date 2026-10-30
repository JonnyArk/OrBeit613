## 2024-05-18 - Avoid stagger delays in ListView.builder
**Learning:** Index-based stagger delays (e.g., `delay: Duration(milliseconds: i * 40)`) on animations within lazily loaded list items (like those in `ListView.builder` or dynamically built lists) cause visual sluggishness during scrolling as the animation runs every time the item is lazy-loaded into view.
**Action:** Remove index-based stagger delays in dynamically built lists. If stagger animations are needed, use a single initial stagger on load and suppress them on scroll, or remove them entirely for better scrolling performance.

## 2024-05-18 - Optimize heterogeneous lists with ListView.builder
**Learning:** In Flutter, when using `ListView` for long lists (e.g., mixing headers and task items), building the entire list of widgets eagerly can be a performance bottleneck.
**Action:** Instead, flatten the underlying data models into a single linear list (e.g., `List<Object>`) outside the `build()` method or memoize it, and use `ListView.builder` to lazy-load the items as they appear on screen.
