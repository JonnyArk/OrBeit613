## 2024-05-24 - Accessible Tight-Packed IconButtons
**Learning:** Replacing `GestureDetector(child: Icon(...))` with `IconButton` improves accessibility (via `tooltip`) and provides standard visual feedback (ripple effect). However, `IconButton` enforces a minimum 48x48 tap target and padding, which can break existing tight layouts.
**Action:** When refactoring tightly packed icon elements to `IconButton` for accessibility, use `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to maintain the original layout without shifting surrounding elements.
