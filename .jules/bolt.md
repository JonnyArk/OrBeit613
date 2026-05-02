## 2024-05-02 - List Virtualization in Flutter

**Learning:** When refactoring a static `ListView` to `ListView.builder` for performance, preserving specific localized behaviors (like staggered staggered animations `delay: Duration(milliseconds: i * 40)`) requires including the local index inside the flattened item model (e.g., `_ActiveTaskItem(task, index)`).
**Action:** When implementing virtualization in Flutter, evaluate if any child widgets rely on relative group-based indices rather than absolute global indices.
