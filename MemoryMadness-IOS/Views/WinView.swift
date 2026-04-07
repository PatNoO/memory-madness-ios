// WinView.swift
// Motsvarar WinFragment i Android-projektet.
// Visas när spelaren hittar alla par. Visar resultat och ger möjlighet att spara.

import SwiftUI

struct WinView: View {
    @Environment(AppState.self) var appState
    @Environment(PlayerViewModel.self) var playerVM
    @Environment(GameViewModel.self) var gameVM

    @State private var scoreSaved: Bool = false   // Förhindrar att man sparar flera gånger
    @State private var showSavedConfirmation: Bool = false

    var body: some View {
        ZStack {
            Color.appGray.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Text("Grattis! 🎉")
                        .font(.system(size: 36, weight: .bold))
                        .padding(.top, 48)

                    // Temabild
                    Image(playerVM.theme.previewImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 90)
                        .cornerRadius(12)

                    Text(playerVM.theme.rawValue)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)

                    // Resultatbox
                    resultBox

                    Divider()

                    // Spara poäng (kan bara göras en gång, precis som i Android med clickCounter)
                    Button(action: saveScore) {
                        Text(scoreSaved ? "Poäng sparad ✓" : "Spara poäng")
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(scoreSaved ? .green : .appRed)
                    .disabled(scoreSaved)
                    .padding(.horizontal)

                    // Spela igen (samma svårighetsgrad)
                    Button(action: playAgain) {
                        Text("Spela igen")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.appRed)
                    .padding(.horizontal)

                    // Visa highscore
                    Button(action: {
                        gameVM.resetGame()
                        appState.currentScreen = .highScore
                    }) {
                        Text("Highscore")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.appRed)
                    .padding(.horizontal)

                    // Hem-meny
                    Button(action: goHome) {
                        Text("Hem-meny")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.gray)
                    .padding(.horizontal)
                    .padding(.bottom, 48)
                }
                .padding()
            }
        }
        // Toast-liknande bekräftelse när poäng sparas
        .overlay(alignment: .bottom) {
            if showSavedConfirmation {
                Text("Poäng sparad!")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.bottom, 40)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: showSavedConfirmation)
    }

    // MARK: - Resultatbox
    private var resultBox: some View {
        VStack(spacing: 12) {
            Text("Ditt resultat")
                .font(.system(size: 20, weight: .bold))

            HStack(spacing: 40) {
                VStack {
                    Text("Tid kvar")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    Text(formattedTime)
                        .font(.system(size: 24, weight: .bold))
                }

                VStack {
                    Text("Drag")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    Text("\(gameVM.moves)")
                        .font(.system(size: 24, weight: .bold))
                }
            }

            Text("Svårighetsgrad: \(playerVM.difficulty)")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        .padding(.horizontal)
    }

    // MARK: - Hjälpfunktioner
    private var formattedTime: String {
        let minutes = gameVM.timeRemaining / 60
        let seconds = gameVM.timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func saveScore() {
        guard !scoreSaved else { return }
        scoreSaved = true

        let player = Player(
            name: playerVM.name,
            difficulty: playerVM.difficulty,
            pauseEnabled: playerVM.pauseEnabled,
            timeRemaining: gameVM.timeRemaining,
            moves: gameVM.moves,
            theme: playerVM.theme.rawValue
        )
        ScoreStorage.addScore(player)

        // Visa bekräftelse (Toast i Android)
        showSavedConfirmation = true
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 sekunder
            showSavedConfirmation = false
        }
    }

    private func playAgain() {
        gameVM.resetGame()
        gameVM.setupCards(theme: playerVM.theme, pairCount: playerVM.pairCount)
        appState.navigateToGame(difficulty: playerVM.difficulty)
    }

    private func goHome() {
        gameVM.resetGame()
        appState.currentScreen = .homeMenu
    }
}
