## 2024-05-24 - Accessible Close Buttons without Layout Shifts
**Learning:** Replaced `GestureDetector` wrapped around icons with `IconButton` for ARIA-equivalent accessibility (tooltips and semantic meaning). `IconButton` has default padding and sizing that breaks tight layouts; fixing constraints (`padding: EdgeInsets.zero, constraints: const BoxConstraints()`) restores original dimensions while keeping accessibility features intact.
**Action:** Always replace icon `GestureDetector` widgets with properly constrained `IconButton` widgets or `Semantics` wrappers.
