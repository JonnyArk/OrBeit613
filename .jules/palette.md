## 2026-04-30 - Icon-Only Interactive Elements Lack Context
**Learning:** Flutter `GestureDetector` widgets wrapping icon-only UI elements do not inherently provide accessibility labels or tooltips, causing screen reader omission and poor mouse-hover discovery.
**Action:** Always wrap icon-only `GestureDetector` interactive elements in `Semantics(label: '...', button: true)` and `Tooltip` to ensure both screen reader support and visual hover context.
