import SwiftUI
import AVFoundation

class GameState: ObservableObject {
    // MARK: - Persistence
    private let storageKey = "aliice_v1"

    // MARK: - Profile
    @Published var profileName: String = ""
    @Published var profileAvatar: String = "🐼"

    // MARK: - Progress
    @Published var score: Int = 0
    @Published var bestStreak: Int = 0
    @Published var mastery: [String: Int] = [:]  // wordId -> count of correct answers
    @Published var unlockedBadges: [String] = []

    // MARK: - Session
    @Published var currentCategory: String = "animals"
    @Published var screen: AppScreen = .start

    // MARK: - Game Question
    @Published var choices: [WordChoice] = []
    @Published var correctId: String = ""
    @Published var selectedId: String? = nil
    @Published var feedback: FeedbackState? = nil
    @Published var streak: Int = 0
    @Published var hintsLeft: Int = 3
    @Published var hiddenIds: Set<String> = []

    // MARK: - UI State
    @Published var showConfetti: Bool = false
    @Published var showLevelUp: Bool = false
    @Published var badgeUnlocked: BadgeInfo? = nil
    @Published var catUnlockedPopup: String? = nil

    // MARK: - TTS
    private let synthesizer = AVSpeechSynthesizer()
    @Published var canSpeak: Bool = true
    private var speakTimer: Timer? = nil

    // MARK: - Computed
    var level: Int {
        if score < 5 { return 1 }
        return Int(log2(Double(score) / 5.0 + 1)) + 1
    }

    var xpForCurrentLevel: Int { Int(5 * pow(2.0, Double(level - 1))) }
    var xpToCurrentLevel: Int { Int(5 * (pow(2.0, Double(level - 1)) - 1)) }
    var xpInLevel: Int { score - xpToCurrentLevel }
    var xpPercent: Double { Double(xpInLevel) / Double(xpForCurrentLevel) }

    var numChoices: Int {
        if level <= 1 { return 2 }
        if level <= 2 { return 3 }
        return 4
    }

    var wordPool: [Word] {
        if currentCategory == "all" {
            let allowed = Set(LEARNING_PATH.prefix(unlockedCount))
            return ALL_WORDS.filter { allowed.contains($0.category) }
        }
        return ALL_WORDS.filter { $0.category == currentCategory }
    }

    var unlockedCount: Int {
        var count = INITIAL_UNLOCKED
        for i in 0..<LEARNING_PATH.count - 1 {
            if i < count && isCatMastered(LEARNING_PATH[i]) {
                if count < LEARNING_PATH.count { count += 1 }
            }
        }
        return min(count, LEARNING_PATH.count)
    }

    var masteredCatsCount: Int {
        LEARNING_PATH.filter { isCatMastered($0) }.count
    }

    var masteredWordsCount: Int {
        mastery.values.filter { $0 >= 3 }.count
    }

    func isCatUnlocked(_ cat: String) -> Bool {
        if cat == "all" { return unlockedCount >= 2 }
        let idx = LEARNING_PATH.firstIndex(of: cat) ?? -1
        if idx < 0 { return true }
        return idx < unlockedCount
    }

    func isCatMastered(_ cat: String) -> Bool {
        catMasteryRatio(cat) >= MASTERY_THRESHOLD
    }

    func catCount(_ cat: String) -> Int {
        ALL_WORDS.filter { $0.category == cat }.count
    }

    func catMasteredWords(_ cat: String) -> Int {
        ALL_WORDS.filter { $0.category == cat && (mastery[$0.id] ?? 0) >= 3 }.count
    }

    func catMasteryRatio(_ cat: String) -> Double {
        let total = catCount(cat)
        if total == 0 { return 0 }
        return Double(catMasteredWords(cat)) / Double(total)
    }

    // MARK: - Init
    init() {
        load()
    }

