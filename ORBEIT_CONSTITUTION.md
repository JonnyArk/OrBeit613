# ORBEIT: MASTER TECHNICAL CONSTITUTION (Project ID: orbeit-613)
**Role:** The Architect (You) -> The Builder (AI)
**Mandate:** Privacy is Law. Sovereignty is the Goal.

---

## I. THE PRIME DIRECTIVE: "PRIVACY IS LAW"
1.  **Zero-Knowledge Architecture:**
    *   We (the developers) and the Cloud **NEVER** see user data.
    *   All data is **Local-First**. Cloud is used only as a "Blind Relay" (encrypted blobs) or for anonymized inference.
2.  **The "Crumble to Dust" Protocol:**
    *   **Encryption:** The database is encrypted at rest using **SQLCipher**.
    *   **Key Management:** The 256-bit Master Key lives *only* in the device's **Secure Enclave** (iOS Keychain / Android Keystore). It is never logged or exported.
    *   **The Kill Switch:** If the "Crumble" function is triggered, the Master Key is deleted from the Enclave. The database remains on disk but becomes mathematically unrecoverable static.
3.  **The Redaction Layer:**
    *   No text leaves the device (to Cloud LLM) without passing through a local PII Stripper (Names, IDs, Locations removed).

---

## II. THE BERESHIT PROTOCOL (Folder Structure)
The codebase is strictly organized by the 7 Days of Creation. Logic must not bleed across days without an Interface.

*   **`lib/src/day1_or` (Light):** App Config, Environment (`.env`), Local Logging, Error Handling.
*   **`lib/src/day2_rakia` (Firmament):** API Bridges, The "Privacy Gate" (Redaction), **MCP (Model Context Protocol)** Servers (Standardized Tool Definitions for AI).
*   **`lib/src/day3_yabasha` (Land):** **Drift Database**, SQLCipher Implementation, Data Models (`Nodes`, `Relationships`), DAO.
*   **`lib/src/day4_moadim` (Time):** Temporal Engine, Cron Jobs, **Sabbath Mode Logic**, Event Queues.
*   **`lib/src/day5_sheretz` (Swarm):** Background Agents, Audio Processing (Whisper), Local LLM Hooks.
*   **`lib/src/day6_tzelem` (Image):** UI/UX, Flutter Widgets, **Flame Engine** (Spatial View).
*   **`lib/src/day7_shabbat` (Rest):** Unit Tests, Integration Tests, Documentation.

---

## III. THE SPRINGFIELD MODEL (Data Physics)
We do not use folders. We use a **Spatial Graph**.

1.  **Nodes (The Entities):**
    *   Table: `Nodes` (ID, Type, CreatedAt).
    *   Table: `NodeData` (Content, VectorEmbedding - *Encrypted*).
    *   *Types:* Home, Room, Object, Person, Agent.
2.  **Relationships (The Gravity):**
    *   Table: `NodeRelationships` (ParentID, ChildID, Type, Strength).
    *   *Logic:* `Home CONTAINS Truck` | `Truck CONTAINS Tool`.
    *   *Decay:* Relationship `Strength` (0.0-1.0) decays over time if not reinforced by the "Night Watch" agent.
3.  **Proximity Rule:**
    *   A user must be "in" a Node (virtually or physically) to access its deepest contents.

---

## IV. THE TECH STACK (Hard Constraints)
*   **Framework:** Flutter (MacOS/iOS/Android). **NO React Native.**
*   **Database:** Drift (SQLite) + **`sqflite_sqlcipher`** (Required for iOS/Android Parity). **NO Firebase/Firestore for user data.**
*   **Game Engine:** Flame (for 2.5D Isometric Spatial View).
*   **State Management:** Riverpod (Strict Provider Scope).
*   **AI:**
    *   **Gemini Nano:** On-Device (The Router/Privacy Guard).
    *   **Gemini Pro:** Cloud (The Teacher - Anonymized).

---

## V. THE MORAL ENGINE (Behavioral Laws)
1.  **Steward, Not Servant:**
    *   The AI acts as a Guide. It **MUST REFUSE** commands that violate the user's long-term well-being or privacy, even if requested.
2.  **Moznei Tzedek (Just Scales):**
    *   **Economic Constraint:** Algorithms must optimize for User Savings/Peace, not Platform Profit.
    *   If Deal A pays a commission but costs more, and Deal B is free, the System **MUST** recommend Deal B.
3.  **Sabbath Mode:**
    *   **Trigger:** Sunset Friday to Sunset Saturday (Local Time).
    *   **Effect:** Commerce/Labor nodes are muted. "Striving" UI features are locked. Only "Rest" and "Life Safety" logic remains active.

---

## VI. SURVIVAL PROTOCOLS
1.  **The "Ark" (Recovery):**
    *   On Day 1, generate a **BIP-39 Mnemonic Seed**. This is the *only* way to restore the Master Key. The user must write it down physically.
2.  **The "Menucha" State (Battery):**
    *   The Flame Engine loop must be **PAUSED** by default. It only renders frames upon User Input or Agent Event. **NO infinite game loops.**
3.  **The "Echo" (Sync):**
    *   Sync between devices (Mac/iPhone) uses a "Blind Relay." Data is encrypted *before* upload. The Cloud sees only opaque binary blobs.

---

## VII. AUDIO & HARDWARE MANDATES
1.  **The Medallion Rule:**
    *   Audio is recorded to a **24-hour circular buffer**.
    *   Old audio is cryptographically overwritten.
2.  **Local Processing:**
    *   Transcription (Whisper) and VAD (Voice Activity Detection) happen **On-Device**.
    *   Raw audio **NEVER** leaves the device. Only the transcribed, redacted text is processed.
