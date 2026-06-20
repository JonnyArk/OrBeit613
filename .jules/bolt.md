## 2024-03-22 - Global Stateful Object Hoisting
**Learning:** Frequent instantiations of `RegExp`, `Set`, and `Array` inside hot methods (like `extractEntities`, `analyzeSentiment`, `extractActionItems`) adds unnecessary object creation and garbage collection overhead.
**Action:** Hoist these static definitions outside the class or function scope so they are only initialized once. Always reset `lastIndex = 0` before using a hoisted `RegExp` with the `/g` or `/gi` flag to prevent subsequent matches from returning incorrect results or failing.
