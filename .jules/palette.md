## YYYY-MM-DD - Replace GestureDetector with IconButton for accessibility
**Learning:** Using GestureDetector on small icons prevents them from being accessible via screen readers or keyboard navigation.
**Action:** Always replace icon-only GestureDetectors with IconButton. Set padding: EdgeInsets.zero and constraints: const BoxConstraints() to prevent layout breaking, and add a tooltip.
