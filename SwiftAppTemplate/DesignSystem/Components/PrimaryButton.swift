import SwiftUI

/// A button style that gives any button a springy press response.
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

/// The app's primary call-to-action button: gradient fill, soft glow, haptic
/// feedback, and a spring press animation.
struct PrimaryButton: View {
    let title: String
    var systemImage: String? = nil
    var action: () -> Void

    var body: some View {
        Button {
            Haptics.impact(.medium)
            action()
        } label: {
            HStack(spacing: Theme.Spacing.sm) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient.brand,
                in: RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
            )
            .shadow(color: Palette.brand.opacity(0.45), radius: 16, y: 10)
        }
        .buttonStyle(PressableButtonStyle())
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "Continue", systemImage: "arrow.right") {}
        PrimaryButton(title: "Get Started") {}
    }
    .padding()
}
