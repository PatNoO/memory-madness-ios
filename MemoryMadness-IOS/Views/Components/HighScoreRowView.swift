// HighScoreRowView.swift
// En rad i highscore-listan.
// Motsvarar list_high_score_item.xml + HighScoreRecyclerAdapter i Android.
// I Android: RecyclerView med ViewHolder-pattern.
// I iOS: SwiftUI View som används direkt i List { ForEach }.

import SwiftUI

struct HighScoreRowView: View {
    let player: Player
    let rank: Int       // Placeringsnummer (1, 2, 3, ...)

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("#\(rank) \(player.name)")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
                Text(player.difficulty)
                    .font(.system(size: 16))
                    .foregroundColor(.appRed)
            }

            HStack {
                Label("Tid kvar: \(formattedTime)", systemImage: "clock")
                    .font(.system(size: 16))
                Spacer()
                Label("\(player.moves) drag", systemImage: "hand.tap")
                    .font(.system(size: 16))
            }

            HStack {
                Text(player.pauseEnabled ? "Paus: På" : "Paus: Av")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                Spacer()
                Text(player.theme)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.appRed, lineWidth: 1.5)
        )
    }

    // Formaterar sekunder till MM:SS-format
    private var formattedTime: String {
        let minutes = player.timeRemaining / 60
        let seconds = player.timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
