import SwiftUI

/// A looping shimmer highlight, masked to the content's shape. Great for
/// skeleton loading states.
struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy in
                    let width = proxy.size.width
                    LinearGradient(
                        colors: [.clear, Color.white.opacity(0.6), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: width)
                    .offset(x: -width + (2 * width) * phase)
                }
            )
            .mask(content)
            .onAppear {
                withAnimation(.linear(duration: 1.4).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    /// Adds a looping shimmer highlight. Best used on solid placeholder shapes.
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}

/// A shimmering placeholder block for skeleton screens.
struct SkeletonBlock: View {
    var cornerRadius: CGFloat = Theme.Radius.sm

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(Color.primary.opacity(0.12))
            .shimmer()
    }
}

#Preview {
    VStack(spacing: 12) {
        SkeletonBlock().frame(height: 20)
        SkeletonBlock().frame(width: 180, height: 16)
        SkeletonBlock(cornerRadius: 26).frame(width: 52, height: 52)
    }
    .padding()
}
