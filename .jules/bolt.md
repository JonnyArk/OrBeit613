
## 2024-06-18 - Modulo for Animation Delays in Large Virtualized Lists
**Learning:** Using a linear formula like `index * 50ms` for animation delays inside a virtualized list (e.g., `ListView.builder` or `SliverList`) causes unbounded delay times for higher indices. Because the builder creates widgets as the user scrolls, a high index (e.g., 100) evaluates to an unacceptably long wait time (e.g., 5000ms delay) before its content fades in, breaking the UX.
**Action:** When applying entry animations inside virtualized scroll views, use a modulo operator to cap the sequence delay. For instance, `(index % 10) * 50ms` ensures animations trigger promptly, creating a staggered effect that resets every 10 items.

## 2024-06-18 - Memoizing View Model Getters in Flutter Render Cycle
**Learning:** In Riverpod/Flutter stateful widget patterns, getter methods such as `_activeTasks` or `_overdueCount` inside a `build` context evaluate on every `build` cycle, leading to O(n) rendering overhead. For complex data like tasks grouped by multiple variables, toggling small state changes (like expanding an accordion section) causes the entire `build` tree to evaluate all tasks from scratch.
**Action:** When working with list items or computation-heavy getters in a Flutter view cycle, compute these values once inside a dedicated processor method, memoize the results to instance variables during `setState`, and use the pre-computed instances directly in `build`. This turns an O(n) `build` cost into an O(1) fetch.
