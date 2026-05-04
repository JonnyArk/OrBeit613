
## 2024-05-04 - Virtualize lists preserving Staggered Animation
**Learning:** When transitioning from a standard `ListView` to an optimized `ListView.builder` for performance, preserving complex grouping and staggered animations (`flutter_animate`) requires mapping hierarchical domains into a flat array of heterogenous structures (e.g., using Dart 3 sealed classes) which retain localized properties like group indices.
**Action:** Map grouped data into a 1D structural list of UI items and switch over them inside `itemBuilder` rather than rendering them statically.
