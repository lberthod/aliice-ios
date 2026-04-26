import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var game: GameState
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Back button
                HStack {
                    Button {
                        game.screen = .start
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(.white.opacity(0.2))
                        .cornerRadius(20)
                    }
                    Spacer()
                    Text("How to Learn")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                    Color.clear.frame(width: 60)
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 8)

                // Tab selector
                HStack(spacing: 0) {
                    ForEach(["Learning", "Mastery", "Why"], id: \.self) { tab in
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedTab = ["Learning", "Mastery", "Why"].firstIndex(of: tab) ?? 0
                            }
                        } label: {
                            Text(tab)
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(selectedTab == ["Learning", "Mastery", "Why"].firstIndex(of: tab) ?? 0 ? .white : .white.opacity(0.6))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(selectedTab == ["Learning", "Mastery", "Why"].firstIndex(of: tab) ?? 0 ? .white.opacity(0.25) : .clear)
                        }
                    }
                }
                .background(.white.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)

                // Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if selectedTab == 0 {
                            LearningPathView()
                        } else if selectedTab == 1 {
                            MasterySystemView()
                        } else {
                            WhyVocabularyView()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
            }
        }
    }
}

// MARK: - Learning Path
struct LearningPathView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TitleCard(emoji: "🚀", title: "Progressive Learning Path")

            VStack(alignment: .leading, spacing: 12) {
                Text("How Categories Unlock")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                ForEach([
                    ("1️⃣", "Start", "You begin with 3 categories unlocked: Animals, Colors, Numbers"),
                    ("2️⃣", "Master", "When you master a category (60% of words mastered), you unlock the next one"),
                    ("3️⃣", "Progress", "Master categories in order → unlock 30 total categories"),
                    ("4️⃣", "Freedom", "Once 2+ categories are unlocked, you can practice 'All' to mix categories")
                ], id: \.1) { emoji, title, desc in
                    HStack(alignment: .top, spacing: 12) {
                        VStack {
                            Text(emoji).font(.system(size: 18))
                        }
                        .frame(width: 32, height: 32)
                        .background(.white.opacity(0.15))
                        .cornerRadius(8)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(title)
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text(desc)
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.7))
                                .lineLimit(3)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(.white.opacity(0.1))
                    .cornerRadius(10)
                }

                Text("Why This Approach?")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.top, 8)

                Text("Progressive unlocking keeps the game focused. Instead of 1000 random words, you learn in small groups, master them, then move on. This prevents overwhelm and builds confidence.")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(5)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.white.opacity(0.1))
            .cornerRadius(14)
        }
    }
}

// MARK: - Mastery System
struct MasterySystemView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TitleCard(emoji: "🎯", title: "Word Mastery System")

            VStack(alignment: .leading, spacing: 14) {
                Text("3-Strike Mastery")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                ForEach([
                    ("1st Time", "See the word, guess correctly", "You get 1 point"),
                    ("2nd Time", "See it again in future rounds", "2 points total"),
                    ("3rd Time", "Master it completely", "Word is MASTERED ✓")
                ], id: \.0) { attempt, desc1, desc2 in
                    HStack(alignment: .top, spacing: 12) {
                        VStack {
                            Text("✓").font(.system(size: 16, weight: .bold))
                        }
                        .frame(width: 28, height: 28)
                        .background(.white.opacity(0.2))
                        .cornerRadius(6)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(attempt)
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text(desc1)
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.7))
                            Text(desc2)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(Color(hex: "a5d6a7"))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.white.opacity(0.08))
                    .cornerRadius(8)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Mastery Threshold: 60%")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.top, 4)
                    Text("To unlock the next category, you need to master 60% of the current category's words (3 correct answers each).")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(hex: "4caf50").opacity(0.2))
                .cornerRadius(8)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.white.opacity(0.1))
            .cornerRadius(14)

            VStack(alignment: .leading, spacing: 10) {
                Text("Pro Tips 💡")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                VStack(alignment: .leading, spacing: 6) {
                    Text("• Use Hints: Can't remember? Tap the 💡 button to eliminate wrong answers")
                    Text("• Repeat: Same word may appear multiple times. This is intentional!")
                    Text("• Practice Regularly: Your progress saves automatically")
                    Text("• Don't Skip: Each word is foundational for the next category")
                }
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.white.opacity(0.1))
            .cornerRadius(14)
        }
    }
}

// MARK: - Why Vocabulary
struct WhyVocabularyView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TitleCard(emoji: "📚", title: "Why 1000 Words Matter")

            VStack(alignment: .leading, spacing: 12) {
                Text("The 80/20 Rule")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.bottom, 2)

                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("1000 Words")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(hex: "ffd700"))
                        Text("= 80% of everyday Thai")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Spacer()
                    Text("📊").font(.system(size: 40))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(hex: "ffa500").opacity(0.15))
                .cornerRadius(10)

                Text("Foundation First")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 8)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach([
                        ("🐘 Objects", "Animals, food, objects: nouns you see daily"),
                        ("🏃 Actions", "Verbs: walk, eat, sleep, play"),
                        ("✨ Qualities", "Adjectives: big, small, happy, fast"),
                        ("🔢 Numbers", "Counting: essential for prices, time, age"),
                        ("❤️ Emotions", "Feelings and social words: love, sorry, hello")
                    ], id: \.0) { category, desc in
                        HStack(spacing: 10) {
                            Text(category.prefix(1))
                                .font(.system(size: 14))
                            Text(String(category.dropFirst()))
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                            Text(desc)
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.6))
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(.white.opacity(0.1))
                .cornerRadius(10)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Learning Benefits")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    VStack(alignment: .leading, spacing: 6) {
                        Text("✓ Builds confidence with core vocabulary")
                        Text("✓ Creates neural pathways through repetition")
                        Text("✓ Enables simple conversations")
                        Text("✓ Provides foundation for grammar study")
                        Text("✓ Boosts retention through spaced repetition")
                    }
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.8))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(hex: "4caf50").opacity(0.15))
                .cornerRadius(10)
            }
        }
    }
}

// MARK: - Helper
struct TitleCard: View {
    let emoji: String
    let title: String

    var body: some View {
        HStack(spacing: 12) {
            Text(emoji).font(.system(size: 28))
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(.white.opacity(0.15))
        .cornerRadius(14)
    }
}
