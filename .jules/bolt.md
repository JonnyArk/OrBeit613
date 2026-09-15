## 2024-05-18 - Avoid visual popping from unbounded initial staggered animations in lazily loaded lists
**Learning:** In Flutter, while stripping initial staggered animations from lazily loaded items causes visual regressions, leaving them uncapped means every item popped into view later still runs the intro animation, ruining virtualization benefits.
**Action:** Cap the initial stagger delay conditionally based on list position (e.g., `index < 10` or a small limit) inside the `itemBuilder` to preserve first-load aesthetic without breaking continuous scrolling.
