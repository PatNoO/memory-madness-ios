// Card.swift
// Motsvarar CardManager.kt i Android-projektet.
// Representerar ett enskilt kort i spelet.

import Foundation

struct Card: Identifiable {
    // Identifiable krävs för att SwiftUI ska kunna skilja på korten i en lista
    let id = UUID()

    var isFlipped: Bool = false   // Är kortet uppvänt (visar framsidan)?
    var isMatched: Bool = false   // Är kortet ihopparrat och klart?

    let cardId: Int               // Unikt ID för kortparet (t.ex. 0 = card1, 1 = card2)
    let imageName: String         // Filnamnet på bilden, t.ex. "card1", "easter3"
}
