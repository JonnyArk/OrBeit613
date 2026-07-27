## YYYY-MM-DD - Lazy Loading Heterogeneous Lists with Closures
**Learning:** Passing pre-instantiated widgets into `ListView.builder` negates its lazy-loading benefits. For heterogeneous lists (e.g. lists with headers and different item types) with local variables (like staggered animation delays), a `List<Widget Function()>` can safely encapsulate state without giving up lazy loading.
**Action:** When migrating complex lists from `ListView` to `ListView.builder`, construct an array of closures and evaluate them dynamically in the `itemBuilder` rather than using weakly-typed Maps.
## YYYY-MM-DD - Staggered Animations with Lazy Loading
**Learning:** Applying staggered index-based animation delays (e.g., `delay: i * 40ms`) inside a lazy-loaded `ListView.builder` causes off-screen items to have massive delays when they are scrolled into view, making the list look broken.
**Action:** When migrating lists with staggered animations to `ListView.builder`, cap the delay (e.g., `min(i, 10) * 40`) so that initial items still stagger, but items scrolled into view appear immediately.
