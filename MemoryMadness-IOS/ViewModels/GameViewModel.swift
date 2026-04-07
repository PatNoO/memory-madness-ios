// GameViewModel.swift
// Motsvarar GameViewModel.kt i Android-projektet.
// Hanterar all spellogik: kort, timer, drag och matchningar.
//
// Android: ViewModel + MutableLiveData + viewModelScope (Coroutine)
// iOS:     ObservableObject + @Published + Task (async/await)

import Foundation
import SwiftUI

@Observable
@MainActor
class GameViewModel {

    // MARK: - Publicerade tillstånd (UI reagerar automatiskt på ändringar)
    var cards: [Card] = []
    var timeRemaining: Int = 20
    var moves: Int = 0
    var matchedPairs: Int = 0
    var isLocked: Bool = false     // isBusy i Android — blockerar klick under jämförelse
    var isGameOver: Bool = false   // Spelaren förlorade (timer noll)
    var isWon: Bool = false        // Spelaren vann!
    var isPaused: Bool = false     // Spelet är pausat

    // MARK: - Privat tillstånd
    private var firstFlippedIndex: Int? = nil
    private var timerTask: Task<Void, Never>? = nil
    private var timerStarted: Bool = false
    private var savedTimeOnPause: Int = 0

    // MARK: - Setup

    /// Initialiserar korten för en ny spelomgång.
    /// - Parameters:
    ///   - theme: Valt korttema (enum CardTheme)
    ///   - pairCount: Antal par (3=Easy, 6=Medium, 9=Hard)
    func setupCards(theme: CardTheme, pairCount: Int) {
        stopTimer()

        // Ta de första 'pairCount' bilderna från temat
        let selectedImages = Array(theme.themeSet.prefix(pairCount))

        // Skapa två kort av varje bild (ett par), precis som i Android
        var newCards: [Card] = []
        for (index, imageName) in selectedImages.enumerated() {
            newCards.append(Card(cardId: index, imageName: imageName))
            newCards.append(Card(cardId: index, imageName: imageName))
        }

        // Blanda korten slumpmässigt
        cards = newCards.shuffled()

        // Återställ spelläge
        timeRemaining = 20
        moves = 0
        matchedPairs = 0
        isGameOver = false
        isWon = false
        isLocked = false
        isPaused = false
        firstFlippedIndex = nil
        timerStarted = false
    }

    // MARK: - Kortlogik

    /// Vänder ett kort och kontrollerar om det bildar ett par.
    /// Precis som gamePlay()-funktionen i Android-fragmenten.
    func flipCard(at index: Int) {
        // Kontrollera att det är tillåtet att vända kortet
        guard !isLocked,
              index < cards.count,
              !cards[index].isFlipped,
              !cards[index].isMatched,
              !isGameOver,
              !isWon,
              !isPaused else { return }

        // Starta timern på första kortvändningen (precis som i Android)
        if !timerStarted {
            timerStarted = true
            startTimer()
        }

        cards[index].isFlipped = true

        if let firstIndex = firstFlippedIndex {
            // Andra kortet vändes — jämför med det första
            isLocked = true
            moves += 1

            if cards[firstIndex].cardId == cards[index].cardId {
                // Matchning! Märk båda som matchade
                cards[firstIndex].isMatched = true
                cards[index].isMatched = true
                matchedPairs += 1
                addTime(5)                   // Bonustid för matchning, som i Android
                firstFlippedIndex = nil
                isLocked = false

                // Kontrollera vinst
                if matchedPairs >= cards.count / 2 {
                    isWon = true
                    stopTimer()
                }
            } else {
                // Ingen matchning — vänd tillbaka efter 500ms (precis som Android)
                let i1 = firstIndex
                let i2 = index
                Task {
                    try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 sekunder
                    self.cards[i1].isFlipped = false
                    self.cards[i2].isFlipped = false
                    self.firstFlippedIndex = nil
                    self.isLocked = false
                }
            }
        } else {
            // Första kortet vändes
            firstFlippedIndex = index
        }
    }

    // MARK: - Timer

    /// Startar nedräkningstimern.
    /// I Android: lifecycleScope.launch + delay(1000)
    /// I iOS: Task + Task.sleep(nanoseconds:)
    func startTimer() {
        timerTask?.cancel()
        timerTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 sekund
                guard !Task.isCancelled else { break }
                guard !isPaused, !isWon else { continue }

                if timeRemaining > 0 {
                    timeRemaining -= 1
                }
                if timeRemaining <= 0 {
                    isGameOver = true
                    return
                }
            }
        }
    }

    func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }

    func addTime(_ seconds: Int) {
        timeRemaining += seconds
    }

    // MARK: - Paus

    func pauseGame() {
        guard !isPaused else { return }
        savedTimeOnPause = timeRemaining
        isPaused = true
    }

    func resumeGame() {
        guard isPaused else { return }
        isPaused = false
        timeRemaining = savedTimeOnPause
    }

    // MARK: - Återställning

    func resetGame() {
        stopTimer()
        timeRemaining = 0
        moves = 0
        matchedPairs = 0
        firstFlippedIndex = nil
        isLocked = false
        isGameOver = false
        isWon = false
        isPaused = false
        timerStarted = false
    }

    // MARK: - Hjälpfunktioner

    /// Formaterar kvarvarande tid som MM:SS (t.ex. "00:20")
    var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
