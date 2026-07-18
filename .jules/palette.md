## YYYY-MM-DD - Improve accessibility of symbol PIN keys
**Learning:** Found that icon-only buttons or symbol-based keys (like '⌫' or '✓') in the custom PIN pad (`PinGateScreen`) weren't explicitly described for screen readers, meaning users navigating with assistive tech might just hear generic "button" or symbol characters rather than their actual intent ("Backspace", "Submit").
**Action:** Always wrap custom icon-only or symbol-based touch targets in `Semantics(button: true, label: 'Descriptive Action')` when implementing non-standard keypads in Flutter.
