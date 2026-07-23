## 2024-07-23 - Add accessibility label to dismiss reminder icon
**Learning:** Icon-only buttons using `GestureDetector` in Flutter without a wrapping `Semantics` widget are invisible or confusing to screen readers, preventing users from understanding the button's action.
**Action:** When creating icon-only interactive elements using `GestureDetector`, always wrap them in a `Semantics` widget with an appropriate descriptive `label` and `button: true` to ensure screen reader accessibility.
