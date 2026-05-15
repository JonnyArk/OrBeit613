## 2024-05-15 - Capped Animation Delays in ListView.builder
**Learning:** Using raw indices for staggered animation delays in `ListView.builder` causes massive, compounding delays for lazily-loaded items deep in the list, making them appear unresponsive.
**Action:** Always cap the delay index (e.g. `min(index, 10)`) when applying staggered animations to virtualized lists to ensure deeply scrolled items appear promptly.
