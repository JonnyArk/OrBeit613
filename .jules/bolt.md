## 2026-05-24 - Cap animation delays in virtualized lists

**Learning:** When using staggered `delay` in animations within virtualized lists (`ListView.builder` or similar), relying on the raw item index causes items loaded further down the list to wait a very long time before appearing, creating a sluggish experience.
**Action:** Always cap the delay multiplier (e.g., `min(index, 10) * duration`) when animating items in a list so newly scrolled items appear promptly while preserving the staggered effect for the initial viewport.
