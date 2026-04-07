// GameBoardView.swift
// Hanterar spelplanen för alla tre svårighetsnivåer.
// I Android finns tre separata fragment (EasyFragment, MediumFragment, HardFragment)
// med nästan identisk kod. Här slår vi ihop dem till en enda vy med parameter.
//
// pairCount: 3 = Easy (6 kort), 6 = Medium (12 kort), 9 = Hard (18 kort)

import SwiftUI

struct GameBoardView: View {
    let pairCount: Int

    @Environment(AppState.self) var appState
    @Environment(PlayerViewModel.self) var playerVM
    @Environment(GameViewModel.self) var gameVM

    var body: some View {
        @Bindable var gameVM = gameVM
        ZStack {
            Color.appGray.ignoresSafeArea()

            VStack(spacing: 12) {

                // MARK: - Topprad med timer och drag
                headerSection

                // MARK: - Spelplan (kortgrid utan scroll — hela planen syns på skärmen)
                GeometryReader { geo in
                    let rows = (gameVM.cards.count + 2) / 3
                    let spacing: CGFloat = 8
                    let cardWidth = (geo.size.width - spacing * 2) / 3
                    let cardHeight = (geo.size.height - spacing * CGFloat(rows - 1)) / CGFloat(rows)

                    LazyVGrid(
                        columns: Array(repeating: GridItem(.fixed(cardWidth), spacing: spacing), count: 3),
                        spacing: spacing
                    ) {
                        ForEach(gameVM.cards.indices, id: \.self) { index in
                            CardTileView(card: gameVM.cards[index])
                                .frame(width: cardWidth, height: cardHeight)
                                .onTapGesture {
                                    gameVM.flipCard(at: index)
                                }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 8)

                // MARK: - Paus (visas bara om aktiverat)
                if playerVM.pauseEnabled {
                    pauseSection
                }

                // MARK: - Hemknapp
                Button(action: goHome) {
                    Text("Hem-meny")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.gray)
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
        }
        // Initialisera korten när vyn visas
        .onAppear {
            gameVM.setupCards(theme: playerVM.theme, pairCount: pairCount)
        }
        // Städa upp timern när vyn försvinner
        .onDisappear {
            gameVM.stopTimer()
        }
        // Navigera till WinView när alla par är matchade
        .onChange(of: gameVM.isWon) { _, won in
            if won {
                appState.currentScreen = .win
            }
        }
        // Visa "Förlorade"-dialog när timern når noll
        .alert("Tiden är slut!", isPresented: $gameVM.isGameOver) {
            Button("Spela igen") {
                gameVM.setupCards(theme: playerVM.theme, pairCount: pairCount)
            }
            Button("Hem-meny") {
                gameVM.resetGame()
                appState.currentScreen = .homeMenu
            }
        } message: {
            Text("Du hann inte hitta alla par. Försök igen!")
        }
    }

    // MARK: - Topprad
    private var headerSection: some View {
        HStack {
            // Timer
            VStack(alignment: .leading, spacing: 2) {
                Text("Tid")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                Text(gameVM.formattedTime)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(gameVM.timeRemaining <= 5 ? .red : .primary)
            }

            Spacer()

            // Svårighetsgrad
            Text(playerVM.difficulty)
                .font(.system(size: 16, weight: .semibold))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.appRed.opacity(0.15))
                .cornerRadius(8)

            Spacer()

            // Drag
            VStack(alignment: .trailing, spacing: 2) {
                Text("Drag")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                Text("\(gameVM.moves)")
                    .font(.system(size: 22, weight: .bold))
            }
        }
        .padding(.horizontal)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    // MARK: - Paussektion
    // I Android: Switch-widget som visas/döljs med visibility
    // I iOS: Toggle-komponent
    private var pauseSection: some View {
        HStack {
            Text(gameVM.isPaused ? "Spelet är pausat" : "Paus")
                .font(.system(size: 16))

            Spacer()

            // Toggle för paus
            // I Android: Switch med onCheckedChangeListener
            Toggle("", isOn: Binding(
                get: { gameVM.isPaused },
                set: { shouldPause in
                    if shouldPause {
                        gameVM.pauseGame()
                    } else {
                        gameVM.resumeGame()
                    }
                }
            ))
            .labelsHidden()
            .tint(.appRed)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.6))
        .cornerRadius(10)
        .padding(.horizontal)
    }

    // MARK: - Hemnavigation
    private func goHome() {
        gameVM.resetGame()
        appState.currentScreen = .homeMenu
    }
}
