## 2024-05-03 - Semantics for Interactive Elements
**Learning:** Wrapping interactive visual elements like the OrBeacon in both `Semantics` and `Tooltip` ensures they are accessible to screen readers and have hover context for mouse users in Flutter.
**Action:** Always wrap custom gesture detectors that function as primary inputs with `Semantics(button: true)` and a descriptive `Tooltip`.
