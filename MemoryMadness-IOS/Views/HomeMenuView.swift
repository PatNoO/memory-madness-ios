// HomeMenuView.swift
// Motsvarar HomeMenuFragment i Android-projektet.
// Huvudmenyn — spelaren kan starta spel, byta inställningar eller se highscore.

import SwiftUI

struct HomeMenuView: View {
    @Environment(AppState.self) var appState
    @Environment(PlayerViewModel.self) var playerVM
    @Environment(GameViewModel.self) var gameVM

    @State private var newNameInput: String = ""
    @State private var showEndGameAlert: Bool = false   // AlertDialog i Android

    var body: some View {
        @Bindable var playerVM = playerVM
        ZStack {
            Color.appGray.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {

                    // Rubrik
                    Text("Memory Madness\nMenu")
                        .font(.system(size: 30, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding(.top, 32)

                    // Temabild + namn
                    Image(playerVM.theme.previewImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 80)
                        .cornerRadius(10)

                    Text(playerVM.theme.rawValue)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)

                    Text("Svårighetsgrad: \(playerVM.difficulty)")
                        .font(.system(size: 16, weight: .semibold))

                    Divider()

                    // Byt namn
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Spelaren: \(playerVM.name)")
                            .font(.system(size: 16, weight: .semibold))
                        HStack {
                            TextField("Nytt namn...", text: $newNameInput)
                                .textFieldStyle(.roundedBorder)
                                .autocorrectionDisabled()
                            Button("Spara") {
                                saveNewName()
                            }
                            .buttonStyle(.bordered)
                            .tint(.appRed)
                            .disabled(newNameInput.trimmingCharacters(in: .whitespaces).isEmpty)
                        }
                    }
                    .padding(.horizontal)

                    // Paus-toggle
                    Toggle("Aktivera paus", isOn: $playerVM.pauseEnabled)
                        .padding(.horizontal)
                        .tint(.appRed)

                    Divider()

                    // Starta spel
                    Button(action: startGame) {
                        Text("Starta spel")
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.appRed)
                    .padding(.horizontal)

                    // Byt tema
                    Button(action: { playerVM.cycleTheme() }) {
                        Text("Byt tema")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.appRed)
                    .padding(.horizontal)

                    // Svårighetsgrad
                    Button(action: { appState.currentScreen = .difficulty }) {
                        Text("Svårighetsgrad")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.appRed)
                    .padding(.horizontal)

                    // Highscore
                    Button(action: { appState.currentScreen = .highScore }) {
                        Text("Highscore")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.appRed)
                    .padding(.horizontal)

                    // Avsluta — visar AlertDialog (precis som i Android)
                    Button(action: { showEndGameAlert = true }) {
                        Text("Avsluta spel")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.gray)
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
                .padding()
            }
        }
        // AlertDialog — motsvarar AlertDialog.Builder i Android
        .alert("Avsluta spelet?", isPresented: $showEndGameAlert) {
            Button("Ja, avsluta", role: .destructive) {
                // Stänger appen (iOS stöder inte programmatisk avslutning, men
                // vi navigerar tillbaka till startsidan som workaround)
                appState.currentScreen = .start
            }
            Button("Avbryt", role: .cancel) {}
        } message: {
            Text("Är du säker på att du vill avsluta?")
        }
    }

    private func startGame() {
        gameVM.setupCards(theme: playerVM.theme, pairCount: playerVM.pairCount)
        appState.navigateToGame(difficulty: playerVM.difficulty)
    }

    private func saveNewName() {
        let trimmed = newNameInput.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        playerVM.name = trimmed
        newNameInput = ""
    }
}
