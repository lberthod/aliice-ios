import SwiftUI
import AVFoundation

@main
struct AliiceIOSApp: App {
    @StateObject private var gameState = GameState()
    @StateObject private var localizationManager = LocalizationManager.shared

    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .spokenAudio,
                options: [.duckOthers, .mixWithOthers]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("[audio] init failed: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameState)
                .environmentObject(localizationManager)
        }
    }
}
