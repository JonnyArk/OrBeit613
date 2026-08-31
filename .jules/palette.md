## 2026-08-31 - Dynamic Semantics for Stateful AI Components
**Learning:** AI interface components (like voice beacons) that change visual state often lack proper accessibility context because standard Flutter widgets like GestureDetector don't announce state changes to screen readers.
**Action:** Always wrap stateful AI interactive components with a Semantics widget that dynamically updates its label and hint properties based on the component's internal state machine (e.g., idle, listening, processing) to ensure screen reader users are aware of what the AI is currently doing.
