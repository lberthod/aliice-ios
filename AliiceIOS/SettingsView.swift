import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var game: GameState
    @State private var selectedTab = 0

    private let tabs = [
        (0, "🗺️", "Learning"),
        (1, "🎯", "Mastery"),
        (2, "📚", "Why")
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {

                // ── Header ──────────────────────────────────────────
                HStack(alignment: .center) {
                    Button {
                        game.screen = .start
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(.white.opacity(0.2))
                            .clipShape(Circle())
                    }

                    Spacer()

                    VStack(spacing: 2) {
                        Text("How to Learn")
                            .font(.system(size: 20, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        Text("Thai vocabulary guide")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.65))
                    }

                    Spacer()
                    Color.clear.frame(width: 36, height: 36)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 20)

                // ── Tab Selector ────────────────────────────────────
                HStack(spacing: 8) {
                    ForEach(tabs, id: \.0) { idx, emoji, label in
                        Button {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                selectedTab = idx
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Text(emoji)
                                    .font(.system(size: 14))
                                Text(label)
                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                            }
                            .foregroundColor(selectedTab == idx ? Color(hex: "764ba2") : .white.opacity(0.7))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedTab == idx ? Color.white : Color.white.opacity(0.12))
                            )
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)

                // ── Content ─────────────────────────────────────────
                ScrollView(showsIndicators: false) {
                    Group {
                        switch selectedTab {
                        case 0: LearningPathView()
                        case 1: MasterySystemView()
                        default: WhyVocabularyView()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                }
            }
        }
    }
}

// MARK: - Learning Path
struct LearningPathView: View {
    private let steps: [(String, String, String, String)] = [
        ("🌱", "Start",    "animals.colors.numbers",  "Begin with 3 categories: Animals, Colors & Numbers"),
        ("⭐", "Master",   "60% threshold",            "Get 60% of a category's words correct 3× each"),
        ("🔓", "Unlock",   "one by one",               "Master one → unlock the next in the learning path"),
        ("🌍", "All Mode", "2+ categories",            "Mix all unlocked categories for extra challenge"),
    ]

    var body: some View {
        VStack(spacing: 14) {
            SectionHeader(emoji: "🚀", title: "Progressive Learning Path")

            // Steps
            VStack(spacing: 10) {
                ForEach(steps, id: \.1) { icon, title, tag, desc in
                    HStack(alignment: .top, spacing: 14) {
                        Text(icon)
                            .font(.system(size: 22))
                            .frame(width: 42, height: 42)
                            .background(.white.opacity(0.15))
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 3) {
                            HStack(spacing: 6) {
                                Text(title)
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                Text(tag)
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(Color(hex: "ffd700"))
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color(hex: "ffd700").opacity(0.15))
                                    .clipShape(Capsule())
                            }
                            Text(desc)
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.7))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(.white.opacity(0.1))
                    .cornerRadius(14)
                }
            }

            // Why box
            InfoBox(
                color: "667eea",
                icon: "💡",
                title: "Why this approach?",
                text: "Small groups, mastery, then more. No overwhelm — just confidence built step by step."
            )
        }
    }
}

