# Aliice iOS App - App Store Deployment Audit

**Current Status:** ⚠️ NOT READY FOR SUBMISSION

Last Updated: 2026-04-26
Target: iOS 16.0+

---

## ✅ COMPLETED

### Project Setup
- [x] SwiftUI UI framework
- [x] Game logic implemented (GameState)
- [x] 876 Thai vocabulary words + 30 categories
- [x] TTS support (AVSpeechSynthesizer)
- [x] Haptic feedback
- [x] Confetti animations
- [x] Local data persistence (UserDefaults)
- [x] Profile system (name + 15 avatars)
- [x] Achievements/Badges system
- [x] Progressive category unlocking
- [x] 0 build errors/warnings (AppIntents warning is Xcode noise)

### Code Quality
- [x] Memory management (weak self in timers)
- [x] No hardcoded secrets/API keys
- [x] Proper error handling for audio session
- [x] Clean architecture (View/ViewModel/Model separation)

---

## ❌ CRITICAL - MUST FIX BEFORE SUBMISSION

### 1. **App Icons** (BLOCKER)
**Status:** Missing all icon sizes
**Impact:** App won't launch on real device
**To Fix:**
```bash
# Create Assets.xcassets with all required icons:
- AppIcon (1024×1024 - required)
- Icon sizes: 120, 180, 40, 80, 60, 167, 152, 76, 120, 58 (various)
```
**Effort:** 2-3 hours (design or use icon generator)

### 2. **Launch Screen** (BLOCKER)
**Status:** Storyboard referenced but not created
**Impact:** App crashes on launch
**To Fix:**
Create `LaunchScreen.storyboard` with app logo + "Aliice" branding
**Effort:** 1 hour

### 3. **Development Team** (BLOCKER)
**Status:** `DEVELOPMENT_TEAM: ""` in project.yml
**Impact:** Can't build for device or submit
**To Fix:**
```yaml
# In project.yml:
settings:
  base:
    DEVELOPMENT_TEAM: "YOUR_TEAM_ID"  # Get from Apple Developer
```
**Effort:** 5 minutes (requires Apple Developer account)

### 4. **Bundle ID** (CRITICAL)
**Status:** `com.berthod.AliiceIOS` (generic reverse domain)
**To Fix:**
Change to production domain:
```yaml
bundleIdPrefix: com.yourcompany.aliice
# or
PRODUCT_BUNDLE_IDENTIFIER: com.aliice.thai
```
**Effort:** 5 minutes

### 5. **Privacy Manifest** (CRITICAL - iOS 17+)
**Status:** Missing PrivacyInfo.xcprivacy
**Impact:** App Store will reject without manifest
**To Fix:**
Create `PrivacyInfo.xcprivacy` documenting:
- AVSpeechSynthesizer usage
- UserDefaults usage
- No tracking/analytics
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" ...>
<plist version="1.0">
<dict>
  <key>NSPrivacyTracking</key>
  <false/>
  <key>NSPrivacyTrackingDomains</key>
  <array/>
</dict>
</plist>
```
**Effort:** 1 hour

---

## ⚠️ IMPORTANT - SHOULD FIX

### 6. **App Store Metadata**
**Status:** Missing
**Required Before Submission:**
- [ ] App name: "Aliice"
- [ ] Subtitle: "Learn Thai Vocabulary"
- [ ] App description (3-4 sentences max)
  - "Interactive Thai learning for kids 3+"
  - "876 vocabulary words across 30 categories"
  - "TTS pronunciation, progressive unlocking, badges"
- [ ] Keywords: thai, learning, language, kids, education
- [ ] Support URL: https://yoursite.com/support
- [ ] Privacy Policy URL: https://yoursite.com/privacy ⚠️ REQUIRED
- [ ] Support email
- [ ] Screenshots (4-5 per language):
  - Gameplay screenshot
  - Category picker
  - Profile/achievements
  - Learning progress

**Effort:** 2-3 hours

### 7. **Terms of Service & Privacy Policy**
**Status:** Missing
**Impact:** App Store will reject without links
**To Fix:**
- Create privacy policy (use template, mention: UserDefaults storage only)
- Create terms of service
- Host on public URL
- Add URLs to App Store Connect

**Effort:** 2-3 hours

### 8. **Version & Build Number**
**Status:** 1.0 / 1
**To Fix:**
```yaml
info:
  properties:
    CFBundleShortVersionString: "1.0.0"  # Semantic versioning
    CFBundleVersion: "1"  # Build number
