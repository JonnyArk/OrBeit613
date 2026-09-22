## 2024-05-23 - Accessibility of custom text buttons
**Learning:** Custom text strings acting as buttons (e.g. '⌫' or '✓') wrapped only in a GestureDetector won't be announced properly by screen readers and don't indicate they are interactive buttons.
**Action:** Always wrap these interactive custom UI elements in a `Semantics` widget, explicitly defining `button: true` and providing a clear, descriptive `label` so screen readers interpret them correctly.
