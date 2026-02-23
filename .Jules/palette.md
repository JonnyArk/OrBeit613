## 2024-05-23 - Custom Interactive Components
**Learning:** The app frequently uses `GestureDetector` wrapped `Container`s as buttons instead of standard `IconButton` or `ElevatedButton`. This provides custom styling but omits accessibility traits by default.
**Action:** Always wrap these custom interactive elements with `Semantics(button: true, label: '...')` to ensure they are discoverable and usable by screen readers.
