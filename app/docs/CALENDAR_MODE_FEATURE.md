# OrBeit - Calendar Mode & Cultural Identity Feature

## Vision

During onboarding, users choose between **Western** and **Hebrew** calendar modes.
This choice ripples through the entire app experience — from visual tone to world
structures to notification behavior.

## Feature: Calendar Choice (Onboarding)

### Flow
1. User names their world (existing "Foundation" stage)
2. **NEW: Calendar Choice** — two glowing cards:
   - ☀️ **Western**: Gregorian calendar, standard schedule, modern structures
   - 🕯️ **Hebrew**: Hebrew calendar, Shabbat observance, Tabernacle, Hebrew tint
3. "Let there be light" → world creation with chosen identity

### Status: ✅ IMPLEMENTED
- `CalendarMode` enum with extensions (`lib/domain/entities/calendar_mode.dart`)
- `CalendarModeService` with Shabbat detection + Hebrew tint palette (`lib/services/calendar_mode_service.dart`)
- `CalendarChoiceScreen` with animated cards (`lib/presentation/screens/calendar_choice_screen.dart`)
- Provider wiring in `service_providers.dart` + `main.dart`
- Onboarding flow updated with new `theCalendar` stage

---

## Feature: Hebrew Mode Effects

### Shabbat Observance
- **Detection**: Friday 6PM → Saturday 7PM (approximate sunsets)
- **Behavior**: `CalendarModeService.isShabbatActive` → `shouldSuppressNotifications`
- **Visual**: App dims with candlelight palette (warm golds, deep blues)
- **Future**: GPS-based sunset calculation via hebcal

### Tabernacle (Mishkan)
- **Spawn**: When Hebrew mode is chosen, `mishkan_tabernacle` building is placed at (15, 8)
- **Permanent**: Cannot be removed — it's the heart of the Hebrew world
- **Sprite**: Needs a proper Hebrew tent sprite (not a camping tent!)
- **Future**: Rendered as a proper biblical tabernacle with courtyard

### Hebrew Tint
- **Normal**: Desert night palette — warm purples, sandstone text, gold dust particles
- **Shabbat**: Candlelight palette — deep Shabbat blue, warm candle gold, subdued shimmer
- **Access**: `CalendarModeService.hebrewTint` returns a `HebrewTint` object

### Hebrew Day Display
- Days named in Hebrew: Yom Rishon, Yom Sheni, etc.
- Shabbat greeting: "🕯️ Shabbat — Shabbat Shalom"
- **Future**: Full Hebrew date display (month, day, year)

---

## Feature: Photo-to-Building (AI Dwelling Capture)

### Flow
1. "Would you like your world to feel like home?"
2. 📸 Take Photo / 📁 Choose Photo / ⏭️ Skip
3. AI analyzes: architectural style, colors, features
4. Preview + Confirm or Retake
5. AI maps style → game building type

### Status: ✅ IMPLEMENTED (MVP / Scaffolded)
- `PhotoBuildingService` (`lib/services/photo_building_service.dart`)
- `PhotoHomeScreen` (`lib/presentation/screens/photo_home_screen.dart`)
- `image_picker` dependency added
- AI analysis: currently returns fallback; wired for Gemini Vision integration

### Architecture Mapping
| Real-World Style | Game Building |
|-----------------|---------------|
| Colonial | farmhouse_white |
| Modern | modern_office |
| Cottage/Ranch | farmhouse_base |
| Cabin | cabin_wood |
| Apartment | modern_office |
| Townhouse | townhouse_brick |

### Future: AI Sprite Generation
When Gemini Vision is integrated, the pipeline becomes:
1. Photo → Gemini Vision → Architectural analysis JSON
2. JSON → Custom sprite prompt → Image generation
3. Generated sprite → BuildingComponent in Flame

---

## Feature: Building Interface (Enhanced)

### Current State
- BuildingSelectorPanel with predefined building types
- Tap to place on grid

### Planned Enhancements
- **Voice building**: "Build a greenhouse next to the barn"
- **Photo capture**: In-game button to photograph real places
- **AI rendering**: Locations the user photographs get rendered into their style
- **Continue building**: Persistent world that grows organically

---

## Integration Points

### Files Created
1. `lib/domain/entities/calendar_mode.dart` — CalendarMode enum
2. `lib/services/calendar_mode_service.dart` — Mode + Shabbat + Hebrew tint
3. `lib/services/photo_building_service.dart` — Camera + AI analysis
4. `lib/presentation/screens/calendar_choice_screen.dart` — Onboarding choice UI
5. `lib/presentation/screens/photo_home_screen.dart` — Photo capture UI

### Files Modified
1. `lib/providers/service_providers.dart` — Added calendarModeServiceProvider
2. `lib/main.dart` — CalendarModeService initialization + provider override
3. `lib/presentation/screens/onboarding_screen.dart` — New calendar stage
4. `pubspec.yaml` — Added image_picker, assets/icons/

---

## Next Steps

### Immediate (Ready for build)
- [ ] Generate Tabernacle sprite asset (mishkan_tabernacle.png)
- [ ] Test onboarding flow end-to-end
- [ ] Wire Hebrew tint into GameScreen and world rendering

### Near-Term
- [ ] Add photo capture step to onboarding flow (Optional Stage 2.7)
- [ ] Integrate Gemini Vision for photo analysis
- [ ] Add Shabbat notification suppression to ReminderService
- [ ] Settings page to change calendar mode post-onboarding

### Future (Update Release)
- [ ] Full Hebrew date display via hebcal package
- [ ] GPS-based sunset calculation for accurate Shabbat timing
- [ ] Custom sprite generation from user photos
- [ ] Springfield Model → Hebrew aesthetic transition option
- [ ] Multiple dwelling photo capture (Church, workplace, etc.)
