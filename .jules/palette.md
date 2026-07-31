## 2024-05-18 - Accessible Icon Interactive Elements
**Learning:** Icon-only interactive elements like GestureDetector in Flutter are completely invisible to screen readers without semantic metadata.
**Action:** Always wrap interactive icon-only elements (like the OrBeacon) with a Semantics widget containing a descriptive label, hint, and button role to ensure screen reader accessibility.
