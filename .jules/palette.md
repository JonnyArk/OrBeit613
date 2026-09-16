## 2024-05-24 - Add Semantics to Icon-Only GestureDetector
**Learning:** Wrapping an Icon with a GestureDetector in Flutter does not implicitly provide interactive semantics to screen readers, making them inaccessible.
**Action:** Always wrap the GestureDetector in a Semantics(button: true, label: '...') widget for icon-only interactive elements to ensure screen readers announce them properly. Do not hardcode interaction instructions like 'Double tap to'.
