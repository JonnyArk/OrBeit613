## 2026-06-27 - [Heterogeneous List Performance Optimization]
**Learning:** In Flutter, passing pre-instantiated widgets into ListView.builder (or using ListView directly) negates lazy-loading benefits.
**Action:** To correctly optimize heterogeneous lists, flatten the data into lightweight data structures (e.g., an array of maps) and dynamically instantiate the widgets inside the itemBuilder callback based on the item type.
