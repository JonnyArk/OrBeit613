## 2023-08-10 - Adding Dynamic Semantics to Visual UI Elements
**Learning:** Adding Semantics in Flutter with purely dynamic states requires a wrapper that dynamically accesses the relevant internal state properties. Static strings inside Semantics can fail to give full context for elements like Voice Assistants.
**Action:** Always map complex widget status types (like `VoiceStatus`) to user-friendly `label` and `hint` attributes inside the Semantics widget.
