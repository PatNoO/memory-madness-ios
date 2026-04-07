// DifficultyView.swift
// Motsvarar DifficultyFragment i Android-projektet.
// Låter spelaren välja svårighetsgrad och navigerar sedan tillbaka till menyn.

import SwiftUI

struct DifficultyView: View {
    @Environment(AppState.self) var appState
    @Environment(PlayerViewModel.self) var playerVM

    var body: some View {
        ZStack {
            Color.appGray.ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Välj svårighetsgrad")
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.top, 48)

                Text("Nuvarande: \(playerVM.difficulty)")
                    .font(.system(size: 18))
                    .foregroundColor(.secondary)

                Spacer()

                // Easy-knapp
                DifficultyButton(label: "Easy", description: "6 kort (3 par)") {
                    selectDifficulty("Easy")
                }

                // Medium-knapp
                DifficultyButton(label: "Medium", description: "12 kort (6 par)") {
                    selectDifficulty("Medium")
                }

                // Hard-knapp
                DifficultyButton(label: "Hard", description: "18 kort (9 par)") {
                    selectDifficulty("Hard")
                }

                Spacer()

                // Tillbaka
                Button(action: { appState.currentScreen = .homeMenu }) {
                    Text("Tillbaka")
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

    private func selectDifficulty(_ difficulty: String) {
        playerVM.difficulty = difficulty
        // Vänta 400ms innan navigation, precis som delay(400) i Android
        Task {
            try? await Task.sleep(nanoseconds: 400_000_000)
            appState.currentScreen = .homeMenu
        }
    }
}

// MARK: - Hjälpkomponent för svårighetsknapp
private struct DifficultyButton: View {
    let label: String
    let description: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(label)
                    .font(.system(size: 22, weight: .bold))
                Text(description)
                    .font(.system(size: 14))
                    .opacity(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
        .buttonStyle(.borderedProminent)
        .tint(.appRed)
        .padding(.horizontal)
    }
}
