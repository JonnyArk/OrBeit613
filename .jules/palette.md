## $(date +%Y-%m-%d) - Adding accessibility labels to OrBeacon

**Learning:** AI components like `OrBeacon` that rely heavily on visual state changes (like pulsing and color changes) lack inherent semantic meaning for screen readers. Screen readers will just announce them as "button" without explaining context like "Listening" or "Processing".
**Action:** Always wrap visual AI feedback components in a `Semantics` widget that dynamically updates its `label` and `hint` based on the internal state (e.g. `voiceStatus`).
