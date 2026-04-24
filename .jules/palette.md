## 2024-05-18 - Missing Interactive Semantics on Dismiss Widgets
**Learning:** Custom 'GestureDetector' overlays for dismiss actions (like banner close icons) inherently lack semantic meaning for screen readers and hover states for desktop pointing devices in Flutter compared to using 'IconButton'.
**Action:** When implementing custom icon-only interactive elements without standard Flutter button widgets, always explicitly wrap them in 'Semantics(label: "...", button: true)' and 'Tooltip' to ensure parity with standard accessibility requirements.
