import SwiftUI

struct ContentView: View {
    @EnvironmentObject var game: GameState

    var body: some View {
        ZStack {
            switch game.screen {
            case .start:
                StartView()
            case .categoryPicker:
                CategoryPickerView()
            case .play:
                PlayView()
            case .profile:
                ProfileView()
            case .settings:
                SettingsView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: game.screen)
    }
}
