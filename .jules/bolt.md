## 2026-05-25 - Prevent massive visual delays with capped staggered animations
**Learning:** When using staggered animations in Flutter's `ListView.builder` or long loops (e.g., `flutter_animate` with delay based on item index like `index * 50ms`), deep list items suffer from enormous, unintended visual delays before rendering when lazily loaded.
**Action:** Always cap the maximum animation delay index using `min(index, MAX_DELAY_ITEMS)` to ensure scrolled items render promptly while preserving the staggered effect for the initial viewport.
