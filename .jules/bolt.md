## 2026-05-26 - Avoid String.prototype.split for Finding First Match
**Learning:** Using `String.prototype.split(/[.!?]/)[0]` on long strings like user notes creates unnecessary performance overhead by scanning the entire string and allocating a complete array of all matches in memory, just to use the first element.
**Action:** When extracting only the first substring matching a pattern (like the first sentence), use `String.prototype.search()` combined with `substring()` (or `match` with a non-greedy regex) to short-circuit processing and avoid massive array allocations.
