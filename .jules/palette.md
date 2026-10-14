## 2024-10-14 - Replace icon-only GestureDetector with IconButton for native accessibility
**Learning:** Icon-only `GestureDetector` widgets lack native keyboard accessibility, focus states, and screen reader labels. Using `IconButton` with `tooltip`, `padding: EdgeInsets.zero`, and `constraints: const BoxConstraints()` provides these benefits without altering the visual layout.
**Action:** Replace `GestureDetector` wrapping an `Icon` with `IconButton` in `app/lib/ui/task_list_panel.dart` and `app/lib/ui/life_event_timeline.dart` for icon buttons like "complete task" or "delete event".
