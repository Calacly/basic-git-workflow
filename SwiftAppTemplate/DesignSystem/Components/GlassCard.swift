import SwiftUI

/// A frosted, rounded container with a hairline border and soft shadow.
/// Wrap any content to give it a consistent card treatment.
struct GlassCard<Content: View>: View {
    var cornerRadius: CGFloat = Theme.Radius.lg
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(Theme.Spacing.lg)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.15))
            )
            .shadow(color: .black.opacity(0.12), radius: 18, y: 10)
    }
}

#Preview {
    ZStack {
        AuroraBackground()
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("Glass Card").font(.headline)
                Text("A reusable frosted container.").foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}
