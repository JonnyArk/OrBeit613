## 2024-09-17 - Add Semantics to Icon Buttons
**Learning:** In Flutter, wrapping an Icon with a GestureDetector does not implicitly provide interactive semantics to screen readers.
**Action:** Wrap the GestureDetector in a Semantics(button: true, label: '...') widget to ensure accessibility for icon-only interactive elements.
