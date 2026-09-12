## 2024-05-24 - Virtualizing Heterogeneous Lists in Flutter
**Learning:** Pre-building a tree of widgets or an array of widget closures to feed into a Flutter list negates its virtualization and allocates everything upfront.
**Action:** Always flatten heterogeneous nested models into a unified record list (`List<({String type, dynamic data})>`) and instantiate the appropriate widgets lazily inside `ListView.builder`'s `itemBuilder` while capping intro animations to preserve view load performance.
