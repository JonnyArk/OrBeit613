## 2024-05-24 - Accessibility for Icon-only Interactive Elements in Flutter
**Learning:** In Flutter, wrapping an `Icon` with a `GestureDetector` without explicit semantics means screen readers won't know it's a button or what action it performs.
**Action:** Always wrap `GestureDetector` that contains only an `Icon` with a `Semantics(button: true, label: '...')` widget or use an `IconButton` which handles this automatically if `tooltip` or `semanticLabel` is provided.
