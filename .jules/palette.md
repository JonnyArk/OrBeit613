## YYYY-MM-DD - Accessible Icon Buttons in Flutter
**Learning:** Replaced `GestureDetector` with `IconButton` for small interactive icons. Discovered that using `IconButton` requires explicitly setting `padding: EdgeInsets.zero` (or small padding) and `constraints: const BoxConstraints()` to prevent default material padding from breaking dense layouts.
**Action:** Use `IconButton` instead of `GestureDetector` for icon actions to gain free tooltip and focus state support, but always override constraints when used in tightly packed rows like task list items.
