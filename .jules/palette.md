## 2024-05-14 - Accessibility for Interactive Icons
**Learning:** Icon-only interactive elements using `GestureDetector` in Flutter lack screen reader descriptions and visual cues (tooltips).
**Action:** When creating icon-only buttons or interactive elements, wrap them in a `Semantics` widget and a `Tooltip` to ensure screen readers can announce them and visual users get hover context.
