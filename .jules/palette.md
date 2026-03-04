## 2024-05-28 - Interactive Icon Accessibility in Flutter
**Learning:** Wrapping `Icon` widgets with `GestureDetector` deprives screen readers of semantic labels and users of interactive visual feedback (like focus states and ink ripples).
**Action:** Replace `GestureDetector` + `Icon` combinations with `IconButton` and provide a clear `tooltip` property to ensure both screen reader compatibility and correct visual focus behavior. To preserve existing layout constraints, use `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()`.
