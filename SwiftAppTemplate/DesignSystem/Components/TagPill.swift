import SwiftUI

/// A small rounded label, optionally with a leading SF Symbol.
struct TagPill: View {
    let text: String
    var systemImage: String? = nil
    var tint: Color = Palette.brand

    var body: some View {
        HStack(spacing: 4) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.caption2.weight(.bold))
            }
            Text(text)
                .font(.caption.weight(.semibold))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .foregroundStyle(tint)
        .background(tint.opacity(0.15), in: Capsule())
    }
}

#Preview {
    HStack {
        TagPill(text: "Featured", systemImage: "sparkles")
        TagPill(text: "New", tint: Palette.accentTeal)
        TagPill(text: "Pro", systemImage: "crown.fill", tint: Palette.accentAmber)
    }
    .padding()
}
