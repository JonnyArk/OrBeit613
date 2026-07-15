## YYYY-MM-DD - ListView.builder Heterogeneous Lists
**Learning:** Eagerly instantiating items in `ListView` limits scroll performance. We can't just pass `children` to `ListView.builder` directly. To maintain lazy-loading benefits, data structures need to be flattened (e.g., an array of maps) to instantiate the widgets dynamically inside the `itemBuilder`.
**Action:** Use `ListView.builder` for heterogeneous lists by flattening data structures and ensuring index-based entrance animations are removed to avoid scroll jank during lazy loading.
