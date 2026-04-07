// HighScoreView.swift
// Motsvarar HighScoreFragment i Android-projektet.
// Visar sparade highscores filtrerade per svårighetsgrad.
//
// Android: RecyclerView + HighScoreRecyclerAdapter
// iOS:     List + ForEach med HighScoreRowView

import SwiftUI

struct HighScoreView: View {
    @Environment(AppState.self) var appState
    @Environment(PlayerViewModel.self) var playerVM
    @Environment(GameViewModel.self) var gameVM

    // Filtrering per svårighetsgrad — Standard: Easy (precis som i Android)
    @State private var selectedDifficulty: String = "Easy"

    // Ladda alla sparade poäng
    private var allScores: [Player] { ScoreStorage.loadScores() }

    // Filtrera och sortera poängen (lägre antal drag = bättre, som i Android)
    private var filteredScores: [Player] {
        allScores
            .filter { $0.difficulty == selectedDifficulty }
            .sorted { $0.moves < $1.moves }
    }

    var body: some View {
        ZStack {
            Color.appGray.ignoresSafeArea()

            VStack(spacing: 0) {

                // Rubrik
                Text("Highscore")
                    .font(.system(size: 30, weight: .bold))
                    .padding(.top, 32)
                    .padding(.bottom, 16)

                // Svårighetsfilter
                // I Android: tre knappar — Easy, Medium, Hard
                // I iOS: Picker med segmented style
                Picker("Svårighetsgrad", selection: $selectedDifficulty) {
                    Text("Easy").tag("Easy")
                    Text("Medium").tag("Medium")
                    Text("Hard").tag("Hard")
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.bottom, 16)

                // Highscore-lista
                // I Android: RecyclerView med LinearLayoutManager
                // I iOS: List med ForEach
                if filteredScores.isEmpty {
                    Spacer()
                    Text("Inga sparade poäng för \(selectedDifficulty)")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    Spacer()
                } else {
                    List {
                        ForEach(Array(filteredScores.enumerated()), id: \.element.id) { index, player in
                            HighScoreRowView(player: player, rank: index + 1)
                                .listRowBackground(Color.appGray)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        }
                    }
                    .listStyle(.plain)
                    .background(Color.appGray)
                    .scrollContentBackground(.hidden)
                }

                Divider()

                // Knappar längst ner
                VStack(spacing: 12) {
                    Button(action: playAgain) {
                        Text("Spela igen")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.appRed)

                    Button(action: { appState.currentScreen = .homeMenu }) {
                        Text("Hem-meny")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.gray)
                }
                .padding()
            }
        }
    }

    private func playAgain() {
        gameVM.resetGame()
        gameVM.setupCards(theme: playerVM.theme, pairCount: playerVM.pairCount)
        appState.navigateToGame(difficulty: playerVM.difficulty)
    }
}
