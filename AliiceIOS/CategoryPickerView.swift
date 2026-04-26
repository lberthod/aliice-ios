import SwiftUI

struct CategoryPickerView: View {
    @EnvironmentObject var game: GameState

    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack {
            Color(hex: "f0f4ff").ignoresSafeArea()

            VStack(spacing: 0) {
                // Nav bar
                HStack {
                    Button {
                        game.screen = .start
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: "764ba2"))
                            .padding(10)
                            .background(.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.1), radius: 4)
                    }

                    Spacer()

                    Text("Choose a Category")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "333"))

                    Spacer()
                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 8)

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 14) {
                        // "All" category
                        if game.isCatUnlocked("all") {
                            CategoryCard(
                                meta: CategoryMeta(id: "all", english: "All", thai: "ทั้งหมด", emoji: "🌍",
                                                   gradient: [Color(hex: "ffd86b"), Color(hex: "ff9d43")]),
                                isSelected: game.currentCategory == "all",
                                isUnlocked: true,
                                masteryRatio: 0
                            ) {
                                game.startGame(category: "all")
                            }
                        }

                        ForEach(LEARNING_PATH, id: \.self) { catId in
                            if let meta = CATEGORY_META[catId] {
                                let unlocked = game.isCatUnlocked(catId)
                                let ratio = game.catMasteryRatio(catId)
                                CategoryCard(
                                    meta: meta,
                                    isSelected: game.currentCategory == catId,
                                    isUnlocked: unlocked,
                                    masteryRatio: ratio
                                ) {
                                    if unlocked {
                                        game.startGame(category: catId)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
            }
        }
    }
}

struct CategoryCard: View {
    let meta: CategoryMeta
    let isSelected: Bool
    let isUnlocked: Bool
    let masteryRatio: Double
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                // Background gradient
                LinearGradient(colors: isUnlocked ? meta.gradient : [Color.gray.opacity(0.4), Color.gray.opacity(0.6)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                    .cornerRadius(16)

                VStack(spacing: 6) {
                    if !isUnlocked {
                        Text("🔒")
                            .font(.system(size: 28))
                    } else {
                        Text(meta.emoji)
                            .font(.system(size: 28))
                    }

                    Text(meta.english)
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(isUnlocked ? .white : .white.opacity(0.6))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    // Mastery bar
                    if isUnlocked && masteryRatio > 0 {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(.white.opacity(0.3)).frame(height: 4)
                                Capsule().fill(.white).frame(width: geo.size.width * masteryRatio, height: 4)
                            }
                        }
                        .frame(height: 4)
                        .padding(.horizontal, 8)
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 8)

                if isSelected {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white, lineWidth: 3)
                }
            }
            .frame(height: 90)
            .shadow(color: .black.opacity(0.15), radius: 6, y: 3)
        }
        .scaleEffect(isSelected ? 0.96 : 1.0)
        .disabled(!isUnlocked)
    }
}
