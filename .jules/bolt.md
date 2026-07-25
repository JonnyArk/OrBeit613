## YYYY-MM-DD - Lazily load heterogeneous lists in Flutter
**Learning:** Pre-instantiating widgets and passing them into a `ListView` negates lazy-loading performance benefits, particularly for long lists. Weakly typed maps or dynamic objects might lose types or local state.
**Action:** Construct an array of closures (e.g., `List<Widget Function()>`) and evaluate them dynamically inside the `itemBuilder` callback of `ListView.builder` to maintain strong typing and preserve local variables (like index for staggered animations).
