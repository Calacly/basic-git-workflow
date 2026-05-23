import SwiftUI

/// A detail screen with an animated header symbol and content that eases in.
struct DetailView: View {
    let item: FeedItem
    @State private var appear = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                header

                TagPill(text: "Overview", systemImage: "doc.text", tint: item.tint)

                Text(item.subtitle)
                    .font(.title3.weight(.semibold))

                Text(item.detail)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .lineSpacing(4)

                PrimaryButton(title: "Get Started", systemImage: "arrow.right") {}
                    .padding(.top, Theme.Spacing.sm)
            }
            .padding(Theme.Spacing.lg)
            .opacity(appear ? 1 : 0)
            .offset(y: appear ? 0 : 24)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75).delay(0.05)) {
                appear = true
            }
        }
    }

    private var header: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                .fill(item.tint.gradient)
            Image(systemName: item.symbol)
                .font(.system(size: 72, weight: .bold))
                .foregroundStyle(.white)
                .scaleEffect(appear ? 1 : 0.4)
                .rotationEffect(.degrees(appear ? 0 : -18))
                .symbolEffect(.bounce, value: appear)
        }
        .frame(height: 220)
        .frame(maxWidth: .infinity)
        .shadow(color: item.tint.opacity(0.4), radius: 20, y: 12)
    }
}

#Preview {
    NavigationStack {
        DetailView(item: FeedItem.samples[0])
    }
}
