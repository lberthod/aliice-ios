import SwiftUI

struct PlayView: View {
    @EnvironmentObject var game: GameState
    @State private var confettiPieces: [ConfettiPiece] = []

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "1a1a2e"), Color(hex: "16213e"), Color(hex: "0f3460")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar
                PlayTopBar()

                // XP bar
                XPBar()
                    .padding(.horizontal, 20)
                    .padding(.top, 4)

                Spacer()

                // Thai word card
                if let target = game.choices.first(where: { $0.word.id == game.correctId }) {
                    ThaiWordCard(word: target.word)
                        .id(game.correctId)
                        .transition(.scale.combined(with: .opacity))
                }

                Spacer()

                // Emoji choices grid
                EmojiChoicesGrid()
                    .padding(.horizontal, 16)

                // Hint button
                if game.hintsLeft > 0 {
                    Button {
                        game.useHint()
                    } label: {
                        HStack(spacing: 6) {
                            Text("💡")
                            Text("Hint (\(game.hintsLeft) left)")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.white.opacity(0.1))
                        .cornerRadius(20)
                    }
                    .padding(.top, 12)
                }

                Spacer().frame(height: 20)
            }

            // Confetti overlay
            if game.showConfetti {
                ConfettiView()
                    .allowsHitTesting(false)
            }

            // Badge unlocked toast
            if let badge = game.badgeUnlocked {
                BadgeToast(badge: badge)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            // Category unlocked popup
            if let cat = game.catUnlockedPopup, let meta = CATEGORY_META[cat] {
                CategoryUnlockedPopup(meta: meta)
                    .transition(.scale.combined(with: .opacity))
            }

            // Feedback overlay
            if let fb = game.feedback {
                FeedbackOverlay(state: fb)
                    .allowsHitTesting(false)
            }
        }
        .animation(.spring(response: 0.4), value: game.correctId)
        .animation(.easeInOut(duration: 0.3), value: game.badgeUnlocked?.id)
        .animation(.easeInOut(duration: 0.3), value: game.catUnlockedPopup)
    }
}

// MARK: - Top bar
struct PlayTopBar: View {
    @EnvironmentObject var game: GameState

    var catMeta: CategoryMeta? {
        CATEGORY_META[game.currentCategory]
    }

    var body: some View {
        HStack {
            Button {
                game.goHome()
            } label: {
                Image(systemName: "house.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(10)
                    .background(.white.opacity(0.15))
                    .clipShape(Circle())
            }

            Spacer()

            VStack(spacing: 2) {
                Text(catMeta?.emoji ?? "🌍")
                    .font(.system(size: 18))
                Text(catMeta?.english ?? "All")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
            }

            Spacer()

            HStack(spacing: 14) {
                // Streak
                HStack(spacing: 4) {
                    Text("🔥")
                        .font(.system(size: 16))
                    Text("\(game.streak)")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }

                // Score
                HStack(spacing: 4) {
                    Text("⭐")
                        .font(.system(size: 16))
                    Text("\(game.score)")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.white.opacity(0.15))
            .cornerRadius(20)
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }
}

// MARK: - XP Bar
struct XPBar: View {
    @EnvironmentObject var game: GameState

    var body: some View {
        HStack(spacing: 8) {
            Text("Lv \(game.level)")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 36)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.white.opacity(0.15))
                        .frame(height: 6)
                    Capsule()
                        .fill(LinearGradient(colors: [Color(hex: "ffd700"), Color(hex: "ffa500")], startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * min(game.xpPercent, 1.0), height: 6)
                        .animation(.spring(response: 0.5), value: game.xpPercent)
                }
            }
            .frame(height: 6)

            Text("\(game.xpInLevel)/\(game.xpForCurrentLevel)")
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.5))
                .frame(width: 44, alignment: .trailing)
        }
        .frame(height: 14)
    }
}

// MARK: - Thai word card
struct ThaiWordCard: View {
    let word: Word
    @EnvironmentObject var game: GameState
    @State private var cooldownRemaining: Int = 0
    @State private var cooldownTimer: Timer? = nil

