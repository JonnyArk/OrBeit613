## 2026-07-16 - Optimize heterogeneous lists with ListView.builder
**Learning:** Eagerly instantiating heterogeneous lists and using index-based staggered entrance animations negates the lazy-loading performance benefits of ListView and causes scroll jank.
**Action:** Flatten data into lightweight structures, use ListView.builder for dynamic widget instantiation, and remove index-based entry animations in lazy-loaded lists.
