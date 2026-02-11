## 2024-05-23 - Accessibility of Custom Checkboxes inside InkWells
**Learning:** Custom interactive widgets (like checkboxes) inside a larger touch target (like a Card with InkWell) are often swallowed by the parent's semantics. To make them distinct accessible nodes, they must be wrapped in `Semantics(container: true, ...)` or similar mechanism to force a new node.
**Action:** When nesting interactive elements, verify accessibility with `flutter test` using `find.bySemanticsLabel` and ensure distinct nodes are created.