// MARK: - Mastery System
struct MasterySystemView: View {
    var body: some View {
        VStack(spacing: 14) {
            SectionHeader(emoji: "🎯", title: "Word Mastery System")

            // 3-step visual
            HStack(spacing: 0) {
                ForEach([(1, "Seen", "⬜"), (2, "Familiar", "🟨"), (3, "Mastered", "✅")], id: \.0) { n, label, icon in
                    VStack(spacing: 6) {
                        ZStack {
                            Circle()
                                .fill(n == 3 ? Color(hex: "4caf50") : (n == 2 ? Color(hex: "ffa500") : Color.white.opacity(0.2)))
                                .frame(width: 44, height: 44)
                            Text("\(n)")
                                .font(.system(size: 18, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                        }
                        Text(label)
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.85))
                        Text("correct")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity)

                    if n < 3 {
                        Rectangle()
                            .fill(.white.opacity(0.3))
                            .frame(height: 2)
                            .frame(width: 24)
                            .offset(y: -14)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(.white.opacity(0.1))
            .cornerRadius(16)

            // Wrong answer penalty
            HStack(spacing: 12) {
                Text("❌")
                    .font(.system(size: 26))
                    .frame(width: 44, height: 44)
                    .background(Color(hex: "f44336").opacity(0.25))
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 2) {
                    Text("Wrong answer")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Mastery count drops by 1 — the word comes back more often.")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.7))
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color(hex: "f44336").opacity(0.12))
            .cornerRadius(14)

            // Unlock threshold
            InfoBox(
                color: "4caf50",
                icon: "🔓",
                title: "Unlock Threshold: 60%",
                text: "Master 60% of a category's words (3 correct each) to unlock the next category."
            )

            // Tips
            VStack(alignment: .leading, spacing: 10) {
                Text("Pro Tips")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                ForEach([
                    ("💡", "Use hints to eliminate 1-2 wrong answers"),
                    ("🔁", "Seeing the same word again is intentional"),
                    ("🔊", "Tap the speaker to hear the Thai pronunciation"),
                    ("💾", "Progress saves automatically — no need to rush"),
                ], id: \.0) { icon, tip in
                    HStack(spacing: 10) {
                        Text(icon).font(.system(size: 16))
                        Text(tip)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(.white.opacity(0.1))
            .cornerRadius(14)
        }
    }
}

// MARK: - Why Vocabulary
struct WhyVocabularyView: View {
    var body: some View {
        VStack(spacing: 14) {
            SectionHeader(emoji: "📚", title: "Why 1000 Words?")

            // Big stat
            HStack(spacing: 0) {
                VStack(spacing: 4) {
                    Text("1 000")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(Color(hex: "ffd700"))
                    Text("words")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity)

                Rectangle().fill(.white.opacity(0.2)).frame(width: 1, height: 60)

                VStack(spacing: 4) {
                    Text("80%")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(Color(hex: "a5d6a7"))
                    Text("of everyday Thai")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 20)
            .background(.white.opacity(0.1))
            .cornerRadius(16)

            // Categories breakdown
            VStack(alignment: .leading, spacing: 8) {
                Text("What you'll learn")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.bottom, 2)

                ForEach([
                    ("🐘", "Nouns",       "Animals, food, objects — the building blocks"),
                    ("🏃", "Verbs",       "Walk, eat, sleep, play — actions in real life"),
                    ("✨", "Adjectives",  "Big, small, happy, fast — describe your world"),
                    ("🔢", "Numbers",     "Prices, time, age — used every single day"),
                    ("❤️", "Emotions",   "Love, sorry, hello — connect with people"),
                ], id: \.0) { emoji, cat, desc in
                    HStack(spacing: 12) {
                        Text(emoji)
                            .font(.system(size: 18))
                            .frame(width: 34, height: 34)
                            .background(.white.opacity(0.12))
                            .clipShape(Circle())
                        VStack(alignment: .leading, spacing: 1) {
                            Text(cat)
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text(desc)
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(.white.opacity(0.1))
            .cornerRadius(14)

            // Language Settings
            LanguageSelector()
                .padding(.horizontal, 14)
                .padding(.vertical, 14)

            // Benefits
            InfoBox(
                color: "4caf50",
                icon: "✅",
                title: "Learning Benefits",
                text: "Builds confidence · Enables simple conversations · Creates memory through repetition · Prepares you for grammar study"
            )
        }
    }
}

// MARK: - Shared Components

struct SectionHeader: View {
    let emoji: String
    let title: String

    var body: some View {
        HStack(spacing: 12) {
            Text(emoji)
                .font(.system(size: 30))
                .frame(width: 50, height: 50)
                .background(.white.opacity(0.15))
                .clipShape(Circle())
            Text(title)
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundColor(.white)
            Spacer()
        }
    }
}

struct InfoBox: View {
    let color: String
    let icon: String
    let title: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(icon)
                .font(.system(size: 22))
                .frame(width: 40, height: 40)
                .background(Color(hex: color).opacity(0.25))
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text(text)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.75))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(Color(hex: color).opacity(0.15))
        .cornerRadius(14)
    }
}

// MARK: - Language Selector
struct LanguageSelector: View {
    @EnvironmentObject var localizationManager: LocalizationManager

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Language")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
                .padding(.leading, 4)

            HStack(spacing: 12) {
                Button {
                    localizationManager.setLanguage("en")
                } label: {
                    HStack(spacing: 8) {
                        Text("🇬🇧")
                            .font(.system(size: 18))
                        Text("English")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(localizationManager.currentLanguage.hasPrefix("en") ? .white.opacity(0.3) : .white.opacity(0.1))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

                Button {
                    localizationManager.setLanguage("fr")
                } label: {
                    HStack(spacing: 8) {
                        Text("🇫🇷")
                            .font(.system(size: 18))
                        Text("Français")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(localizationManager.currentLanguage.hasPrefix("fr") ? .white.opacity(0.3) : .white.opacity(0.1))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(.white.opacity(0.1))
        .cornerRadius(14)
    }
}
