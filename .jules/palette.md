## 2024-05-24 - Accessible Icon-Only Buttons
**Learning:** In Flutter, icon-only GestureDetectors are invisible to screen readers without Semantics, and sighted users lack context without Tooltips.
**Action:** Always wrap icon-only interactive elements with Semantics(label: '...', button: true) and Tooltip.
