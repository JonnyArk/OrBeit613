## 2024-05-24 - Accessibility Pattern: Custom Icon Buttons
**Learning:** The OrBeit app makes heavy use of `GestureDetector` wrapping `Icon` widgets for custom buttons (e.g., in Reminder Banner). While this achieves custom sizing visually, it breaks screen reader semantics, removes keyboard focusability, and eliminates native tap feedback.
**Action:** Replace `GestureDetector(child: Icon(...))` with `IconButton(icon: Icon(...), padding: EdgeInsets.zero, constraints: const BoxConstraints(), tooltip: '...')` to restore accessibility without breaking visual layouts.
