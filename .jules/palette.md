
## 2024-06-17 - Replace GestureDetector with IconButton for Accessible Icon Buttons
**Learning:** Custom icon buttons built by wrapping an `Icon` in a `GestureDetector` lack accessibility semantics, keyboard focus capabilities, and visual tap feedback. They are invisible to screen readers without explicit ARIA-equivalent roles.
**Action:** Always replace standalone `GestureDetector` + `Icon` combinations with native `IconButton` widgets and provide a `tooltip` attribute. This instantly provides standard semantic button roles, visual touch ripples, and keyboard tab-navigation out of the box.
