## 2024-06-25 - Lazy Loading Heterogeneous Lists in Flutter
**Learning:** Passing pre-instantiated widgets into `ListView` negates lazy-loading. `ListView.builder` should be used with a `List<Widget Function()>` array of closures to maintain strong typing. Also, staggered animations inside cause massive delays for off-screen items unless the delay is capped (e.g. `math.min(i, 10)`).
**Action:** Migrate `ListView` to `ListView.builder`, evaluate closures dynamically, and cap animation delays.