    // MARK: - Persistence
    func save() {
        let data: [String: Any] = [
            "profileName": profileName,
            "profileAvatar": profileAvatar,
            "score": score,
            "bestStreak": bestStreak,
            "mastery": mastery,
            "unlockedBadges": unlockedBadges,
            "currentCategory": currentCategory
        ]
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    func load() {
        guard let data = UserDefaults.standard.dictionary(forKey: storageKey) else { return }
        profileName = data["profileName"] as? String ?? ""
        profileAvatar = data["profileAvatar"] as? String ?? "🐼"
        score = data["score"] as? Int ?? 0
        bestStreak = data["bestStreak"] as? Int ?? 0
        mastery = data["mastery"] as? [String: Int] ?? [:]
        unlockedBadges = data["unlockedBadges"] as? [String] ?? []
        currentCategory = data["currentCategory"] as? String ?? "animals"
    }

    // MARK: - Game Logic
    private var lastTargetId: String? = nil

    func generateQuestion() {
        feedback = nil
        selectedId = nil
        hintsLeft = 3
        hiddenIds = []

        let pool = wordPool
        guard !pool.isEmpty else { return }

        var target: Word
        repeat {
            target = pool.randomElement()!
        } while target.id == lastTargetId && pool.count > 1
        lastTargetId = target.id

        let n = min(numChoices, pool.count)
        let distractors = pickDistractors(target: target, pool: pool, count: n - 1)
        var allChoices = [target] + distractors
        allChoices.shuffle()

        let cardColors: [(String, String)] = [
            ("#fff2a8", "#ffd66b"), ("#ffd0e4", "#ff98c4"),
            ("#cfe7ff", "#8ec7ff"), ("#d7f7c9", "#9be57d"),
            ("#e6d7ff", "#b79bff"), ("#ffd6b8", "#ff9d6b")
        ]
        let shuffledColors = cardColors.shuffled()

        choices = allChoices.enumerated().map { idx, word in
            let color = shuffledColors[idx % shuffledColors.count]
            return WordChoice(word: word, colorTop: color.0, colorBottom: color.1)
        }
        correctId = target.id

        // Speak Thai
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.speakThai(target.thai)
        }
    }

    private func pickDistractors(target: Word, pool: [Word], count: Int) -> [Word] {
        let sameCat = pool.filter { $0.id != target.id && $0.category == target.category }
        let otherCat = pool.filter { $0.id != target.id && $0.category != target.category }

        var distractors: [Word] = []
        if level <= 2 {
            let needSame = max(0, Int(ceil(Double(count) * 0.2)))
            let needOther = count - needSame
            distractors = Array(sameCat.shuffled().prefix(needSame)) + Array(otherCat.shuffled().prefix(needOther))
        } else {
            let needSame = Int(ceil(Double(count) / 2.0))
            let needOther = count - needSame
            distractors = Array(sameCat.shuffled().prefix(needSame)) + Array(otherCat.shuffled().prefix(needOther))
        }

        if distractors.count < count {
            let existing = Set(distractors.map { $0.id })
            let fallback = ALL_WORDS.filter { $0.id != target.id && !existing.contains($0.id) }.shuffled()
            distractors = Array((distractors + fallback).prefix(count))
        }
        return distractors
    }

