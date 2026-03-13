## 2024-05-18 - Semantic Labels for Icon Actions
**Learning:** `GestureDetector` instances wrapping `Icon` widgets provide no intrinsic semantics or focus states, leading to poor keyboard accessibility and lack of context for screen readers in tight UI spaces.
**Action:** Replace `GestureDetector(child: Icon(...))` with `IconButton` and provide a `tooltip` property to add built-in ARIA/semantics and focus states. Use `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to maintain exact layout dimensions.
