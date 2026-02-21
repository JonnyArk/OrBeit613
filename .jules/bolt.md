## 2024-05-23 - Unbounded Animation Delays in Virtualized Lists
**Learning:** Using `index * duration` for animation delays inside a virtualized list (like `SliverList`) causes massive delays for items far down the list (e.g., item 1000 waits 40s), as the index is absolute.
**Action:** Use modulo-based delays (e.g., `(index % 10) * duration`) to stagger animations locally while keeping the delay bounded.
