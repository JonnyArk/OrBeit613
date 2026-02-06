---
description: Continue building from current state - autonomous execution
---

# Continue Build Workflow
// turbo-all

This workflow picks up development from the current state and continues until blocked.

## Step 1: Verify Environment
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build/app
flutter --version && echo "✅ Flutter OK" || echo "❌ Flutter not found"
```

## Step 2: Check Dependencies
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build/app
flutter pub get
```

## Step 3: Run Full Analysis
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build/app
dart analyze lib/
```

## Step 4: Identify Current Phase
Check the master workflow status:
1. Read `/Users/tekhletvault/OrBeit AG Build/.agent/workflows/master.md`
2. Find the first unchecked `[ ]` item
3. Execute that phase's workflow

## Step 5: Execute Next Phase

### If Phase 7 (Environment Setup):
- Check for CocoaPods: `which pod`
- If missing, notify user to run: `sudo gem install cocoapods`
- After install: `cd app/macos && pod install`

### If Phase 8 (Visual Assets):
- Verify sprites exist: `ls app/assets/sprites/`
- Add AI-generated sprite handling to BuildingComponent
- Test with: `flutter run -d macos`

### If Phase 9 (LifeEvents UI):
- Create `lib/ui/life_events_timeline.dart`
- Add timeline view to main screen
- Wire to LifeEventRepository

### If Phase 10 (Task-Building Integration):
- Modify BuildingComponent to show task indicators
- Create task marker sprites
- Connect taps to task panel

## Step 6: Commit Progress
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build
git add -A
git commit -m "chore: Phase [N] complete - [description]"
git push
```

## Step 7: Update Master Workflow
Mark completed phase with `[x]` in master.md

## Step 8: Loop
Return to Step 4 unless:
- All phases complete
- Blocker encountered requiring user input
- Critical error found

## Blockers That Require User
- sudo password needed (CocoaPods)
- App Store credentials
- Firebase project configuration
- API key provisioning
