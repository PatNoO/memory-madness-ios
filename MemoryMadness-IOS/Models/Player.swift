// Player.swift
// Motsvarar Player.kt (data class) i Android-projektet.
// Lagrar spelarens data och spelresultat.
//
// I Android implementerar klassen Serializable för att kunna skickas via Intent.
// I iOS implementerar vi Codable för att kunna spara till UserDefaults (JSON).

import Foundation

struct Player: Codable, Identifiable {
    var id: UUID = UUID()          // Unikt ID för varje spelomgång
    var name: String               // Spelarens namn
    var difficulty: String         // "Easy", "Medium" eller "Hard"
    var pauseEnabled: Bool         // Om pausfunktionen var aktiverad
    var timeRemaining: Int         // Kvarvarande sekunder när spelet vanns
    var moves: Int                 // Antal drag som gjordes
    var theme: String              // Temats råvärde, t.ex. "🎃 HALLOWEEN"
}
