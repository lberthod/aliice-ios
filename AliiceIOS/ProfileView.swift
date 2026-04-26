import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var game: GameState
    @State private var editingName = false
    @State private var nameInput = ""

    let avatars = ["🐼", "🐯", "🦊", "🐸", "🐵", "🦄", "🐙", "🦁", "🐨", "🐶", "🐱", "🦉", "🐧", "🐻", "🦋"]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Back button
                    HStack {
                        Button {
                            game.screen = .start
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(.white.opacity(0.2))
                                .clipShape(Circle())
                        }
                        Spacer()
                        Text("Profile")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Spacer()
                        Color.clear.frame(width: 44)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                    // Avatar picker
                    VStack(spacing: 12) {
                        Text(game.profileAvatar)
                            .font(.system(size: 70))

                        // Name
                        if editingName {
                            HStack {
                                TextField("Your name", text: $nameInput)
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .textFieldStyle(.plain)
                                    .frame(maxWidth: 180)

                                Button {
                                    game.profileName = nameInput
                                    game.save()
                                    editingName = false
                                } label: {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.white)
                                }
                            }
                        } else {
                            Button {
                                nameInput = game.profileName
                                editingName = true
                            } label: {
                                HStack(spacing: 6) {
                                    Text(game.profileName.isEmpty ? "Tap to set name" : game.profileName)
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                    Image(systemName: "pencil")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.6))
                                }
                            }
                        }

                        // Avatar grid
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 8) {
                            ForEach(avatars, id: \.self) { av in
                                Button {
                                    game.profileAvatar = av
                                    game.save()
                                } label: {
                                    Text(av)
                                        .font(.system(size: 28))
                                        .padding(6)
                                        .background(game.profileAvatar == av ? .white.opacity(0.3) : .clear)
                                        .clipShape(Circle())
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                    }
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(.white.opacity(0.15))
                    .cornerRadius(20)
                    .padding(.horizontal, 16)

                    // Stats
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Stats")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.leading, 4)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            StatCard(emoji: "⭐", value: "\(game.score)", label: "Total Score")
                            StatCard(emoji: "🔥", value: "\(game.bestStreak)", label: "Best Streak")
                            StatCard(emoji: "📈", value: "Level \(game.level)", label: "Current Level")
                            StatCard(emoji: "📖", value: "\(game.masteredWordsCount)", label: "Words Mastered")
                            StatCard(emoji: "🏆", value: "\(game.masteredCatsCount)", label: "Categories Done")
                            StatCard(emoji: "🎯", value: "\(game.unlockedBadges.count)", label: "Badges Earned")
                        }
                    }
                    .padding(.horizontal, 16)

                    // Badges
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Badges")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.leading, 4)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
                            ForEach(ALL_BADGES) { badge in
                                let earned = game.unlockedBadges.contains(badge.id)
                                let prog = badge.progress(BadgeSnapshot(
                                    score: game.score,
                                    bestStreak: game.bestStreak,
                                    level: game.level,
                                    masteredCats: game.masteredCatsCount,
                                    masteredWords: game.masteredWordsCount
                                ))
                                VStack(spacing: 4) {
                                    Text(badge.emoji)
                                        .font(.system(size: 28))
                                        .opacity(earned ? 1 : 0.3)
                                    Text(badge.english)
                                        .font(.system(size: 9, weight: .semibold))
                                        .foregroundColor(earned ? .white : .white.opacity(0.3))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)

                                    if !earned {
                                        Text("\(prog.have)/\(prog.need)")
                                            .font(.system(size: 9))
                                            .foregroundColor(.white.opacity(0.4))
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(.white.opacity(earned ? 0.2 : 0.08))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal, 16)

                    Spacer().frame(height: 30)
                }
            }
        }
    }
}

struct StatCard: View {
    let emoji: String
    let value: String
    let label: String

    var body: some View {
        HStack(spacing: 10) {
            Text(emoji).font(.system(size: 24))
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text(label)
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.6))
            }
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(.white.opacity(0.15))
        .cornerRadius(14)
    }
}
