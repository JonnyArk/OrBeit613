## 2026-08-16 - Optimize heterogeneous Flutter lists
**Learning:** Passing pre-instantiated widgets into `ListView.builder` negates its lazy-loading performance benefits.
**Action:** To optimize heterogeneous lists while maintaining strong typing and preserving local variables, construct an array of closures (e.g., `List<Widget Function()>`) and evaluate them dynamically inside the `itemBuilder` callback, instead of using weakly-typed Maps or dynamic objects.
