// MemoryMadnessApp.swift
// Appens startpunkt.
// I Android är detta AndroidManifest.xml + MainActivity.
// I iOS är @main-strukturen ingångspunkten.
//
// ViewModels skapas här en gång och delas med hela appen via .environmentObject()
// — precis som Android delar ViewModels via ViewModelProvider i aktiviteter.

import SwiftUI

@main
struct MemoryMadnessApp: App {
    // Dessa skapas en gång och lever under hela appens livstid
    @State private var appState = AppState()
    @State private var playerVM = PlayerViewModel()
    @State private var gameVM = GameViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
                .environment(playerVM)
                .environment(gameVM)
        }
    }
}
