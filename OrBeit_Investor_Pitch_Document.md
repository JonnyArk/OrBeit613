# OrBeit

## The Sovereign Life Operating System

**Confidential Investment Memorandum**  
**Version 1.0 | February 2025**

---

# Executive Summary

OrBeit is a **spatial life management platform** that transforms how people organize their digital lives. Instead of scattered apps and endless lists, users manage their world through an interactive visual environment—their home, their property, their relationships—rendered as a navigable game world.

**The Problem:** The average person uses 80+ apps. Their life data is fragmented across calendars, reminders, health apps, banking apps, and note-taking tools. No single interface connects it all. Meanwhile, every app monetizes their attention and sells their data.

**The Solution:** OrBeit unifies life management into a single spatial interface. Tasks live where they belong—the broken fence appears on your property, the doctor's appointment exists at the clinic, the grocery list lives in your kitchen. Voice-first interaction makes capture effortless. And critically: **we never see your data.**

**The Business Model:** We reject advertising and data brokerage. Instead, OrBeit acts as the user's **private purchasing agent**—finding deals on things they already need and earning affiliate commissions when they buy. We only profit when we save them money.

**The Opportunity:** $4.2B productivity app market. 500M+ users of life management tools globally. Zero competitors offering spatial, voice-first, privacy-respecting life management.

**The Ask:** $2.5M seed round to complete development and launch beta within 10 months.

---

# Part 1: The Vision

## What Is OrBeit?

OrBeit (Hebrew: אור בית — "Light of the House") is a **Life Operating System** built on two principles:

| Layer | Name | Function |
|-------|------|----------|
| **The Beit** | The House | The structure of your life—places, people, things, tasks—stored locally, rendered spatially, owned entirely by you |
| **The Or** | The Light | The intelligence layer—voice commands, pattern recognition, proactive assistance—that illuminates your world |

The House stands even when the Light dims. OrBeit works fully offline. The AI enhances but never controls.

## Why Spatial?

Human memory is spatial. We remember *where* we put things, *where* conversations happened, *where* tasks need to be done. List-based productivity apps fight this instinct. OrBeit embraces it.

**Example:** You need to fix your fence.

| Traditional App | OrBeit |
|-----------------|--------|
| Add task: "Fix fence" to a list with 47 other items | Speak: "Remind me to fix the fence" → Task appears as a glowing marker *on the fence* in your property view |
| Task gets buried, forgotten | Every time you see your property, the task is visible in context |
| No connection to materials, costs, or help | OrBeit knows you need fence posts → Finds the best local price → Notifies you when they're on sale |

## The "Springfield Model"

We don't render a 1:1 GPS map of reality. We render **a map of what matters.**

Think of *The Simpsons*' Springfield: Homer's house is next to Moe's Tavern is next to the Nuclear Plant—not because they're geographically adjacent, but because they're *relationally* adjacent in Homer's life.

OrBeit works the same way:
- Your house is the center
- Mom's house appears nearby (even if she's 500 miles away) because she's important
- Your workplace appears on your "commute path"
- The doctor's office exists in your world only when you have an appointment

**The user builds their own world.** They add locations that matter. They place buildings from an asset library. They customize, rotate, delete. No AI hallucinations. No wrong guesses. Complete user control.

---

# Part 2: The Differentiation

## Why OrBeit Wins

### 1. Privacy as Architecture, Not Policy

Most apps promise privacy in their terms of service, then collect everything anyway. OrBeit is **architecturally incapable** of seeing your data.

| What We Do | How It Works |
|------------|--------------|
| **Local-First Storage** | All data lives on your device in an encrypted SQLite database. We never have the keys. |
| **Zero-Knowledge Sync** | When you sync between devices, we relay encrypted blobs. We cannot read them. |
| **Anonymized AI** | When cloud AI is needed, we strip all identifying information locally before transmission. The cloud sees "User X has symptom Y"—never your name, location, or identity. |

**Legal Positioning:** We cannot be subpoenaed for user data because we do not possess it. This is not a policy choice—it's a technical reality.

### 2. The "Buyer's Agent" Revenue Model

