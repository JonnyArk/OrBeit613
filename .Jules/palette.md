# Palette's Journal

**Philosophy:**
- Users notice the little things
- Accessibility is not optional
- Every interaction should feel smooth
- Good UX is invisible - it just works

**Format:**
`## YYYY-MM-DD - [Title]`
`**Learning:** [UX/a11y insight]`
`**Action:** [How to apply next time]`

---

## 2025-02-04 - Cinematic Accessibility
**Learning:** Icon-only buttons in "cinematic" UI (like the pulsing "Tap to begin") are invisible to screen readers without explicit Semantics wrappers.
**Action:** Wrap all gesture-based interactions in cinematic flows with Semantics(button: true, label: "...") to ensure accessibility isn't sacrificed for style.
