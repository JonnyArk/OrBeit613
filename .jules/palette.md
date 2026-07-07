## YYYY-MM-DD - Replacing GestureDetector with IconButton for Small Icons
**Learning:** In Flutter applications, using `GestureDetector` around a small `Icon` without padding creates a small tap target and lacks proper accessibility semantics (ARIA-equivalent), keyboard focus, and visual tap feedback.
**Action:** Replace `GestureDetector` with `IconButton` and add a `tooltip` parameter. Set `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` to prevent layout shifts.
