## 2024-05-24 - Accessible Icon Buttons in Flutter
**Learning:** Wrapping `Icon` widgets in `GestureDetector` for click events lacks essential accessibility metadata (like `tooltip`/ARIA labels) and native visual feedback.
**Action:** Always prefer `IconButton` with a defined `tooltip` for icon-only interactive elements. Use `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` if tight packing is required.
