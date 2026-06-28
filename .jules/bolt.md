## 2024-05-27 - Heterogeneous ListView.builder Lazy-Loading
**Learning:** In Flutter, passing pre-instantiated widgets into ListView.builder negates its lazy-loading performance benefits.
**Action:** To correctly optimize heterogeneous lists, flatten the data into lightweight data structures (e.g., an array of maps) and dynamically instantiate the widgets inside the itemBuilder callback based on the item type.
