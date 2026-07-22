## YYYY-MM-DD - Icon-only buttons accessibility
**Learning:** Icon-only interactive elements using GestureDetector lack semantic meaning for screen readers and miss necessary tooltips and focus rings for keyboard navigation.
**Action:** Replace GestureDetector with IconButton for icon-only buttons, providing a tooltip and setting padding: EdgeInsets.zero and constraints: const BoxConstraints() to preserve the visual layout footprint.
