## 2024-05-15 - Add Semantics and Tooltips to Icon-Only Gestures
**Learning:** Found several icon-only interactive elements wrapped in GestureDetector without semantic labels or visual tooltips, causing accessibility and discovery issues (e.g., closing a modal or selecting an option).
**Action:** When making custom icon buttons using GestureDetector/InkWell, always wrap the widget tree in Semantics(button: true, label: '...') for screen readers, and a Tooltip(message: '...') for hover/long-press context.
