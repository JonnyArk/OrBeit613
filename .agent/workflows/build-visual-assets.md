---
description: Phase 8 - Build and integrate visual assets
---

# Visual Assets Workflow

## Overview
Upgrade the BuildingComponent to render AI-generated assets and add more sprite variety.

## Step 1: Audit Current Sprites
// turbo
```bash
ls -la /Users/tekhletvault/OrBeit\ AG\ Build/app/assets/sprites/
```

## Step 2: Add AI-Generated Sprite Support

Modify `app/lib/game/building_component.dart`:

```dart
// Add to onLoad():
if (building.type == 'ai_generated') {
  // For now, use a distinctive placeholder
  // Future: Download from assetUrl
  spritePath = 'sprites/sanctum.png'; // Golden sanctum for AI buildings
}
```

## Step 3: Create Additional Sprites

Generate placeholder sprites for:
- [ ] `market.png` - Commercial building
- [ ] `workshop.png` - Workspace/office
- [ ] `garden.png` - Nature/wellness area
- [ ] `temple.png` - Spiritual/reflection space

Use generate_image tool or create 64x64 isometric PNGs.

## Step 4: Update pubspec.yaml Assets
// turbo
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build/app
grep -A20 "assets:" pubspec.yaml
```

Ensure all sprites are listed under assets.

## Step 5: Test Sprite Loading
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build/app
flutter run -d macos
```

Manually:
1. Click "Build" button
2. Place each building type
3. Verify sprites render correctly

## Step 6: Add Dynamic URL Loading (Advanced)

For true AI-generated assets:
1. Add `http` package dependency
2. Download image from Firebase Storage URL
3. Decode to ui.Image
4. Create Sprite from Image

```dart
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;

Future<Sprite> loadSpriteFromUrl(String url) async {
  final response = await http.get(Uri.parse(url));
  final codec = await ui.instantiateImageCodec(response.bodyBytes);
  final frame = await codec.getNextFrame();
  return Sprite(frame.image);
}
```

## Success Criteria
- All building types render with appropriate sprites
- No sprite loading errors in console
- AI-generated buildings show distinct visual

## Next Phase
After success, proceed to `/build-life-events-ui`
