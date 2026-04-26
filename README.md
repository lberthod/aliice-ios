# Aliice iOS - Learn Thai Vocabulary 🇹🇭

A fun, interactive iOS app for learning Thai vocabulary through progressive, gamified learning.

**Current Status:** v1.1.0 - Ready for App Store submission (after final blockers)

---

## 🎮 Features

### Learning System
- **1000 Thai Vocabulary Words** across 32 categories
- **Progressive Unlocking** - Master categories to unlock the next
- **Mastery System** - Words are "mastered" after 3 correct answers
- **30 Categories** including:
  - 🐘 Animals, 🍎 Fruits, 🏠 Home, 👕 Clothes
  - 🏃 Verbs (NEW), ✨ Adjectives (NEW)
  - 🎯 Numbers, 🎨 Colors, ❤️ Feelings, and 22 more...

### Gameplay
- **Interactive Quiz** - Hear Thai word, pick correct emoji
- **Hints System** - Eliminate wrong answers (3 hints per round)
- **3-Second TTS Cooldown** - Prevents button spam
- **Scoring & Streaks** - Track your progress
- **Badges** - 14 achievement badges to earn
- **Levels & XP** - Progress through 50+ levels

### Educational Features
- **Settings Page** - "How to Learn" with 3 tabs:
  - 📚 Learning Path explanation
  - 🎯 Mastery System details
  - 📖 Why 1000 words matter
- **Optimized Thai TTS** - Improved pronunciation
- **Profile System** - 15 emoji avatars, personal stats

### Technical
- **iOS 16+** native SwiftUI app
- **Offline-first** - No internet required
- **Local Persistence** - Progress saved automatically
- **Performance Optimized** - Smooth 60fps gameplay
- **Memory Efficient** - ~5MB app size

---

## 📱 Screenshots

**Start Screen**
- Play button to begin
- Profile access (stats & avatars)
- How to Learn button
- Score, streak, level display

**Gameplay**
- Thai word card (written + TTS button)
- 4 emoji choice cards
- Hint button (3 hints available)
- Instant feedback (correct/wrong)

**Category Picker**
- 32 categories with progress bars
- Locked/unlocked status
- Mastery percentage display
- Color-coded by category

**Profile**
- Current avatar & name
- Total score, best streak, level
- Mastered words & categories
- 14 badges (earned/progress)

---

## 🏗️ Project Structure

```
AliiceIOS/
├── AliiceIOSApp.swift          # App entry point
├── ContentView.swift            # Main navigation
├── GameState.swift              # Game logic (250 lines)
│
├── Views/
│   ├── StartView.swift          # Home screen
│   ├── CategoryPickerView.swift  # Category selection
│   ├── PlayView.swift           # Main game screen
│   ├── ProfileView.swift        # Stats & badges
│   └── SettingsView.swift       # Educational content
│
├── Data/
│   ├── WordsData.swift          # 1000 Thai words
│   └── CategoryData.swift       # 32 categories
│
├── Supporting/
│   └── Info.plist               # App configuration
│
└── Documentation/
    ├── APP_STORE_AUDIT.md       # Submission checklist
    ├── DEPLOYMENT_CHECKLIST.md  # Step-by-step guide
    ├── UPDATES_SUMMARY.md       # Feature summary
    └── README.md                # This file
```

---

## 🚀 Getting Started

### Requirements
- Xcode 14+ (Command Line Tools or Full IDE)
- iOS 16 simulator or device
- macOS 12.3+

### Build & Run
```bash
cd AliiceIOS

# Generate project from project.yml
xcodegen generate

# Open in Xcode
open AliiceIOS.xcodeproj

# Or build from command line
xcodebuild -project AliiceIOS.xcodeproj \
  -scheme AliiceIOS \
  -destination "generic/platform=iOS Simulator" \
  build
```

### Run on Simulator
```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
xcodebuild -project AliiceIOS.xcodeproj \
  -scheme AliiceIOS \
  -destination "platform=iOS Simulator,name=iPhone 15 Pro" \
  run
```

---

## 📊 Statistics

| Metric | Value |
|--------|-------|
| Total Words | 1000 |
| Categories | 32 |
| Verbs | 30 |
| Adjectives | 33 |
| Badges | 14 |
| Avatars | 15 |
| Lines of Swift | ~3500 |
| Deployment Target | iOS 16.0 |
| Supported Devices | iPhone SE and larger |

---

## 🧠 Learning Science

### Why 1000 Words?
- **80/20 Rule**: 1000 most common words = 80% of everyday Thai
- **Pareto Principle**: Focus on high-impact vocabulary first

### Why Mastery = 3?
- **Spaced Repetition**: Proven by Ebbinghaus curve
  - 1st encounter → short-term memory
  - 2nd encounter → recognition strengthens
  - 3rd encounter → long-term storage

### Why Progressive Unlocking?
- **Cognitive Load Theory**: 30-35 words per category is optimal
- **Zone of Proximal Development** (Vygotsky): Challenge without overwhelm
- **Intrinsic Motivation**: Unlock → dopamine hit → continue learning

### Category Order
1. **Objects first** (Animals, Food, Body)
2. **Then actions** (Verbs)
3. **Then qualities** (Adjectives)
4. **Then abstract** (Numbers, Emotions)

This follows natural language acquisition!

---

## 🔊 TTS Optimization

The app includes optimized Thai text-to-speech with:
- **Character simplification** - Removes tone marks that confuse iOS TTS
- **Consonant cluster fixes** - พร→พอ, บร→บอ, etc.
- **Word-specific corrections** - 25+ known difficult words handled
- **Phonetic improvements** - Better romanization display
- **Tuned parameters** - Rate 0.45, pitch 1.0, natural pacing

---

## 📲 App Store Submission

### Status
✅ Code complete & tested
❌ Blockers remaining:
- [ ] App icons (all sizes)
- [ ] LaunchScreen.storyboard
- [ ] Privacy manifest
- [ ] Privacy policy & terms URL
- [ ] Developer team ID

**See [APP_STORE_AUDIT.md](APP_STORE_AUDIT.md) for detailed checklist**

### Timeline
- Code: ✅ Complete (4 weeks)
- Design assets: ⏳ 1-2 weeks needed
- App Store review: ⏳ 1-2 days after submission
- Go live: 📅 ~3 weeks total

---

## 🛠️ Development

### Technologies
- **Language**: Swift 5.0+
- **UI Framework**: SwiftUI
- **Audio**: AVFoundation (TTS)
- **Persistence**: UserDefaults
- **Project Gen**: XcodeGen

### Code Quality
- 0 compiler errors
- 0 compiler warnings (AppIntents is Xcode noise)
- Proper memory management (weak self in closures)
- Efficient data structures
- Clean MVVM architecture

### Testing
Tested on:
- iPhone 15 Pro simulator (iOS 16-18)
- iPad simulator
- Various text sizes (accessibility)

---

## 📝 License

Private project - Not open source

---

## 👤 Creator

**Loic Berthod**
- Web: lberthod.com
- GitHub: @lberthod

---

## 🤝 Contributing

This is a personal project. For suggestions or feedback, please reach out directly.

---

## 📞 Support

For iOS app support:
- Check [APP_STORE_AUDIT.md](APP_STORE_AUDIT.md) for submission info
- See [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) for step-by-step guide
- Review [UPDATES_SUMMARY.md](UPDATES_SUMMARY.md) for features

For web version (Vue.js): See [lberthod/aliice](https://github.com/lberthod/aliice)

---

**Last Updated:** April 26, 2026
**Repo**: [github.com/lberthod/aliice-ios](https://github.com/lberthod/aliice-ios)