    var body: some View {
        VStack(spacing: 16) {
            // Thai text
            VStack(spacing: 6) {
                Text(word.thai)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)

                Text(improveRomanization(word.romanization))
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.horizontal, 20)

            // Speaker button
            Button {
                game.speakThai(word.thai)
                startCooldown()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 16))
                    Text(game.canSpeak ? "Tap to hear" : "\(cooldownRemaining)s")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(game.canSpeak ? Color.white.opacity(0.2) : Color.white.opacity(0.1))
                .cornerRadius(20)
            }
            .disabled(!game.canSpeak)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            LinearGradient(colors: [Color(hex: "667eea").opacity(0.3), Color(hex: "764ba2").opacity(0.3)],
                          startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(24)
        .padding(.horizontal, 16)
        .onChange(of: game.canSpeak) { newValue in
            if newValue {
                cooldownTimer?.invalidate()
                cooldownRemaining = 0
            } else {
                startCooldown()
            }
        }
    }

    private func startCooldown() {
        cooldownRemaining = 3
        cooldownTimer?.invalidate()
        cooldownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            cooldownRemaining -= 1
            if cooldownRemaining <= 0 {
                cooldownTimer?.invalidate()
                cooldownTimer = nil
            }
        }
    }
}

// MARK: - Emoji Choices Grid
struct EmojiChoicesGrid: View {
    @EnvironmentObject var game: GameState

    var body: some View {
        let cols = 2

        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 14), count: cols),
            spacing: 14
        ) {
            ForEach(game.choices) { choice in
                if !game.hiddenIds.contains(choice.word.id) {
                    EmojiChoiceCard(choice: choice)
                } else {
                    Color.clear
                        .frame(height: 100)
                }
            }
        }
    }
}

struct EmojiChoiceCard: View {
    let choice: WordChoice
    @EnvironmentObject var game: GameState

    private var state: ChoiceCardState {
        if let selected = game.selectedId {
            if choice.word.id == game.correctId { return .correct }
            if choice.word.id == selected { return .wrong }
            return .dimmed
        }
        return .normal
    }

