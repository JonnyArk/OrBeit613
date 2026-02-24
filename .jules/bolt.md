## 2026-02-24 - Virtualized List Animation Performance
**Learning:** Using `flutter_animate`'s `delay` with linear indexing (`i * duration`) in virtualized lists causes unbounded delays for items far down the list.
**Action:** Use modulo-based indexing for delays (e.g., `(index % 10) * duration`) to keep animations snappy and predictable in long lists.
