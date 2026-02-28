## 2024-05-18 - Replacing GestureDetector with IconButton for Accessibility
**Learning:** Using `GestureDetector` around custom icons misses out on standard accessibility labels (ARIA/Semantics), touch hit bounds scaling, and visual ripple feedback that comes for free with `IconButton`.
**Action:** Always prefer `IconButton` (potentially with `constraints: BoxConstraints()` for tight packing) over `GestureDetector` wrapping an `Icon` when creating clickable icon elements.
