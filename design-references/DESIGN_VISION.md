# OrBeit Design Vision
> **Source:** User reference images, Feb 8 2026
> **Status:** This is the TARGET. Everything built so far needs to evolve toward this.

---

## Art Style: Rich Illustrated Isometric

NOT pixel art. NOT flat design. NOT tiny tile grids.

**Think:** Hay Day meets life management. Hand-painted illustration style.
- Warm, earthy color palettes (brown, cream, gold, green)
- Rich detail in every scene (individual objects, textures, shadows)
- Soft lighting with glowing highlights (the Or symbol)
- Full-screen illustrated scenes, not stamp-sized tiles on a grid

---

## THREE ZOOM LEVELS

### Level 1: World View (Neighborhood / Property)
- **Reference:** House with fenced yard, garage, car, mailbox, road
- Full property visible in isometric view
- The Or lighthouse sits ON the house, pulsing beacon rings
- Floating event bubbles (📦 Delivery, 🔧 2 PM Tomorrow)
- Bottom bar: "HOME PROJECTS" + "FULFILLMENT LEVEL: 35% COMPLETE"
- Or icon in bottom-left corner
- Road/map visible at edges suggesting wider world
- Tap a building → zoom into it

### Level 2: Floor Plan View (Building Interior Layout)
- **Reference:** Top-down floor plan showing rooms
- Clean architectural view of rooms
- Each room shows: name, item count, active task count
- "Tap to Zoom" hints on rooms
- Tap a room → zoom into detailed isometric interior

### Level 3: Room Interior (Detailed Isometric Scene)
- **Reference:** Barn interior, Doctor's office, Home office
- Full-screen isometric scene of ONE room
- Every object is visible and detailed (hay bales, chickens, desks, computers)
- The Or symbol glows somewhere in the scene
- Data panel slides in from the side when you interact
  - Doctor's office → shows Dr. Mitchell, phone, appointments, visit history
  - Barn → shows animals, feed schedule, tasks
  - Office → interactive hotspots: "Click Desk", "Digital Matrix", "The Safe"
- Bottom toolbar shows clickable zones within the room

---

## KEY UI PATTERNS

### Floating Data Bubbles
- Events appear as floating icons near buildings
- Show time (2 PM Tomorrow), type (Delivery), status (wrench)

### Side Panels
- Doctor contact info, visit history
- Slide in from right side
- Dark background, clean white text

### Bottom Toolbar
- Room hotspots with icon + label: "Click Desk", "Digital Matrix", "The Safe"
- Styled buttons with wooden/gold frame aesthetic
- Navigation icons in the corners

### The Or
- Glowing golden symbol (not a generic orb — it's the Or logo)
- Lives on the lighthouse beacon in world view
- Lives as a wall-mounted glow in room views
- Pulsing rings emanate from it

### Progress Metrics
- "FULFILLMENT LEVEL: 35% COMPLETE" bar at bottom
- Task counts per room
- Item counts per room

---

## WHAT THIS MEANS FOR THE BUILD

### Current State: Small tile grid with tiny sprites
### Target State: Full-screen illustrated scenes with interactive objects

### The Gap
1. **Art:** Need full-scene illustrations, not 64px sprites
2. **Navigation:** Need 3-level zoom (world → floor plan → room)
3. **Interaction:** Need tappable objects within rooms, not just buildings
4. **Data overlay:** Need floating bubbles and slide-in panels
5. **Progress:** Need fulfillment tracking and per-room metrics

### What to Keep
- All service layer code (voice, cache, security, AI) ✅
- Database schema and repositories ✅
- Provider architecture ✅
- The Or intelligence layer ✅
- Firebase backend ✅

### What Needs to Change
- Game rendering approach (scene-based, not tile-grid)
- Navigation flow (zoom levels instead of flat world)
- UI overlay system (data panels, floating bubbles)
- Art assets (full illustrations instead of tiny sprites)
