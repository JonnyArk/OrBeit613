
## 2026-04-21 - Virtualizing Nested UI with Dart 3
**Learning:** Standard `ListView` renders all its children upfront, causing massive UI jank and high memory footprint for large numbers of dynamic components in Flutter.
**Action:** Flatten heterogenous nested data structures using Dart 3 `sealed class` models to unlock the virtualization powers of `ListView.builder` for infinite scrolling interfaces.
