# 2024-05-24 - Task Completion Feedback
**Learning:** Users need clear, immediate feedback for key actions. Relying on `GestureDetector` without visual feedback makes the interface feel unresponsive.
**Action:** Always prioritize `InkWell` (wrapped in `Material`) over `GestureDetector` for tappable elements to provide ripple effects. Ensure accessible labels are added to icon-only buttons.
