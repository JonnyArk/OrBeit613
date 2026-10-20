## 2024-10-20 - Index-based Stagger Delays in Lists
**Learning:** Using index-based stagger delays (e.g., `index * 50ms`) on animations within lazily loaded list items (like `ListView.builder`) or long scrollable lists causes severe visual sluggishness. As users scroll, items further down have massive initial delays before appearing.
**Action:** Remove absolute index-based delays from items inside lists. Rely on simple entrance animations without delays, or only apply stagger delays to a fixed number of initial items.
