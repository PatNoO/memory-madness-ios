// ColorExtension.swift
// Lägger till stöd för att skapa färger från hex-koder (t.ex. "#AC0000").
// I Android definieras färger i colors.xml — i SwiftUI gör vi det här.

import SwiftUI

extension Color {
    /// Skapar en Color från en hex-sträng, t.ex. "#AC0000" eller "AC0000"
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Appens färger (motsvarar colors.xml i Android)
extension Color {
    static let appRed = Color(hex: "#AC0000")          // primary_red
    static let appGray = Color(hex: "#D0D5DD")         // backround_greyis
    static let cardBackground = Color(hex: "#F2F4F7")  // kortets baksida
    static let cardStroke = Color(hex: "#CCCCCC")      // kortets kantlinje
}
