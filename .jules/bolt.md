## $(date +%Y-%m-%d) - Virtualization of Heterogeneous Animated Lists
**Learning:** Using a standard `ListView` with nested `for` loops and `flutter_animate` causes serious performance bottlenecks (O(N) memory + unconstrained delays) for long lists.
**Action:** Always flatten heterogeneous nested lists using Dart 3 `sealed classes` and `switch` expressions, virtualize with `ListView.builder`, and cap staggering delays using `min(index, MAX)` so lazily-loaded deep elements render promptly.
