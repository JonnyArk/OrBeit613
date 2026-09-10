## 2024-03-24 - Dynamic Semantics for Stateful Voice Assistant Beacon
**Learning:** When building stateful, custom interactive elements (like an AI beacon) with `GestureDetector`, static accessibility labels are insufficient. Screen readers need to know what action the button will perform *next* based on its current state (e.g., "Activate" when idle, "Stop" when listening/speaking).
**Action:** When implementing `Semantics` for multi-state custom UI, bind the `label` dynamically to the state enum rather than hardcoding a generic label.
