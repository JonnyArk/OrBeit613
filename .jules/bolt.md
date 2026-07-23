## YYYY-MM-DD - Lazy Loading Heterogeneous Lists in Flutter
**Learning:** Passing pre-instantiated widgets into ListView.builder negates its lazy-loading performance benefits.
**Action:** To optimize heterogeneous lists while maintaining strong typing and preserving local variables (like index for staggered animations), construct an array of closures (e.g., List<Widget Function()>) and evaluate them dynamically inside the itemBuilder callback, instead of using weakly-typed Maps or dynamic objects.
