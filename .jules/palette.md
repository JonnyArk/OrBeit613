## 2024-05-11 - Custom Interactive Elements Need Explicit Semantics
**Learning:** Custom visual components like the OrBeacon (which relies on a GestureDetector and custom visual drawing) don't naturally expose their interactivity or purpose to assistive technologies.
**Action:** Always wrap custom icon-only or purely visual interactive elements in both a `Semantics` widget (with `label` and `button: true`) and a `Tooltip` widget to ensure both screen readers and pointer-device users understand their function.
