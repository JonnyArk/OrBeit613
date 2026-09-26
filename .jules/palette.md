## 2025-01-30 - Accessible Pin Gate Buttons
**Learning:** In Flutter, wrapping an `Icon` with a `GestureDetector` does not implicitly provide interactive semantics to screen readers. For custom number pads like in PinGateScreen, the backspace and submit buttons are completely invisible to screen readers without explicit Semantics wrappers.
**Action:** Always wrap `GestureDetector` components for icon-only buttons with `Semantics(button: true, label: '...')` to ensure screen reader accessibility.
