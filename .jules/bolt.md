## YYYY-MM-DD - Optimize Heterogeneous Lists with Closures
**Learning:** Passing pre-instantiated widgets or dynamically building them inside `ListView` negates lazy-loading performance benefits. For heterogeneous lists, weakly-typed Maps are unsafe and don't preserve local variables like staggered animation indices.
**Action:** Construct an array of closures (`List<Widget Function()>`) and evaluate them dynamically inside `ListView.builder`'s `itemBuilder` callback to maintain strong typing, preserve local variables, and restore lazy-loading.
