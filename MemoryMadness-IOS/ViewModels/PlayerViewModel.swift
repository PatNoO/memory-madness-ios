// PlayerViewModel.swift
// Motsvarar PlayerViewModel.kt i Android-projektet.
// Hanterar spelarinställningar under hela spelsessionen.
//
// I Android: ViewModel + MutableLiveData
// I iOS:     ObservableObject + @Published
//
// @MainActor säkerställer att alla uppdateringar sker på main thread
// (samma som Android's LiveData som alltid uppdateras på UI-tråden)

import Foundation
import SwiftUI

@Observable
@MainActor
class PlayerViewModel {
    var name: String = ""                         // Spelarens namn
    var difficulty: String = "Easy"               // Vald svårighetsgrad
    var theme: CardTheme = .halloween             // Valt tema
    var pauseEnabled: Bool = false                // Pausfunktion på/av

    // Antalet kort-par för aktuell svårighetsgrad
    // Easy = 3 par (6 kort), Medium = 6 par (12 kort), Hard = 9 par (18 kort)
    var pairCount: Int {
        switch difficulty {
        case "Easy":   return 3
        case "Medium": return 6
        case "Hard":   return 9
        default:       return 3
        }
    }

    // Byter till nästa tema i ordningen (cyklisk)
    // Används av "Change Theme"-knappen, precis som i Android
    func cycleTheme() {
        let allThemes = CardTheme.allCases
        let currentIndex = allThemes.firstIndex(of: theme) ?? 0
        let nextIndex = (currentIndex + 1) % allThemes.count
        theme = allThemes[nextIndex]
    }
}
