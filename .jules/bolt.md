## YYYY-MM-DD - Flutter ListView.builder with Staggered Delays
**Learning:** Staggered delays inside `ListView.builder` can cause off-screen items to have massive delays when scrolled into view. Pre-instantiating widgets for `ListView` negates lazy-loading performance.
**Action:** When migrating such lists to `ListView.builder`, construct an array of closures (e.g., `List<Widget Function()>`) to evaluate items dynamically inside the `itemBuilder` callback, and cap the animation delay (e.g., using `math.min`).
