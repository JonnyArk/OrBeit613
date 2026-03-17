## 2026-03-17 - Flattening heterogeneous lists for Flutter virtualization
**Learning:** Virtualizing dynamic or grouped lists in Flutter (like a map of priority groups and lists of tasks) using ListView.builder requires flattening the data structure first. Otherwise, using an eager ListView(children: [...]) risks O(N) performance and excessive memory overhead.
**Action:** Always compute derived, flattened arrays of wrapped objects (using an enum for type) before passing the items to a lazy builder widget like ListView.builder.
