// CardTileView.swift
// Återanvändbar komponent för ett enskilt spelkort.
// I Android hanterades detta av ImageView + tag i GridLayout.
// I SwiftUI skapar vi en separat View för varje kort.

import SwiftUI

struct CardTileView: View {
    let card: Card

    // Är kortet synligt (vänt upp eller matchat)?
    private var isRevealed: Bool {
        card.isFlipped || card.isMatched
    }

    var body: some View {
        ZStack {
            if isRevealed {
                // Framsidan — kortets bild fyller hela kortets yta
                // .frame(maxWidth/maxHeight: .infinity) är avgörande: det begränsar bildens
                // layout-storlek till kortets storlek, annars expanderar ZStack och
                // clipShape klippar fel storlek → bilden flödar in i grannkort.
                Image(card.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(card.isMatched ? 0.5 : 1.0)
            } else {
                // Baksidan — grå rektangel (card_backround.xml i Android)
                Color.cardBackground
            }
        }
        // clipShape på ZStack förhindrar att bilden flödar utanför kortets gränser
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.cardStroke, lineWidth: 2)
        )
        // Enkel animation när kortet vänds
        .animation(.easeInOut(duration: 0.2), value: isRevealed)
        .animation(.easeInOut(duration: 0.2), value: card.isMatched)
    }
}
