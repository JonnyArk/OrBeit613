# Palette's Journal

## 2026-02-08 - Explicit Semantics for GestureDetector
**Learning:** Flutter's `GestureDetector` is invisible to screen readers unless wrapped in `Semantics`. Simple icons like "check circle" or "flag" convey meaning visually but are silent to accessibility tools, creating a "button" void.
**Action:** Always wrap interactive `GestureDetector` widgets with `Semantics(button: true, label: '...', onTap: ...)` to ensure they are discoverable and operable by all users.
