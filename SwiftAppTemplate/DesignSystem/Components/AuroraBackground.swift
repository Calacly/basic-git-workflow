import SwiftUI

/// A saturated, slowly drifting gradient background built from blurred color
/// "blobs". Designed for full-bleed, high-contrast screens like onboarding.
struct AuroraBackground: View {
    var palette: [Color] = [Palette.brand, Palette.brandSecondary, Palette.accentPink]

    @State private var animate = false

    private let blobs: [CGSize] = [
        CGSize(width: -140, height: -240),
        CGSize(width: 150, height: -150),
        CGSize(width: -110, height: 240),
        CGSize(width: 150, height: 260)
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [palette.first ?? Palette.brand, Palette.brandSecondary],
                startPoint: .top,
                endPoint: .bottom
            )

            ForEach(blobs.indices, id: \.self) { index in
                Circle()
                    .fill(palette[index % palette.count])
                    .frame(width: 300, height: 300)
                    .offset(
                        x: blobs[index].width,
                        y: animate ? blobs[index].height : blobs[index].height * 0.65
                    )
                    .opacity(0.55)
            }
        }
        .blur(radius: 80)
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 7).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

#Preview {
    AuroraBackground()
}
