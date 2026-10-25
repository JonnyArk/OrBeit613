## 2024-05-18 - Avoid Stagger Delays in Lazily Loaded Lists
**Learning:** Using index-based stagger delays (like `delay: Duration(milliseconds: i * 40)`) on animations inside `ListView.builder` causes visual sluggishness and stutters during scrolling, as each newly instantiated item calculates a large delay based on its index.
**Action:** Remove index-based delays on item animations within `ListView.builder` and rely on constant animation durations for smooth scrolling.
