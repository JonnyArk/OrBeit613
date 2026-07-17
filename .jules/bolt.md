## YYYY-MM-DD - Optimize task list rendering using ListView.builder
**Learning:** In Flutter, passing pre-instantiated widgets into `ListView` negates its lazy-loading performance benefits, especially when dynamically generating content for heterogeneous lists.
**Action:** Flatten list data into lightweight data structures (e.g., an array of maps) and dynamically instantiate the widgets inside the `itemBuilder` callback based on item type.
