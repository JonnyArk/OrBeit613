## YYYY-MM-DD - [Add Semantics to PIN pad keys]
**Learning:** Custom GestureDetector-based keypads require manual Semantics wrappers since they don't inherit accessibility properties like standard Flutter buttons do.
**Action:** Always wrap interactive icon-only or custom-drawn elements in Semantics(button: true, label: '...').
