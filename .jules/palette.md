## 2024-05-24 - Accessible Icon Buttons
**Learning:** Using GestureDetector around an Icon removes native visual tap feedback and accessibility semantics (like tooltips for screen readers).
**Action:** Use IconButton with zero padding and empty BoxConstraints to maintain layout while adding full accessibility support.
