## 2024-07-13 - Refactoring to ListView.builder
**Learning:** In Flutter, passing pre-instantiated widgets into ListView.builder negates its lazy-loading performance benefits. Furthermore, index-based staggered animations in lazy lists cause inappropriate scroll jank.
**Action:** Flatten data into lightweight data structures and dynamically instantiate widgets inside the itemBuilder. Remove index-based staggered entrance animations on list items.