Traditional apps either:
- Charge subscriptions (user pays)
- Sell ads (user is the product)
- Sell data (user is exploited)

OrBeit does none of these. We act as your **private purchasing agent.**

**How It Works:**
1. OrBeit knows you need new tires (it's a task in your world)
2. OrBeit anonymously searches the market for the best price
3. OrBeit presents you the deal: "I found these tires 23% off at Tire Rack"
4. If you buy, OrBeit earns an affiliate commission

**The Alignment:** We only make money when we save you money. We never profit from your attention. We never sell your data. Our incentives are perfectly aligned with yours.

**Revenue Projections:**
| Metric | Conservative | Moderate | Aggressive |
|--------|--------------|----------|------------|
| Users (Year 2) | 100,000 | 250,000 | 500,000 |
| Transactions/User/Year | 5 | 8 | 12 |
| Avg Commission | $8 | $12 | $15 |
| Annual Revenue | $4M | $24M | $90M |

### 3. Voice-First, Not Voice-Only

Siri, Alexa, and Google Assistant failed to become life management tools because they have no memory and no context. They answer questions; they don't manage lives.

OrBeit is different:
- **Contextual Memory:** "Remind me about this when I see John" actually works—because OrBeit knows who John is, where you typically see him, and what "this" refers to
- **Spatial Awareness:** "Add this to the kitchen list" knows which list, which kitchen, which context
- **Pattern Recognition:** OrBeit notices you always forget to take medication on Tuesdays and proactively reminds you

Voice is the primary input. But the spatial world is the primary interface. They work together.

### 4. Family Without Surveillance

Existing family apps (Life360, Apple Family Sharing) are surveillance tools dressed as safety features. Parents track children. Partners track partners. Trust erodes.

OrBeit reimagines family sharing:

| Feature | How It Works |
|---------|--------------|
| **Sovereign Worlds** | Every family member has their own OrBeit world. No one sees it without permission. |
| **Guest Passes** | You grant access to specific "rooms" of your world. Your teenager might share their calendar but not their journal. |
| **Revocable Access** | Any permission can be revoked instantly, without notifying the other party. |
| **Duress Protocol** | If someone is forced to unlock their phone, a secret PIN reveals a "sanitized world"—real enough to satisfy the aggressor, but hiding the Safe, the Journal, and any escape plans. |

We teach digital autonomy, not submission. Children learn to manage their own worlds with graduated independence.

### 5. The "Digital Estate" Problem (Solved)

When someone dies, their digital life typically dies with them—or becomes a legal nightmare. Photos locked in iCloud. Passwords unknown. Accounts inaccessible.

OrBeit introduces the **Orbi-Key**:
- A physical hardware device (NFC/USB) that holds an encrypted backup of your world
- Designated heirs can inherit the key and restore your digital estate
- No Apple, Google, or OrBeit permission required
- Your legacy transfers as cleanly as a physical key to a safe deposit box

---

# Part 3: The Technology

## The Stack (Google Ecosystem Native)

OrBeit is built entirely on Google's development infrastructure. This is strategic:
- **Flutter** for cross-platform development (iOS, Android, Web, Desktop from one codebase)
- **Firebase** for authentication and encrypted sync relay
- **Vertex AI** for cloud intelligence (with anonymization)
- **Gemini Nano** for on-device AI (no internet required)
- **Google Cloud Storage** for asset library CDN

**Why This Matters to Google:**
- OrBeit drives engagement with Google services (Calendar, Tasks, Drive)
- We showcase Gemini Nano's on-device capabilities in a consumer app
- We prove Flutter can build sophisticated, performant applications
- We're a reference implementation for Google's "AI on the Edge" strategy

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                           USER DEVICE                               │
│                                                                     │
│   ┌─────────────┐    ┌─────────────┐    ┌─────────────────────┐    │
│   │  Flutter UI │    │ Flame Engine│    │   Gemini Nano       │    │
│   │  (Widgets)  │    │ (Game World)│    │   (Local AI)        │    │
│   └──────┬──────┘    └──────┬──────┘    └──────────┬──────────┘    │
│          │                  │                      │               │
│          └──────────────────┼──────────────────────┘               │
│                             │                                      │
│                      ┌──────▼──────┐                               │
│                      │   Drift DB  │  ← Encrypted SQLite           │
│                      │  + PowerSync│  ← CRDT Sync Engine           │
│                      └──────┬──────┘                               │
│                             │                                      │
└─────────────────────────────┼──────────────────────────────────────┘
                              │
                    (Encrypted deltas only)
                              │
                              ▼
                 ┌────────────────────────┐
                 │   Firebase (Relay)     │  ← Cannot read data
                 │   • Authentication     │
                 │   • Encrypted Sync     │
                 │   • Asset CDN          │
                 └────────────┬───────────┘
                              │
            ┌─────────────────┼─────────────────┐
            ▼                 ▼                 ▼
       [Device B]       [Device C]       [Vertex AI]
                                         (Consent-gated,
                                          anonymized only)
```

## The Data Model

OrBeit stores life as a **property graph**:

| Element | Examples | Properties |
|---------|----------|------------|
| **Nodes** | Home, Mom, Truck, Dr. Smith, "Fix Fence" task | Type, name, position, asset reference, custom metadata |
| **Edges** | Home CONTAINS Truck, User KNOWS Dr. Smith, Truck NEEDS OilChange | Relationship type, strength, metadata |

This allows queries like:
- "What tasks are associated with my property?" (traverse edges from Home)
- "When did I last see Dr. Smith?" (check edge metadata)
- "What's the maintenance history of my truck?" (traverse all edges of type NEEDS)

## Offline Resilience

OrBeit works **100% offline**. The House (structure, data, visualization) never requires internet. The Light (AI assistance) gracefully degrades:

| Connectivity | AI Capability |
|--------------|---------------|
| **Full Internet** | Complete Gemini Pro analysis, deal-finding, complex synthesis |
| **Limited Internet** | Basic sync, notifications, simple cloud queries |
| **Offline** | Full local Gemini Nano: intent parsing, asset search, reminders, navigation |
| **No AI at all** | Manual mode: tap-based interface, all data accessible, just no voice/AI features |

Users are never stranded. The app is always functional.

## Sync Without Conflict

Traditional sync creates conflicts: "You edited on your phone while your wife edited on the tablet. Which version wins?"

OrBeit uses **CRDTs (Conflict-free Replicated Data Types)**:
- We don't sync "state" (the final list)
- We sync "events" (the actions taken)
- Both devices replay all events and arrive at the same result
- Your milk + her eggs = both items on the list, always

No data loss. No rage. No manual conflict resolution.

---

# Part 4: The Business

## Market Opportunity

| Segment | Size | OrBeit Position |
|---------|------|-----------------|
| Productivity Apps | $4.2B (2024) | Spatial differentiation in a list-dominated market |
| Personal Finance Apps | $1.3B | Intent-based finance without Plaid liability |
| Family Safety Apps | $800M | Privacy-respecting alternative to surveillance tools |
| Password/Identity Management | $2.1B | The Safe + Orbi-Key as digital estate solution |

**Total Addressable Market:** $8.4B+

**Target User:** Property owners, families, and professionals managing complex lives who are frustrated with app fragmentation and concerned about privacy.

## Competitive Landscape

| Competitor | What They Do | Why We Win |
|------------|--------------|------------|
| **Notion/Obsidian** | Document-based "second brain" | We're spatial, not textual. Voice-first, not keyboard-first. |
| **Apple Reminders** | Simple task lists | No spatial context. No AI. No cross-platform. |
| **Life360** | Family location tracking | Surveillance, not sovereignty. We offer consent-based sharing. |
| **Mint/YNAB** | Financial tracking | We track *goals*, not bank accounts. No Plaid liability. |
| **Siri/Alexa/Google** | Voice assistants | No persistent memory. No spatial interface. No life context. |

**No direct competitor** offers spatial + voice-first + privacy-native + family-safe life management.

## Revenue Streams

| Stream | Model | Timeline |
|--------|-------|----------|
| **Buyer's Agent** | Affiliate commission on purchases | Launch |
| **Patron Tier** | $9.99/month for cloud backup, priority AI, family sharing | Month 6 |
| **Orbi-Key Hardware** | $79 hardware device for cold storage | Year 2 |
| **Enterprise/Family Plans** | $29.99/month for family of 5 | Year 2 |

## Go-to-Market Strategy

**Phase 1: Beachhead (Months 1-6)**
- Target: Property owners with land, animals, vehicles (rural/suburban power users)
- Channel: Content marketing (YouTube, homesteading communities, prepper forums)
- Message: "Finally, an app that understands your property, not just your calendar"

**Phase 2: Expansion (Months 7-12)**
- Target: Families with children, multi-generational households
- Channel: Parenting communities, family safety advocates, privacy-focused media
- Message: "Family sharing without surveillance"

**Phase 3: Mainstream (Year 2+)**
- Target: General productivity users frustrated with app fragmentation
- Channel: App Store featuring, productivity influencers, word of mouth
- Message: "Your life, visualized. Your data, protected."

---

# Part 5: The Build Plan

## Development Roadmap

| Phase | Weeks | Deliverables |
|-------|-------|--------------|
| **Foundation** | 1-6 | Flutter + Flame scaffold, grid rendering, basic asset placement, Drift DB, Gemini Nano integration |
| **Core Features** | 7-14 | Full asset library, interior views, task system, people/contacts graph |
| **Intelligence** | 15-20 | Voice input, contextual reminders, Vertex AI integration with anonymization |
| **Security** | 21-26 | Multi-device sync, The Safe, Orbi-Key protocol, Duress Protocol |
| **Integrations** | 27-34 | Google Calendar, Google Tasks, Health/Fitness, Intent-Based Finance |
| **Polish** | 35-40 | Onboarding, performance optimization, beta launch |

**Total Timeline:** 10 months to beta

## The Tracer Bullet (First Milestone)

Before building everything, we prove the architecture works with the smallest possible slice:

**"My House + One Task"**
1. Open app → See an empty isometric grid
2. Tap "Add Building" → Type "white farmhouse"
3. Gemini Nano parses intent → Shows 5 house assets
4. User taps one → House appears on grid
5. User drags to reposition → House moves
6. User adds task: "Fix the fence" → Task marker appears
7. Close app → Reopen → Everything persists

**Timeline:** 4-6 weeks  
**Budget:** $50,000 (contractor development)  
**Success Criteria:** Proves Flutter + Flame + Drift + Gemini Nano work together

## Team Requirements

| Role | Responsibility | Status |
|------|----------------|--------|
| **Founder/Visionary** | Product direction, fundraising, partnerships | ✅ Filled |
| **Flutter Lead** | Core app development, Flame integration | 🔴 Hiring |
| **Backend Engineer** | Firebase, PowerSync, Vertex AI integration | 🔴 Hiring |
| **AI/ML Engineer** | Gemini Nano optimization, intent parsing | 🔴 Hiring |
| **Designer** | Asset library, UI/UX, onboarding flows | 🔴 Hiring |

## Configuration Manifest

**API Keys Required:**
- Google Maps Static API (property screenshot assist)
- Vertex AI API (cloud AI)
- Firebase Project (auth, sync, storage)
- Google AI Edge SDK (Gemini Nano)

**Test Devices:**
- Primary: Pixel 8/9 Pro (Gemini Nano native)
- Secondary: Samsung S24 (Gemini Nano supported)
- Tertiary: iPhone 15 (Flutter compatibility, no Gemini Nano—TensorFlow Lite fallback)

**Repository Structure:**
```
orbeit/
├── lib/
│   ├── main.dart
│   ├── game/
│   │   ├── springfield_game.dart
│   │   ├── world_grid.dart
│   │   └── components/
│   ├── data/
│   │   ├── database.dart
│   │   ├── models/
│   │   └── sync/
│   ├── ai/
│   │   ├── intent_parser.dart
│   │   ├── asset_search.dart
│   │   └── anonymizer.dart
│   └── ui/
│       ├── screens/
│       └── widgets/
├── assets/
│   ├── buildings/
│   ├── vehicles/
│   ├── furniture/
│   └── icons/
├── test/
└── pubspec.yaml
```

**Branching Strategy:**
- `main` — Production-ready code only
- `develop` — Integration branch
- `feature/*` — Individual features
- `hotfix/*` — Emergency fixes

---

# Part 6: The Ask

## Funding Requirements

**Seed Round:** $2.5M

| Allocation | Amount | Purpose |
|------------|--------|---------|
| **Engineering** | $1.5M | 4 engineers × 18 months |
| **Design** | $300K | Asset library creation, UI/UX |
| **Infrastructure** | $200K | Firebase, Vertex AI, cloud costs |
| **Legal** | $150K | Privacy compliance, terms of service, patent filing |
| **Marketing** | $200K | Beta launch, content creation, community building |
| **Operations** | $150K | Office, equipment, miscellaneous |

## Milestones

| Milestone | Timeline | Deliverable |
|-----------|----------|-------------|
| **Tracer Bullet** | Month 2 | Working prototype: grid + asset + persistence |
| **Alpha** | Month 5 | Core features complete, internal testing |
| **Closed Beta** | Month 8 | 500 users, feedback collection |
| **Public Beta** | Month 10 | App Store/Play Store launch |
| **Revenue** | Month 12 | Buyer's Agent active, first commissions |

## Why Now?

1. **On-Device AI is Finally Real:** Gemini Nano and Apple Intelligence make local, private AI processing possible for the first time
2. **Privacy Backlash is Mainstream:** Post-Cambridge Analytica, post-Roe, users actively seek privacy-respecting alternatives
3. **App Fatigue is Peak:** 80+ apps per user, declining engagement, openness to unified solutions
4. **Google is Investing Heavily:** Flutter, Gemini, Firebase—the stack we need is being actively developed and promoted

## The Vision

OrBeit is not just an app. It's a new paradigm for how humans interact with their digital lives.

We believe:
- Your data is your property, not a commodity
- Your attention is sacred, not for sale
- Your family deserves sovereignty, not surveillance
- Your life deserves a control room, not a to-do list

We're building the interface layer between humans and their increasingly digital existence—with the user's interests as the only north star.

**The house is designed. The light is ready. Let's build.**

---

# Appendix A: Glossary

| Term | Definition |
|------|------------|
| **The Beit** | The local, offline-capable structure layer (database, visualization, user data) |
| **The Or** | The AI intelligence layer (voice parsing, pattern recognition, proactive assistance) |
| **Springfield Model** | User-centric world building where relational importance trumps geographic accuracy |
| **The Safe** | Air-gapped encrypted storage for the most sensitive data (never syncs to cloud) |
| **Orbi-Key** | Physical hardware device for cold storage backup and digital estate transfer |
| **Duress Protocol** | Secret PIN that reveals a sanitized "dummy world" if user is forced to unlock |
| **Buyer's Agent** | Revenue model where OrBeit earns commissions by finding deals for users |
| **CRDT** | Conflict-free Replicated Data Type—sync protocol that merges changes without conflicts |
| **Tracer Bullet** | Minimum viable prototype that proves all layers of the architecture work |

---

# Appendix B: Risk Analysis

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Gemini Nano limited device support | High | Medium | TensorFlow Lite fallback for unsupported devices |
| Asset library too large for mobile | Medium | Medium | Cloud streaming + aggressive cache eviction |
| Voice-first drains battery | Medium | Low | Push-to-talk default, always-on optional |
| Users don't understand spatial metaphor | Medium | High | Strong onboarding, seeded starter worlds |
| Buyer's Agent revenue insufficient | Medium | High | Patron subscription tier as backup revenue |
| Hardware (Orbi-Key) delays launch | Low | Low | V1 uses encrypted file export; hardware is V2 |
| Competitor copies model | Low | Medium | First-mover advantage, patent protection, brand trust |

---

# Appendix C: Contact

**Project Lead:** [Your Name]  
**Email:** [your@email.com]  
**Location:** Dardanelle, Arkansas  

---

*This document is confidential and intended for potential investors and strategic partners only.*
