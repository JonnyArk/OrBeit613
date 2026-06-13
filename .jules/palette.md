## 2024-06-13 - Replace GestureDetector with native IconButton for accessibility
**Learning:** Using GestureDetector wrapped around an Icon creates an inaccessible element that screen readers cannot identify as a button, lacks visual tap feedback, and is not properly keyboard navigable.
**Action:** Always replace GestureDetector + Icon combinations with native IconButton widgets, adding a tooltip to ensure ARIA-equivalent accessibility and native interaction states.
