1. **Identify UX Improvements:**
   - I will modify `app/lib/ui/task_list_panel.dart`.
   - The app has several `GestureDetector` widgets wrapping icon-only or generic interactive areas without semantic labels or hover tooltips, which hurts accessibility (screen readers) and mouse/hover UX.
   - Specifically, I will wrap the following in `Semantics` and `Tooltip`:
     - The "Tap to complete" radio button in the task item card.
     - The "Completed tasks" expand/collapse header.
     - The priority selector options in the task creation form.
     - The due date picker close/clear button.
2. **Implementation:**
   - Use `replace_with_git_merge_diff` to add `Semantics(button: true, label: '...', child: Tooltip(message: '...', child: GestureDetector(...)))` patterns.
3. **Verification:**
   - Run `git diff` to verify the changes.
   - Run `dart format app/lib/ui/task_list_panel.dart` to ensure proper formatting.
   - Run `cd app && flutter test || true` to check tests.
4. **Pre-commit Instructions:**
   - Complete pre-commit steps to ensure proper testing, verification, review, and reflection are done.
5. **Submit:**
   - Submit the PR with the title "🎨 Palette: [UX improvement] Add ARIA-equivalent accessibility to interactive elements" and description.
