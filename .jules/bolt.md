## 2024-07-09 - [Flutter ListView Refactoring]
**Learning:** Eagerly-instantiated lists with `ListView` and staggered animations can cause scroll jank. Passing pre-instantiated widgets negates lazy-loading performance benefits.
**Action:** Flatten data into lightweight data structures and use `ListView.builder` dynamically rendering item in the `itemBuilder`. Remove index-based staggered animations in lazy lists.
