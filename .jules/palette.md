## 2024-05-24 - Flutter Icon Button Accessibility
**Learning:** In Flutter, GestureDetector wrapping an Icon is a common anti-pattern that breaks accessibility. It misses out on visual feedback (splash), keyboard focus states, and native tooltip support.
**Action:** When a standalone icon acts as a button, strictly prefer IconButton with a descriptive tooltip, padding: EdgeInsets.zero, and constrained sizing for better micro-UX and a11y.
