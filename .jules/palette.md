## 2024-05-18 - Replacing GestureDetector with IconButton for Accessibility
**Learning:** Icon-only `GestureDetector` components in Flutter lack semantic meaning, keyboard accessibility, and visible focus states out of the box, making them poor choices for interactive elements.
**Action:** Always replace icon-only `GestureDetector`s with `IconButton`s. Set `tooltip` for semantic labels and adjust `padding` and `constraints` (e.g., `BoxConstraints()`) to maintain precise visual sizing without sacrificing built-in accessibility features.
