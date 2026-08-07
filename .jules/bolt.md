## YYYY-MM-DD - Cap delayed animations in ListView.builder
**Learning:** In Flutter, applying staggered index-based animation delays (e.g., delay: i * 40ms) inside a lazy-loaded ListView.builder causes off-screen items to have massive delays when they are scrolled into view.
**Action:** When migrating such lists, cap the delay (e.g., math.min(i, 10) * 40) so that initial items stagger correctly but items scrolled into view appear immediately.
