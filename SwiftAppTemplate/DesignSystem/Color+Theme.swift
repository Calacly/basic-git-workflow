import SwiftUI

/// Brand palette. These are fixed brand hues; pair them with system colors
/// (e.g. `Color(.systemGroupedBackground)`) for surfaces so the app adapts to
/// light and dark mode automatically.
enum Palette {
    static let brand = Color(hex: 0x6466F1)          // indigo
    static let brandSecondary = Color(hex: 0xA855F7) // violet
    static let accentPink = Color(hex: 0xEC4899)
    static let accentTeal = Color(hex: 0x14B8A6)
    static let accentAmber = Color(hex: 0xF59E0B)
    static let accentBlue = Color(hex: 0x3B82F6)
}

extension LinearGradient {
    /// The primary brand gradient used for buttons, highlights and accents.
    static let brand = LinearGradient(
        colors: [Palette.brand, Palette.brandSecondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Color {
    /// Create a color from a 24-bit hex value, e.g. `Color(hex: 0x6466F1)`.
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}