    var body: some View {
        Button {
            game.selectAnswer(choice.word.id)
        } label: {
            VStack(spacing: 8) {
                // Emoji
                Text(choice.word.emoji)
                    .font(.system(size: 50))
                    .opacity(state == .dimmed ? 0.4 : 1.0)

                // English name
                Text(choice.word.english)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(state == .dimmed ? .white.opacity(0.4) : .white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(cardBackground)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(borderColor, lineWidth: state == .normal ? 0 : 3)
            )
            .scaleEffect(state == .correct ? 1.06 : (state == .wrong ? 0.94 : 1.0))
            .animation(.spring(response: 0.3), value: state)
            .shadow(color: shadowColor.opacity(0.4), radius: 8, y: 4)
        }
        .disabled(game.selectedId != nil)
    }

    @ViewBuilder
    var cardBackground: some View {
        switch state {
        case .correct:
            LinearGradient(colors: [Color(hex: "4caf50"), Color(hex: "2e7d32")], startPoint: .top, endPoint: .bottom)
        case .wrong:
            LinearGradient(colors: [Color(hex: "f44336"), Color(hex: "b71c1c")], startPoint: .top, endPoint: .bottom)
        case .dimmed:
            LinearGradient(colors: [Color(hex: choice.colorTop).opacity(0.3), Color(hex: choice.colorBottom).opacity(0.3)], startPoint: .top, endPoint: .bottom)
        case .normal:
            LinearGradient(colors: [Color(hex: choice.colorTop), Color(hex: choice.colorBottom)], startPoint: .top, endPoint: .bottom)
        }
    }

    var borderColor: Color {
        switch state {
        case .correct: return Color(hex: "a5d6a7")
        case .wrong: return Color(hex: "ef9a9a")
        default: return .clear
        }
    }

    var shadowColor: Color {
        switch state {
        case .correct: return Color(hex: "4caf50")
        case .wrong: return Color(hex: "f44336")
        default: return .black
        }
    }
}

enum ChoiceCardState { case normal, correct, wrong, dimmed }

// MARK: - Helpers
func improveRomanization(_ rom: String) -> String {
    var improved = rom

    // Fix common romanization typos and inconsistencies
    let fixes: [String: String] = [
        "khoo aalaa": "khoo-aa-laa",
        "brokkholii": "bok-ko-lee",
        "khao phot": "khao-phod",
        "fak khao phot": "fak-khao-phod",
        "thoorasap": "tor-ra-sap",
        "thoorathat": "tor-ra-tat",
        "phuukhao": "phu-khao",
        "piaanoo": "pee-a-no",
        "bentoo": "ben-to",
        "looma": "lo-ma",
        "chokkoolaet": "chok-ko-let",
        "chok-ko-laet thaeng": "chok-ko-let-taeng",
        "aeppoen": "aep-poen",
        "tom kha gai": "tom-kha-gai",
        "pad thai": "pad-thai",
        "som tam": "som-tam",
        "satay": "sa-tay",
        "sateh": "sa-tay",
        "khao man gai": "khao-man-gai",
        "moo ping": "moo-ping",
        "naam pla": "nam-pla",
        "naam som": "nam-som",
        "naam manao": "nam-ma-nao",
    ]

    for (old, new) in fixes {
        improved = improved.replacingOccurrences(of: old, with: new)
    }

    return improved
}

// MARK: - Feedback Overlay
struct FeedbackOverlay: View {
    let state: FeedbackState

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(state == .correct ? "✅" : "❌")
                    .font(.system(size: 60))
                    .padding(20)
                    .background(.black.opacity(0.4))
                    .clipShape(Circle())
                Spacer()
            }
            Spacer()
        }
        .transition(.opacity)
    }
}

// MARK: - Confetti
struct ConfettiPiece: Identifiable {
    let id = UUID()
    let color: Color
    let x: CGFloat
    let size: CGFloat
    let rotation: Double
}

struct ConfettiView: View {
    let pieces: [ConfettiPiece] = (0..<30).map { _ in
        ConfettiPiece(
            color: [Color.yellow, Color.pink, Color.green, Color.blue, Color.orange, Color.purple].randomElement()!,
            x: CGFloat.random(in: 0...1),
            size: CGFloat.random(in: 8...16),
            rotation: Double.random(in: 0...360)
        )
    }

    @State private var offsetY: CGFloat = -100

    var body: some View {
        GeometryReader { geo in
            ForEach(pieces) { piece in
                Circle()
                    .fill(piece.color)
                    .frame(width: piece.size, height: piece.size)
                    .position(x: geo.size.width * piece.x, y: offsetY + geo.size.height * CGFloat.random(in: 0.2...0.8))
                    .rotationEffect(.degrees(piece.rotation))
                    .opacity(0.8)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                offsetY = 0
            }
        }
    }
}

// MARK: - Badge Toast
struct BadgeToast: View {
    let badge: BadgeInfo

    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 12) {
                Text(badge.emoji).font(.system(size: 28))
                VStack(alignment: .leading, spacing: 2) {
                    Text("Badge Unlocked!")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                    Text(badge.english)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(Color(hex: "1e293b"))
            .cornerRadius(16)
            .shadow(radius: 10)
            .padding(.horizontal, 16)
            .padding(.bottom, 30)
        }
    }
}

// MARK: - Category Unlocked Popup
struct CategoryUnlockedPopup: View {
    let meta: CategoryMeta

    var body: some View {
        VStack(spacing: 12) {
            Text("🎉 New Category Unlocked!")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
            HStack(spacing: 8) {
                Text(meta.emoji).font(.system(size: 30))
                Text(meta.english)
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(
            LinearGradient(colors: meta.gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(20)
        .shadow(radius: 12)
    }
}
