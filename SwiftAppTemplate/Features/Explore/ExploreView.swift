import SwiftUI

/// A two-column grid of cards. Each tile animates in with a scroll transition
/// and pushes the same `DetailView` used by Home.
struct ExploreView: View {
    private let items = FeedItem.samples
    private let columns = [
        GridItem(.flexible(), spacing: Theme.Spacing.md),
        GridItem(.flexible(), spacing: Theme.Spacing.md)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: Theme.Spacing.md) {
                    ForEach(items) { item in
                        NavigationLink(value: item) {
                            ExploreCard(item: item)
                        }
                        .buttonStyle(PressableButtonStyle())
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0)
                                .scaleEffect(phase.isIdentity ? 1 : 0.85)
                                .blur(radius: phase.isIdentity ? 0 : 6)
                        }
                    }
                }
                .padding(Theme.Spacing.lg)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Explore")
            .navigationDestination(for: FeedItem.self) { item in
                DetailView(item: item)
            }
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

private struct ExploreCard: View {
    let item: FeedItem

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            ZStack {
                RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous)
                    .fill(item.tint.gradient)
                Image(systemName: item.symbol)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(height: 110)
            .shadow(color: item.tint.opacity(0.35), radius: 10, y: 6)

            Text(item.title)
                .font(.headline)
                .foregroundStyle(.primary)
                .lineLimit(1)
            Text(item.subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(Theme.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Color(.secondarySystemGroupedBackground),
            in: RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
        )
        .shadow(color: .black.opacity(0.05), radius: 10, y: 6)
    }
}

#Preview {
    ExploreView()
        .environment(AppEnvironment())
}
