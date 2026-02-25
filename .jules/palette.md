## 2024-05-22 - Accessibility for Custom Icon Buttons
**Learning:** Custom icon buttons implemented with `GestureDetector` + `Container` are invisible to screen readers unless wrapped in `Semantics`.
**Action:** Always wrap interactive icon containers in `Semantics(button: true, label: 'Action Name')` to ensure accessibility.
