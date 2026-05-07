## 2024-05-24 - Flutter Icon-Only Buttons Accessibility
**Learning:** In Flutter, `GestureDetector` icon-only buttons do not automatically provide accessibility context for screen readers or visual tooltips for mouse/web users, making them inaccessible.
**Action:** Always wrap icon-only buttons in both `Semantics(label: '...', button: true)` and `Tooltip(message: '...')` to ensure both screen reader support and visual hover context.
