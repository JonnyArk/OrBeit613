## 2026-05-29 - Accessible Icon Buttons
**Learning:** Using GestureDetector for icon-only buttons in Flutter strips away built-in accessibility (like semantic labels for screen readers) and interaction feedback (like tap ripples and focus indicators).
**Action:** Always replace GestureDetector + Icon with an IconButton, utilizing the tooltip property to automatically provide both visual hover context and a screen reader semantic label, while adjusting padding and constraints to maintain the visual layout.
