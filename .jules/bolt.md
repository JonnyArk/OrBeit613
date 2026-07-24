## 2024-03-20 - Optimizing Heterogeneous Lists with Closures
**Learning:** In Flutter, passing pre-instantiated widgets into `ListView.builder` negates its lazy-loading performance benefits. However, a standard `ListView` eagerness causes performance bottlenecks for large lists.
**Action:** To optimize heterogeneous lists while maintaining strong typing and preserving local variables (like index for staggered animations), construct an array of closures (e.g., `List<Widget Function()>`) and evaluate them dynamically inside the `itemBuilder` callback.
