## 2026-02-22 - Flutter List Performance
**Learning:** `ListView(children: ...)` eagerly renders all items, causing performance issues for potentially long lists.
**Action:** Replace with `CustomScrollView` and `SliverList` (using `SliverChildBuilderDelegate`) to enable lazy loading and virtualization. Always cap animation delays (e.g., `(index % 10) * 40`) to prevent long wait times.