```
**Effort:** 5 minutes

### 9. **Localization** (NICE TO HAVE)
**Status:** English only, Thai UI labels missing
**Options:**
- Option A: Keep English-only, target international users
- Option B: Add Thai language support (2-3 hours)
  - Localize: category names, button labels, profile
  - Provide Thai App Store description

**Effort:** 2-3 hours (optional)

---

## 🔒 SECURITY CHECKLIST

- [x] No API keys in code
- [x] No hardcoded credentials
- [x] UserDefaults data (non-sensitive): ✓ OK - scores/profile only
- [x] Audio session configured securely
- [x] No network calls (offline-first) ✓
- [x] No analytics/tracking
- [x] Proper timer cleanup (weak self)
- [ ] ⚠️ Privacy Manifest needed (see #5)
- [ ] ⚠️ App Transport Security (ATS) - iOS 16+ enforces HTTPS only (app has no network, so OK)

---

## 📋 TESTING CHECKLIST

Before submission:
- [ ] Test on iPhone 13-15 (various screen sizes)
- [ ] Test on iPhone 6s (minimum iOS 16 support)
- [ ] Test iPad (if supporting)
- [ ] Test landscape mode (should lock to portrait, already done)
- [ ] Test Low Power Mode
- [ ] Test with VoiceOver (accessibility)
- [ ] Test with different text sizes (Accessibility → Larger Font)
- [ ] Test all badges unlock correctly
- [ ] Test category unlocking system
- [ ] Test data persistence (kill + reopen app)
- [ ] Test audio (TTS Thai pronunciation)
- [ ] Memory profiling (Instruments - check for leaks)

**Effort:** 4-5 hours

---

## 📦 DEPLOYMENT STEPS (WHEN READY)

1. **Setup Apple Developer Account**
   - Enroll in Apple Developer Program ($99/year)
   - Get Team ID

2. **Create App in App Store Connect**
   - Name, Category (Education), Languages
   - Select bundleID

3. **Build Archive**
   ```bash
   xcodebuild -project AliiceIOS.xcodeproj \
     -scheme AliiceIOS \
     -configuration Release \
     -archivePath build/Aliice.xcarchive \
     archive
   ```

4. **Validate & Submit**
   - Use Xcode → Product → Archive → Validate App
   - Then Submit

5. **App Store Review** (24-48 hours typically)
   - Apple reviews for compliance
   - May ask for demo/explanation

---

## 💰 COST BREAKDOWN

| Task | Effort | Cost |
|------|--------|------|
| App Store metadata + screenshots | 3h | $0 (DIY) or $100-300 (designer) |
| Icon design | 2h | $0 (DIY icon generator) or $50-200 |
| Privacy Policy + Terms | 2h | $0 (template) or $100-500 (legal) |
| Launch Screen | 1h | $0 |
| Privacy Manifest | 1h | $0 |
| Testing on devices | 5h | $0 (use simulator + friend) |
| Apple Developer membership | - | $99/year |
| **TOTAL** | **~14 hours** | **$99-1000** |

---

## 🚀 PRIORITY ORDER (CRITICAL FIRST)

### Phase 1 - BLOCKERS (Must do, ~8 hours)
1. ✋ Create App Icons (use https://www.appicon.co)
2. ✋ Create LaunchScreen.storyboard
3. ✋ Set DEVELOPMENT_TEAM in project
4. ✋ Add PrivacyInfo.xcprivacy
5. ✋ Create Privacy Policy + Terms (use template)

### Phase 2 - REQUIREMENTS (~3 hours)
6. Add App Store metadata & screenshots
7. Set correct bundle ID
8. Test on 2-3 device sizes

### Phase 3 - POLISH (Nice-to-have, ~5 hours)
9. Add Thai localization (optional)
10. Full device testing suite
11. Memory profiling & optimization

---

## 📝 CURRENT ISSUES AT A GLANCE

```
🔴 BLOCKER:    No icons, no launch screen, no team ID
🟠 CRITICAL:   No privacy manifest, no policy URLs
🟡 IMPORTANT:  No app metadata, no screenshots
🟢 OK:         Code quality, gameplay, data persistence
```

---

## NEXT ACTIONS

1. **TODAY:** Get Team ID from Apple Developer account
2. **TODAY:** Design/generate app icons using https://www.appicon.co
3. **TOMORROW:** Create LaunchScreen.storyboard + Privacy Manifest
4. **THIS WEEK:** Create Privacy Policy + write App Store description
5. **THIS WEEK:** Test on multiple devices using simulator
6. **NEXT WEEK:** Submit to App Store

---

## REFERENCE LINKS

- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Privacy Manifest Guide](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files)
- [Icon Template](https://developer.apple.com/design/resources/)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)

---

**Estimated time to production-ready:** 10-14 hours
**Estimated time to App Store approval:** 24-48 hours after submission
