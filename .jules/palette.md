## 2024-05-24 - Accessible Icon Buttons in Flutter
**Learning:** Found multiple instances where `GestureDetector` with just an `Icon` child was used for close/dismiss actions. These lack semantic accessibility features for screen readers (like labeling the action) and keyboard focus support, which is critical for inclusive design.
**Action:** Replace `GestureDetector` icon-only buttons with `IconButton` and provide descriptive `tooltip` labels. Use `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to preserve the exact visual dimensions if needed.
