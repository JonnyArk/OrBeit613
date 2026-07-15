## YYYY-MM-DD - Icon-only Buttons Need Semantics
**Learning:** Using raw GestureDetector for small icons removes visual touch feedback and screen reader semantics, making the UI inaccessible to keyboard/voice navigation and harder to tap.
**Action:** Always replace icon-only GestureDetector widgets with IconButton, using padding: EdgeInsets.zero and constraints: const BoxConstraints() to maintain layout while gaining tooltips and touch ripples.