    func selectAnswer(_ wordId: String) {
        guard selectedId == nil, feedback == nil else { return }
        selectedId = wordId
        let isCorrect = wordId == correctId

        if isCorrect {
            feedback = .correct
            streak += 1
            if streak > bestStreak { bestStreak = streak }
            score += 1
            let prevUnlocked = unlockedCount
            mastery[correctId, default: 0] += 1

            checkCategoryUnlock(prevUnlocked: prevUnlocked)
            checkBadges()
            showConfetti = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { self.showConfetti = false }
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        } else {
            feedback = .wrong
            streak = 0
            mastery[wordId, default: 0] = max(0, (mastery[wordId] ?? 0) - 1)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }

        save()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            self.generateQuestion()
        }
    }

    func useHint() {
        guard hintsLeft > 0 else { return }
        let wrongChoices = choices.filter { $0.word.id != correctId && !hiddenIds.contains($0.word.id) }
        if let toHide = wrongChoices.randomElement() {
            hiddenIds.insert(toHide.word.id)
            hintsLeft -= 1
        }
    }

    private func checkCategoryUnlock(prevUnlocked: Int) {
        let newCount = unlockedCount
        if newCount > prevUnlocked {
            let newCat = LEARNING_PATH[newCount - 1]
            catUnlockedPopup = newCat
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.catUnlockedPopup = nil
            }
        }
    }

    private func checkBadges() {
        let snap = BadgeSnapshot(
            score: score, bestStreak: bestStreak, level: level,
            masteredCats: masteredCatsCount, masteredWords: masteredWordsCount
        )
        for badge in ALL_BADGES {
            if !unlockedBadges.contains(badge.id) {
                let prog = badge.progress(snap)
                if prog.have >= prog.need {
                    unlockedBadges.append(badge.id)
                    badgeUnlocked = badge
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.badgeUnlocked = nil
                    }
                }
            }
        }
    }

    // MARK: - TTS
    func speakThai(_ text: String) {
        guard canSpeak else { return }

        synthesizer.stopSpeaking(at: .immediate)

        // Use phonetically improved Thai text
        let improvedText = improveThaiBnPronunciation(text)

        let utterance = AVSpeechUtterance(string: improvedText)
        utterance.voice = AVSpeechSynthesisVoice(language: "th-TH")

        // Optimized TTS parameters for Thai
        utterance.rate = 0.45         // Slightly faster for clarity
        utterance.pitchMultiplier = 1.0  // Natural pitch
        utterance.volume = 1.0
        utterance.preUtteranceDelay = 0.1
        utterance.postUtteranceDelay = 0.1

        synthesizer.speak(utterance)

        // Disable speak button for 3 seconds
        canSpeak = false
        speakTimer?.invalidate()
        speakTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            self?.canSpeak = true
        }
    }

    // Improve pronunciation of difficult Thai words
    private func improveThaiBnPronunciation(_ text: String) -> String {
        // Word-specific corrections for known difficult pronunciations
        let wordReplacements: [String: String] = [
            // Complex words with difficult pronunciations
            "บร็อคโคลี": "บร็อกโคลี",
            "บร็อคโคลีสด": "บร็อกโคลี สด",
            "ช็อกโกแลต": "ชอกโกแลต",
            "ช็อกโกแลตแท่ง": "ชอกโกแลต แท่ง",
            "โทรศัพท์": "โทรศัพ",
            "โทรทัศน์": "โทรทัศ",
            "เปียโน": "เปียโน",
            "ภูเขา": "ภู เขา",
            "ฝักข้าวโพด": "ฝัก ข้าว โพด",
            "เบนโตะ": "เบนโต",
            "โลมา": "โล มา",
            "โคอาลา": "โค อาลา",
            "อะโวคาโด": "อะ โวคาโด",
            "โดนัท": "โด นัท",
            "ลูกโป่ง": "ลูก โป่ง",
            "โยโย่": "โยโย",
            "สิงโต": "สิง โต",
            "แตงโม": "แตง โม",
            "ข้าวโพด": "ข้าว โพด",
            "โลก": "โลก",

            // Medical/complex terms
            "หัวฉัน": "หัว ฉัน",
            "ปาก": "ปาก",

            // Consonant simplification for TTS clarity
            "พร": "พอ",
            "บร": "บอ",
            "คร": "คอ",
            "ทร": "ทอ",
            "กร": "กอ",
        ]

        var improved = text

        // Apply word-specific replacements first
        for (old, new) in wordReplacements {
            improved = improved.replacingOccurrences(of: old, with: new)
        }

        // General tone mark and special character fixes
        let generalReplacements: [String: String] = [
            // Remove problematic tone marks
            "็": "",         // Remove Mai Tho (tone mark)
            "์": "",         // Remove Thanthakhat (dead consonant)
            "ํ": "",         // Remove Mai Kham (nasal mark)
            "๎": "",         // Remove other combining marks
            "๏": "",

            // Simplify complex vowel combinations
            "เะ": "เ",
            "โะ": "โ",
            "ึะ": "ึ",

            // Fix rare consonants
            "ฎ": "ด",
            "ฏ": "ต",
            "ฐ": "ท",
            "ญ": "ย",
        ]

        for (old, new) in generalReplacements {
            improved = improved.replacingOccurrences(of: old, with: new)
        }

        return improved
    }

    // MARK: - Navigation
    func startGame(category: String) {
        currentCategory = category
        screen = .play
        generateQuestion()
    }

    func goHome() {
        synthesizer.stopSpeaking(at: .immediate)
        speakTimer?.invalidate()
        speakTimer = nil
        canSpeak = true
        screen = .start
        feedback = nil
        selectedId = nil
        streak = 0
        save()
    }
}

