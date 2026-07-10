## 2024-05-24 - Accessible Icon Buttons in Flutter
**Learning:** Using `GestureDetector` on icons removes semantic meaning and focusibility for assistive technologies. Replacing them with `IconButton` improves accessibility but can break layout due to default sizing.
**Action:** Use `IconButton` with `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to maintain visual layout while adding `tooltip` for screen readers.
