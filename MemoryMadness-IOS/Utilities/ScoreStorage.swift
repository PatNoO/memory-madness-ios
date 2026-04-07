// ScoreStorage.swift
// Motsvarar UtilityScorePrefs.kt i Android-projektet.
// Sparar och läser in highscores från enhetens lagring.
//
// Android: SharedPreferences + Gson (extern lib för JSON)
// iOS:     UserDefaults + Codable (inbyggt i Swift, ingen extra lib behövs)

import Foundation

struct ScoreStorage {

    private static let key = "player_score_key"

    /// Sparar en lista med spelare till UserDefaults (JSON-format).
    /// Motsvarar savedPrefsScore() i Android.
    static func saveScores(_ players: [Player]) {
        guard let data = try? JSONEncoder().encode(players) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    /// Läser in sparade spelare från UserDefaults.
    /// Returnerar tom lista om inget finns sparat.
    /// Motsvarar loadPrefsScore() i Android.
    static func loadScores() -> [Player] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let players = try? JSONDecoder().decode([Player].self, from: data)
        else { return [] }
        return players
    }

    /// Lägger till en ny poäng och sparar.
    static func addScore(_ player: Player) {
        var current = loadScores()
        current.append(player)
        saveScores(current)
    }
}
