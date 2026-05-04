## 2024-05-24 - Flutter Accessibility Fundamentals
**Learning:** Foundational accessibility in Flutter requires pairing visual context (Tooltip) with screen reader context (Semantics). Icon-only buttons wrapped in `GestureDetector` lack both, creating a confusing experience for all users.
**Action:** When adding accessibility to interactive, icon-only widgets (especially `GestureDetector`), consistently wrap them in `Tooltip` to provide on-hover context for visual users and `Semantics(label: '...', button: true)` to announce the control properly for screen readers.
