// CardTheme.swift
// Motsvarar CardTheme.kt (enum class) i Android-projektet.
// Definierar de 4 korttemana med tillhörande bildnamn.

import Foundation

enum CardTheme: String, CaseIterable, Codable {
    case halloween    = "🎃 HALLOWEEN"
    case christmas    = "🎄 CHRISTMAS"
    case easter       = "🐣 EASTER"
    case stPatricksDay = "☘️ ST. PATRICK'S DAY"
    case saga         = "⚔️ SAGA"

    // Returnerar bildnamnen för temat
    // I Android används drawable resource IDs — i iOS använder vi tillgångsnamn (Assets.xcassets)
    var themeSet: [String] {
        switch self {
        case .halloween:
            return (1...9).map { "card\($0)" }       // card1, card2, ..., card9
        case .christmas:
            return (1...9).map { "xmas\($0)" }       // xmas1, xmas2, ..., xmas9
        case .easter:
            return (1...9).map { "easter\($0)" }     // easter1, easter2, ..., easter9
        case .stPatricksDay:
            return (1...9).map { "stpday\($0)" }     // stpday1, stpday2, ..., stpday9
        case .saga:
            return (1...12).map { "saga\($0)" }      // saga1, saga2, ..., saga12
        }
    }

    // Bilden som visas som förhandsgranskning i menyer
    var previewImageName: String {
        switch self {
        case .saga:
            return "saga6"
        default:
            return themeSet.first ?? "card1"
        }
    }
}
