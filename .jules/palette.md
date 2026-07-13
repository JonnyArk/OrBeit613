## YYYY-MM-DD - Icon-only Buttons
**Learning:** Using GestureDetector for icon-only buttons lacks accessibility features like tooltips and focus states.
**Action:** Replace icon-only GestureDetector widgets with IconButton, setting padding to zero and constraints to BoxConstraints() to preserve layout.
