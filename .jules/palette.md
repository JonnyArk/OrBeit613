## YYYY-MM-DD - Accessible Icon Buttons in Flutter
**Learning:** The app frequently uses `GestureDetector` for icons to prevent default sizing issues, which removes accessibility semantics and focus indicators.
**Action:** Replace `GestureDetector` with `IconButton` and set `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to preserve layout while gaining accessibility features like tooltips.
