## 2026-04-03 - Virtualization in Flutter List Views
**Learning:** Using eager ListView in Flutter for long lists causes O(N) performance overhead and memory bloat because it pre-instantiates all Widget objects eagerly.
**Action:** Always replace eager ListView with ListView.builder or SliverChildBuilderDelegate and flatten hierarchical data into a typed array to enable true lazy loading.
