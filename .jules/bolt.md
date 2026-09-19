## 2024-05-24 - Cap staggered animations on lazily loaded lists
**Learning:** In Flutter, using unbounded staggered animations (based on item index) on items inside a `ListView.builder` causes visual popping. When the user scrolls to items far down the list, those items get assigned large delays, delaying their mount and rendering.
**Action:** Cap the stagger delay conditionally based on the list position (e.g., `index < 10`). This retains the animation on initial load for the first items while instantly showing items that lazily load later upon scrolling.
