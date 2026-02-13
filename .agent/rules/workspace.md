# ⚠️ WORKSPACE RULE — READ BEFORE DOING ANYTHING ⚠️

## 🏛️ CONSTITUTION FIRST

**Before you write a single line of code, read:**
```
/Users/tekhletvault/OrBeit AG Build/ORBEIT_CONSTITUTION.md
```
This is the supreme authority for this project. All architectural decisions,
privacy constraints, folder structures, and tech stack choices are defined there.
If anything in the codebase contradicts the Constitution, the Constitution wins.

---

## Single Workspace Policy

**Established:** 2026-02-13 by project owner (tekhletvault)

### THE RULE

There is **ONE and ONLY ONE** workspace for the OrBeit project:

```
/Users/tekhletvault/OrBeit AG Build/
```

**GitHub remote:** `https://github.com/JonnyArk/OrBeit613.git`

### WHAT YOU MUST NEVER DO

1. **NEVER clone the repo again** into a subdirectory, temp folder, or anywhere else on this machine.
2. **NEVER create a "fresh_app"**, "clean_copy", "backup_clone", or any variant.
3. **NEVER `git clone`** this repo anywhere other than the path above.
4. **NEVER create a second Flutter project** inside this workspace (e.g., inside `Torah Hebrew/`, `tmp/`, etc.).

### WHY

On 2026-02-13, a duplicate clone was discovered nested inside `Torah Hebrew/fresh_app/`.
This caused:
- Split-brain development (two diverged copies of the same code)
- Confusion about which copy had the latest work
- Wasted hours reconciling changes

### IF YOU NEED A CLEAN STATE

```bash
cd "/Users/tekhletvault/OrBeit AG Build"
git stash        # save current work
git pull         # get latest from GitHub
flutter clean    # clean build artifacts
flutter pub get  # reinstall dependencies
```

**DO NOT** create a new clone. Fix the existing one.

### THE FLUTTER APP LIVES AT

```
/Users/tekhletvault/OrBeit AG Build/app/
```

This is the ONLY Flutter project. There is no other.
