## 2025-02-19 - Unbounded Animation Delays in Virtualized Lists
**Learning:** Using linear delays (`index * duration`) in virtualized lists like `ListView.builder` causes items deep in the list to have massive initial delays (e.g., 5 seconds for the 100th item), making the list appear empty upon fast scrolling.
**Action:** Always clamp or modulo the delay (e.g., `(index % 10) * duration`) for items in virtualized lists to ensure animations trigger promptly.
