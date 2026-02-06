---
description: Phase 7 - Setup development environment (CocoaPods, etc.)
---

# Environment Setup Workflow

## Blockers (Require User)
This phase requires `sudo` access for CocoaPods installation.

## Step 1: Check Current State
// turbo
```bash
which pod && echo "✅ CocoaPods installed" || echo "❌ CocoaPods not installed"
which brew && echo "✅ Homebrew installed" || echo "❌ Homebrew not installed"
```

## Step 2: Install CocoaPods (REQUIRES USER)
Run this command manually (needs sudo password):
```bash
sudo gem install cocoapods
```

## Step 3: Initialize Pod Project
// turbo
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build/app/macos
pod install --repo-update
```

## Step 4: Verify macOS Build
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build/app
flutter build macos --debug 2>&1 | tail -20
```

## Step 5: Test Run
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build/app
flutter run -d macos
```

## Success Criteria
- `flutter build macos --debug` completes without CocoaPods error
- App launches and shows game screen

## If CocoaPods Install Fails
Alternative methods:
1. Via Homebrew: `brew install cocoapods`
2. Via Ruby bundler: Create Gemfile and use `bundle install`

## Next Phase
After success, proceed to `/build-visual-assets`
