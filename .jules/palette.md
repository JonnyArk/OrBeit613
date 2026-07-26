## YYYY-MM-DD - Accessible Icon Buttons in Flutter Layouts
**Learning:** Replacing GestureDetector with IconButton for screen reader accessibility can break visual layouts because IconButton has default padding and sizing constraints.
**Action:** When converting small interactive icons to IconButton for accessibility, explicitly set padding: EdgeInsets.zero and constraints: const BoxConstraints() to preserve the original visual layout.
