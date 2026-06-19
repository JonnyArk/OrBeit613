## 2024-05-24 - Replace GestureDetector with IconButton for Semantic Accessibility
**Learning:** Using GestureDetector around Icon widgets in Flutter misses native accessibility support, lacking ARIA-equivalent semantics, visual tap feedback, and screen reader announcements. Using IconButton instead with proper constraints prevents layout breakage while maintaining semantics.
**Action:** Replace `GestureDetector` with `IconButton` with `tooltip`, `padding: EdgeInsets.zero`, and `constraints: const BoxConstraints()` to fix semantic accessibility on micro-interactions in Flutter apps.
