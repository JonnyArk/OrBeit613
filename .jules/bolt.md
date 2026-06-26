## 2024-05-24 - Optimizing Heterogeneous Lists in Flutter
**Learning:** Passing pre-instantiated widgets into `ListView` or `ListView.builder` negates its lazy-loading performance benefits. Eagerly instantiating heterogeneous elements causes memory bloat and UI jank as the list grows.
**Action:** Always flatten heterogeneous nested collections and conditional elements into lightweight data structures (like an array of maps) before rendering, and instantiate the actual widgets dynamically inside `itemBuilder` based on the item type.
