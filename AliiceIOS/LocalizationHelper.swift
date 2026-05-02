import Foundation
import SwiftUI

// MARK: - Localization Manager (Controllable Language)
class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()

    @Published var currentLanguage: String = {
        return UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
    }()

    init() {
        // Load saved language or use system default
        if let saved = UserDefaults.standard.string(forKey: "AppLanguage") {
            currentLanguage = saved
        } else {
            let systemLang = Locale.preferredLanguages.first ?? "en"
            currentLanguage = systemLang.hasPrefix("fr") ? "fr" : "en"
        }
    }

    func setLanguage(_ languageCode: String) {
        currentLanguage = languageCode
        UserDefaults.standard.set(languageCode, forKey: "AppLanguage")
    }

    func getLocalizedWord(_ word: Word) -> String {
        return currentLanguage.hasPrefix("fr") ? word.french : word.english
    }

    func localize(_ key: String) -> String {
        // Dictionary of translations
        let translations: [String: [String: String]] = [
            "en": [
                "Aliice": "Aliice",
                "Learn Thai": "Learn Thai",
                "Play": "Play",
                "How to Learn": "How to Learn",
                "Thai vocabulary guide": "Thai vocabulary guide",
                "Choose a Category": "Choose a Category",
                "Badge Unlocked!": "Badge Unlocked!",
                "🎉 New Category Unlocked!": "🎉 New Category Unlocked!",
                "Wrong answer": "Wrong answer",
                "Mastery count drops by 1 — the word comes back more often.": "Mastery count drops by 1 — the word comes back more often.",
                "Pro Tips": "Pro Tips",
                "1 000": "1 000",
                "words": "words",
                "80%": "80%",
                "of everyday Thai": "of everyday Thai",
                "What you'll learn": "What you'll learn",
                "Score": "Score",
                "Best": "Best",
                "Level": "Level",
                "Profile": "Profile",
                "Stats": "Stats",
                "Badges": "Badges",
                "Hint": "Hint",
                "left": "left",
                "correct": "correct",
                "Tap to set name": "Tap to set name",
            ],
            "fr": [
                "Aliice": "Aliice",
                "Learn Thai": "Apprendre le Thaï",
                "Play": "Jouer",
                "How to Learn": "Comment apprendre",
                "Thai vocabulary guide": "Guide de vocabulaire Thaï",
                "Choose a Category": "Choisir une catégorie",
                "Badge Unlocked!": "Badge débloqué!",
                "🎉 New Category Unlocked!": "🎉 Nouvelle catégorie débloquée!",
                "Wrong answer": "Mauvaise réponse",
                "Mastery count drops by 1 — the word comes back more often.": "La maîtrise baisse de 1 — le mot revient plus souvent.",
                "Pro Tips": "Conseils Pro",
                "1 000": "1 000",
                "words": "mots",
                "80%": "80%",
                "of everyday Thai": "du Thaï quotidien",
                "What you'll learn": "Ce que tu apprendras",
                "Score": "Score",
                "Best": "Meilleur",
                "Level": "Niveau",
                "Profile": "Profil",
                "Stats": "Stats",
                "Badges": "Badges",
                "Hint": "Indice",
                "left": "restant(s)",
                "correct": "correct",
                "Tap to set name": "Appuyez pour définir le nom",
            ]
        ]

        let lang = currentLanguage.hasPrefix("fr") ? "fr" : "en"
        return translations[lang]?[key] ?? key
    }
}

// MARK: - Simple Localization Function
func localize(_ key: String) -> String {
    return LocalizationManager.shared.localize(key)
}

// MARK: - Word Localization Helper
func getLocalizedWord(_ word: Word) -> String {
    return LocalizationManager.shared.getLocalizedWord(word)
}
