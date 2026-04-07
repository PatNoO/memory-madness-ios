// ContentView.swift
// Rotvy — hanterar vilken skärm som visas.
// I Android är detta MainActivity med FragmentContainerView.
//
// AppState håller reda på aktuell skärm.
// Varje switch-case motsvarar ett Fragment i Android-appen.

import SwiftUI

// Enum för alla skärmar i appen — ersätter Android's Fragment-navigation
enum AppScreen {
    case start           // StartActivity
    case homeMenu        // HomeMenuFragment
    case difficulty      // DifficultyFragment
    case easyGame        // EasyFragment
    case mediumGame      // MediumFragment
    case hardGame        // HardFragment
    case win             // WinFragment
    case highScore       // HighScoreFragment
}

// AppState hanterar navigering — liknande NavController i Android
@Observable
@MainActor
class AppState {
    var currentScreen: AppScreen = .start
}

struct ContentView: View {
    @Environment(AppState.self) var appState
    @Environment(PlayerViewModel.self) var playerVM
    @Environment(GameViewModel.self) var gameVM

    var body: some View {
        // Visa rätt skärm baserat på appState.currentScreen
        // I Android görs detta med FragmentTransaction eller NavController
        Group {
            switch appState.currentScreen {
            case .start:
                StartView()
            case .homeMenu:
                HomeMenuView()
            case .difficulty:
                DifficultyView()
            case .easyGame:
                GameBoardView(pairCount: 3)    // 3 par = 6 kort
            case .mediumGame:
                GameBoardView(pairCount: 6)    // 6 par = 12 kort
            case .hardGame:
                GameBoardView(pairCount: 9)    // 9 par = 18 kort
            case .win:
                WinView()
            case .highScore:
                HighScoreView()
            }
        }
        // Animation vid skärmbyten
        .animation(.easeInOut(duration: 0.25), value: appState.currentScreen == .start)
    }
}

// MARK: - Hjälpfunktion för navigering till rätt spel baserat på svårighetsgrad
extension AppState {
    func navigateToGame(difficulty: String) {
        switch difficulty {
        case "Easy":   currentScreen = .easyGame
        case "Medium": currentScreen = .mediumGame
        case "Hard":   currentScreen = .hardGame
        default:       currentScreen = .easyGame
        }
    }
}
