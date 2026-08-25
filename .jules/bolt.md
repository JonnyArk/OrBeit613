## 2026-08-25 - Optimize ListView performance in Flutter
**Learning:** Virtualizing heterogeneous lists by pre-instantiating widgets inside `ListView` negates lazy-loading benefits and causes O(N) upfront allocations. Unbounded staggered animation delays on lazily loaded items cause items to stay invisible when scrolling.
**Action:** Always map the data model into a flat list of items and dynamically evaluate them inside the `itemBuilder` callback using `ListView.builder`. Cap index multipliers for animation delays to preserve smooth scrolling.
