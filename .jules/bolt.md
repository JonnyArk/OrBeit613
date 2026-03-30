## $(date +%Y-%m-%d) - Virtualize lists with ListView.builder
**Learning:** Eagerly rendering lists using `ListView(children: [...])` pre-instantiates all Widget objects in memory and defeats lazy loading. Using index-based delays in animations causes off-screen items to experience arbitrary UI waits when scrolled into view.
**Action:** Always flatten grouped data structures into a single array and use `ListView.builder` for true O(1) rendering virtualization. Remove index-based animation delays for list items.
