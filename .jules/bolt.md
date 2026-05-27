## 2024-05-27 - Capping animation delay in ListView loops
**Learning:** When using `flutter_animate` delays dynamically based on item index in lazily loaded lists or long loops, deep indices calculate massive delays (e.g., index 50 -> 2000ms delay), making items appear frozen or blank upon scrolling.
**Action:** Always cap dynamic animation delay calculations with `min(index, max_cap) * delay_factor` (using `dart:math`) to ensure visual responsiveness for deeply nested items.
