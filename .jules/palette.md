## YYYY-MM-DD - Icon Accessibility in Flutter
**Learning:** Custom icon buttons created by wrapping an Icon widget in a GestureDetector lack proper accessibility semantics, keyboard focus, and visual tap feedback.
**Action:** Replace them with native IconButton widgets with padding: EdgeInsets.zero, constraints: const BoxConstraints(), and a tooltip attribute to meet ARIA-equivalent accessibility requirements without breaking visual layouts.
