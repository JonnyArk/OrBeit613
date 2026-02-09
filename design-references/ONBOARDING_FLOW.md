# OrBeit Onboarding Flow — The Creation Narrative
> **Source:** User reference image + verbal description, Feb 8, 2026
> **This is the SOUL of the app experience.**

---

## THE NARRATIVE (User's Words, My Understanding)

### Act 1: Darkness
- App opens. There is NOTHING. Black void.
- The Or lighthouse fades in — center screen, glowing teal/blue with golden orbital rings.
- This is the only light source. She is your guide in the darkness.
- "You started in darkness. There's no foundation laid."

### Act 2: The Introduction (40 minutes)
- User meets the Or for the first time.
- Voice interaction, text, or both.
- The Or asks questions. Gets to know you.
- The dashboard panels appear around the lighthouse as the conversation progresses:

**Left side (Identity):**
- Blueprints — what do you want your house to look like?
- Relationship Graph — Self (Root). Who are the people in your life?
- Hardware Lab Status — what devices/infrastructure do you have?
- Security Pillar — Enable zero-knowledge encryption (toggle)

**Right side (Context):**
- Pulse Monitor — voice waveform (the Or is listening)
- Contextual Seeds — Import search history, Sync Gmail (so the Or knows you)
- Start Understanding / Connect with your Creator
- Hebrew Toggle — Gregorian or Hebrew calendar
- Promised Land Mode — Israeli flag toggle

**Bottom bar:**
- Navigate, Build, Focus, Defend — the four pillars
- These may be grayed out / locked until the house is placed

**Top:**
- ORBeit logo with crown
- Flow/Whisk credit counter: 25,000

### Act 3: Building the Blueprint
- User gives the Or a house image OR describes their house in words.
- The Or generates house options for the user to choose from (AI generation).
- User picks their house.
- The Or now has enough information: identity, relationships, house design, security settings.

### Act 4: The Foundation (THE MOMENT)
- The Or says something like: "Your foundation is ready. Shall I lay it?"
- User confirms.
- **THE DARKNESS LIFTS:**
  - Green grass grows outward from the lighthouse base
  - Blue sky fades in above
  - The house materializes in FRONT of the lighthouse
  - Trees, fences, driveway — the world appears
  - The lighthouse DIMS — it doesn't disappear, but it softens
  - It's no longer the blinding beacon — it's a gentle guardian spirit
  - "Like a spirit watching over you. It's there. It's bright. But it's not in your face."

### Act 5: You're Home
- The world view from the previous references takes over
- Your house with fenced yard, car, mailbox, road
- The lighthouse is always BEHIND the house, always visible
- Events start floating (deliveries, appointments)
- "HOME PROJECTS — FULFILLMENT LEVEL: 0% COMPLETE"
- Your journey begins.

---

## THE OR'S PRESENCE RULES

1. **Always visible** — The Or (lighthouse) is always somewhere on screen
2. **Always behind you** — Stands behind the house, like a guardian
3. **Dims in daylight** — When the world is lit, the Or softens. Not overpowering.
4. **Brightens in darkness** — In the setup screen, she's the only light
5. **Never in your face** — She's protective, not intrusive
6. **Like a spirit** — Watching over, not commanding

---

## THE DASHBOARD SCREEN (Pre-House)

### Visual Design
- **Background:** Black void with subtle gold geometric hex grid lines
- **Center:** Or lighthouse — teal/blue glow, golden atomic orbital rings
- **Light beam** shines down from lighthouse onto diamond surface
- **Panels:** Dark glass cards with gold borders, floating on left and right
- **Typography:** Clean, modern, white text with gold accents
- **Bottom toolbar:** Four gold icons in rounded dark containers

### Color Palette
- **Void Black:** #0A0A0F (background)
- **Or Teal:** #4FD1C5 (lighthouse glow)
- **Sovereign Gold:** #D4AF37 (orbital rings, borders, accents)
- **Panel Dark:** #1A1A2E with 80% opacity (card backgrounds)
- **Text White:** #F0F0F0 (primary text)
- **Accent Blue:** #29B6F6 (pulse monitor, active elements)

### Interactive Elements
- Blueprints button → Opens house design flow
- Relationship Graph → Add people
- Import Search History → OAuth flow
- Sync Gmail Context → OAuth flow
- Security Pillar toggle → Enable E2EE
- Hebrew Toggle → Switch calendar system
- Promised Land Mode → Regional settings
- Navigate / Build / Focus / Defend → Four app pillars

---

## TECHNICAL IMPLICATIONS

### What This Requires
1. **Scene-based rendering** — Not tile grids. Full-screen illustrated scenes.
2. **State machine for world creation:**
   - VOID → ONBOARDING → BLUEPRINT → FOUNDATION → WORLD_ALIVE
3. **Animated transitions:**
   - Darkness → grass growing → sky appearing → house materializing
4. **AI house generation:**
   - User uploads photo or describes house
   - Gemini/Whisk generates isometric house illustrations
   - User picks from options
5. **Dynamic lighthouse opacity:**
   - In void: full brightness, center stage
   - In world: dimmed, background presence, always behind house
6. **Dashboard HUD:**
   - Floating panels with gold borders
   - Voice waveform visualization
   - Credit counter
   - Toggle switches

### What We Keep (From Existing Build)
- All services (voice, cache, security, AI, device) ✅
- Database schema ✅
- Provider architecture ✅
- OrIntelligence brain ✅
- Firebase backend ✅
- The Or personality system prompt ✅
