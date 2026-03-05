## 2024-05-24 - Accessible Close Buttons in Tight Spaces
**Learning:** Developers frequently use `GestureDetector` wrapping an `Icon` instead of an `IconButton` to create tight-fitting clickable icons. This breaks accessibility (no screen reader label) and removes visual touch feedback (no ripple effect).
**Action:** Replace `GestureDetector` + `Icon` patterns with an `IconButton` that includes a `tooltip` for ARIA/Semantics. To maintain the tight layout without extra padding, use `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` on the `IconButton`.