// MARK: - Supporting Types
enum AppScreen {
    case start, categoryPicker, play, profile, settings
}

enum FeedbackState {
    case correct, wrong
}

struct WordChoice: Identifiable {
    let word: Word
    let colorTop: String
    let colorBottom: String
    var id: String { word.id }
}

struct BadgeSnapshot {
    let score: Int
    let bestStreak: Int
    let level: Int
    let masteredCats: Int
    let masteredWords: Int
}

struct BadgeInfo: Identifiable {
    let id: String
    let emoji: String
    let thai: String
    let english: String
    let progress: (BadgeSnapshot) -> (have: Int, need: Int)
}

let ALL_BADGES: [BadgeInfo] = [
    BadgeInfo(id: "first",        emoji: "🌱", thai: "คำแรก",          english: "First word",        progress: { s in (min(s.score, 1), 1) }),
    BadgeInfo(id: "words_10",     emoji: "⭐", thai: "10 คำ",           english: "10 words",           progress: { s in (min(s.score, 10), 10) }),
    BadgeInfo(id: "words_50",     emoji: "🌟", thai: "50 คำ",           english: "50 words",           progress: { s in (min(s.score, 50), 50) }),
    BadgeInfo(id: "words_100",    emoji: "💫", thai: "100 คำ",          english: "100 words",          progress: { s in (min(s.score, 100), 100) }),
    BadgeInfo(id: "words_250",    emoji: "📚", thai: "250 คำ",          english: "250 words",          progress: { s in (min(s.score, 250), 250) }),
    BadgeInfo(id: "words_500",    emoji: "📖", thai: "500 คำ",          english: "500 words",          progress: { s in (min(s.score, 500), 500) }),
    BadgeInfo(id: "streak_5",     emoji: "🔥", thai: "ต่อเนื่อง 5",     english: "Streak 5",           progress: { s in (min(s.bestStreak, 5), 5) }),
    BadgeInfo(id: "streak_10",    emoji: "💎", thai: "ต่อเนื่อง 10",    english: "Streak 10",          progress: { s in (min(s.bestStreak, 10), 10) }),
    BadgeInfo(id: "streak_25",    emoji: "🚀", thai: "ต่อเนื่อง 25",    english: "Streak 25",          progress: { s in (min(s.bestStreak, 25), 25) }),
    BadgeInfo(id: "streak_50",    emoji: "🦸", thai: "ต่อเนื่อง 50",    english: "Streak 50",          progress: { s in (min(s.bestStreak, 50), 50) }),
    BadgeInfo(id: "master_1",     emoji: "🎯", thai: "เซียน 1",         english: "Master 1 category",  progress: { s in (min(s.masteredCats, 1), 1) }),
    BadgeInfo(id: "master_3",     emoji: "🧩", thai: "เซียน 3",         english: "Master 3 categories",progress: { s in (min(s.masteredCats, 3), 3) }),
    BadgeInfo(id: "master_6",     emoji: "🌈", thai: "เซียน 6",         english: "Master 6 categories",progress: { s in (min(s.masteredCats, 6), 6) }),
    BadgeInfo(id: "master_all",   emoji: "👑", thai: "ราชาแห่งคำศัพท์",english: "Vocabulary King",    progress: { s in (min(s.masteredCats, LEARNING_PATH.count), LEARNING_PATH.count) }),
]
