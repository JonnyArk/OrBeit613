## 2026-03-21 - Remove staggered animation delays in virtualized timeline list
**Learning:** In Flutter, combining staggered animations (e.g., `delay: Duration(milliseconds: index * 50)`) with virtualized lists (`ListView.builder`) causes items further down the list to have progressively longer, arbitrary wait times before appearing when scrolled into view.
**Action:** Never use index-based delays for items in lazily-loaded lists. Items scrolled into view should animate immediately.
