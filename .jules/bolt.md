## 2024-05-11 - Cap Staggered Delays in Virtualized Lists
**Learning:** When using `ListView.builder` with `flutter_animate` staggered delays, using the raw item index for the delay duration (e.g., `index * 50ms`) causes massive visual delays for lazily loaded items deep in the list because their index is large even if they are just appearing on screen.
**Action:** Cap the delay multiplier (e.g., using `min(index, 10)`) to ensure scrolled items appear promptly while preserving the initial staggered load effect.
