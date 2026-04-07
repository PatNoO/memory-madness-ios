// StartView.swift
// Motsvarar StartActivity i Android-projektet.
// Första skärmen — spelaren anger namn, svårighetsgrad, tema och pausinställning.

import SwiftUI

struct StartView: View {
    @Environment(AppState.self) var appState
    @Environment(PlayerViewModel.self) var playerVM
    @Environment(GameViewModel.self) var gameVM

    // Lokal state för textfältet
    @State private var nameInput: String = ""

    var body: some View {
        @Bindable var playerVM = playerVM
        ZStack {
            Color.appGray.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {

                    // Rubrik
                    Text("Welcome to\nMemory Madness")
                        .font(.system(size: 32, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding(.top, 40)

                    // Förhandsgranskning av valt tema
                    Image(playerVM.theme.previewImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 100)
                        .cornerRadius(12)

                    Text(playerVM.theme.rawValue)
                        .font(.system(size: 18))
                        .foregroundColor(.secondary)

                    // Namnfält
                    // I Android: EditText — i SwiftUI: TextField
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ditt namn")
                            .font(.system(size: 16, weight: .semibold))
                        TextField("Ange namn...", text: $nameInput)
                            .textFieldStyle(.roundedBorder)
                            .autocorrectionDisabled()
                    }
                    .padding(.horizontal)

                    // Svårighetsval
                    // I Android: Spinner — i SwiftUI: Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Svårighetsgrad")
                            .font(.system(size: 16, weight: .semibold))
                        Picker("Svårighetsgrad", selection: $playerVM.difficulty) {
                            Text("Easy").tag("Easy")
                            Text("Medium").tag("Medium")
                            Text("Hard").tag("Hard")
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.horizontal)

                    // Pausinställning
                    // I Android: CheckBox — i SwiftUI: Toggle
                    Toggle("Aktivera paus", isOn: $playerVM.pauseEnabled)
                        .padding(.horizontal)
                        .tint(.appRed)

                    // Byt tema
                    Button(action: { playerVM.cycleTheme() }) {
                        Text("Byt tema")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.appRed)
                    .padding(.horizontal)

                    // Starta spel
                    Button(action: startGame) {
                        Text("Starta spel")
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.appRed)
                    .padding(.horizontal)
                    .disabled(nameInput.trimmingCharacters(in: .whitespaces).isEmpty)

                    Spacer(minLength: 40)
                }
                .padding()
            }
        }
    }

    private func startGame() {
        let trimmedName = nameInput.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }

        playerVM.name = trimmedName
        gameVM.setupCards(theme: playerVM.theme, pairCount: playerVM.pairCount)
        appState.navigateToGame(difficulty: playerVM.difficulty)
    }
}
