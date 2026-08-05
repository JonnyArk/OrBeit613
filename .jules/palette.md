## YYYY-MM-DD - Dynamic Accessibility Labels for Stateful UI
**Learning:** AI interface components (like voice beacons) that change state visually often fail accessibility if they lack dynamic `Semantics`. Screen reader users need real-time context about whether the assistant is listening, processing, or idle.
**Action:** Always wrap stateful, icon-only UI components in a `Semantics` widget and compute `label` and `hint` dynamically based on the component's current state.
