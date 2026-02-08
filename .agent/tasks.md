# OrBeit Coordination Board: The Path to Sovereignty

This board orchestrates autonomous agents for the OrBeit Sovereign Life OS.
Each task is atomic. Agents pick the highest priority UNCLAIMED task.
When claiming, update Status to `IN_PROGRESS` and add your Agent ID.

## 🔴 CRITICAL PATH (Blockers)

- [ ] **[SETUP] Google AI Configuration**
  - **Required:** Set `GOOGLE_AI_ULTRA_KEY` in Firebase Secrets.
  - **Why:** Needed for `generateAsset` and `distillContext` cloud functions.
  - **Agent Action:** Validate key presence via `firebase functions:secrets:access GOOGLE_AI_ULTRA_KEY`.

- [ ] **[ASSETS] Genesis Sprite Pack**
  - **Required:** Visual assets for the Steward Archetype.
  - **Why:** Currently using geometric placeholders. Need `farmhouse.png`, `barn.png`, `truck.png`.
  - **Agent Action:** Check `app/assets/sprites/`. If missing, generate via DALL-E/Midjourney integration or prompt user.

## 🟡 CORE DEVELOPMENT (In Flight)

- [ ] **[FEAT-001] Covenant Gate Logic**
  - **Status:** COMPLETED (Code written)
  - **Verification:** Run app, click "I VOW", verify database population.

- [ ] **[FEAT-002] Visual Rendering of Genesis Kit**
  - **Status:** PENDING
  - **Goal:** Ensure `GenesisRepository` spawned items actually appear on the `IsometricGrid`.
  - **Dependencies:** Sprite Pack.

- [ ] **[FEAT-003] Life Event Logging**
  - **Status:** PENDING
  - **Goal:** Create UI to log "Bought Feed" -> Distill via AI -> Save to `LifeEvents` table.

## 🟢 OPTIMIZATION & POLISH

- [ ] **[UX] Voice Input Layer**
  - **Goal:** Add "Push-to-Talk" mic button for hands-free logging.
  
- [ ] **[DATA] Backup Protocol**
  - **Goal:** Implement the "Orbi-Key" local backup logic (export SQLite to JSON/Zip).

## 📝 NOTES FOR AGENTS

- **Strict Mode:** No external API calls without user consent.
- **Privacy:** User data stays in `Drift` (SQLite). Cloud Functions only see anonymized context or generic requests.
- **Aesthetic:** Sovereign Gold (`0xFFD4AF37`) on Void Black (`0xFF1A1A2E`).
