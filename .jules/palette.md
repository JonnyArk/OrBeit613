## YYYY-MM-DD - Accessible Icon Buttons in Flutter
**Learning:** Custom icon buttons created by wrapping an `Icon` widget in a `GestureDetector` lack proper accessibility semantics, keyboard focus, and visual tap feedback.
**Action:** Replace them with native `IconButton` widgets providing a `tooltip` attribute for screen readers, and set `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to prevent layout breakage.
