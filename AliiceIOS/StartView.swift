import SwiftUI

struct StartView: View {
    @EnvironmentObject var game: GameState

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar
                HStack {
                    Spacer()
                    Button {
                        game.screen = .profile
                    } label: {
                        Text(game.profileAvatar.isEmpty ? "🐼" : game.profileAvatar)
                            .font(.system(size: 36))
                            .padding(8)
                            .background(.white.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                Spacer()

                // Logo & title
                VStack(spacing: 12) {
                    Text("🇹🇭")
                        .font(.system(size: 80))
                        .shadow(radius: 8)

                    Text("Aliice")
                        .font(.system(size: 48, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 4, y: 2)

                    Text("Learn Thai")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.85))
                }

                Spacer()

                // Stats row
                HStack(spacing: 20) {
                    StatChip(emoji: "⭐", value: "\(game.score)", label: "Score")
                    StatChip(emoji: "🔥", value: "\(game.bestStreak)", label: "Best")
                    StatChip(emoji: "📈", value: "Lv \(game.level)", label: "Level")
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)

                // Buttons
                VStack(spacing: 12) {
                    Button {
                        game.screen = .categoryPicker
                    } label: {
                        HStack(spacing: 12) {
                            Text("🎮")
                                .font(.system(size: 24))
                            Text("Play")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "764ba2"))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(.white)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
                    }

                    Button {
                        game.screen = .settings
                    } label: {
                        HStack(spacing: 8) {
                            Text("📚")
                                .font(.system(size: 16))
                            Text("How to Learn")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(.white.opacity(0.9))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(.white.opacity(0.2))
                        .cornerRadius(14)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
        }
    }
}

struct StatChip: View {
    let emoji: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(emoji).font(.system(size: 20))
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(.white.opacity(0.15))
        .cornerRadius(14)
    }
}
