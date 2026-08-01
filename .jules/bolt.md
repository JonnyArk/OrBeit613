## YYYY-MM-DD - Capping Animation Delays in Lazy Lists
**Learning:** In Flutter, applying an unbounded index-based animation delay inside a lazy-loaded ListView.builder causes massive delays for off-screen items when scrolled into view.
**Action:** When applying staggered animations to lists, always cap the delay multiplier (e.g., math.min(index, 10)) to ensure items appearing later render immediately.
