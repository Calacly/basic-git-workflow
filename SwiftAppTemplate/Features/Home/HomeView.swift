import SwiftUI

/// The primary screen: a greeting header, an animated featured card, and a
/// feed that loads with a skeleton state and animates its rows in on scroll.
struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var headerAppear = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                    header
                    FeaturedCard()
                    sectionHeader("For You")
                    feed
                }
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.top, Theme.Spacing.sm)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationDestination(for: FeedItem.self) { item in
                DetailView(item: item)
            }
            .refreshable { await viewModel.refresh() }
            .task { await viewModel.load() }
            .toolbar(.hidden, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
        }
    }

    private var greeting: String {
        switch Calendar.current.component(.hour, from: .now) {
        case 5..<12: "Good morning"
        case 12..<17: "Good afternoon"
        case 17..<22: "Good evening"
        default: "Hello"
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(greeting)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("SwiftAppTemplate")
                    .font(.largeTitle.bold())
            }
            Spacer()
            Circle()
                .fill(LinearGradient.brand)
                .frame(width: 44, height: 44)
                .overlay(Image(systemName: "person.fill").foregroundStyle(.white))
                .shadow(color: Palette.brand.opacity(0.4), radius: 8, y: 4)
        }
        .padding(.top, Theme.Spacing.sm)
        .opacity(headerAppear ? 1 : 0)
        .offset(y: headerAppear ? 0 : -12)
        .onAppear {
            withAnimation(.smooth(duration: 0.5)) { headerAppear = true }
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title).font(.title3.bold())
            Spacer()
            Text("See all")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Palette.brand)
        }
    }

    @ViewBuilder
    private var feed: some View {
        switch viewModel.state {
        case .loading:
            VStack(spacing: Theme.Spacing.md) {
                ForEach(0..<4, id: \.self) { _ in
                    SkeletonRow()
                }
            }
            .transition(.opacity)
        case .loaded:
            LazyVStack(spacing: Theme.Spacing.md) {
                ForEach(viewModel.items) { item in
                    NavigationLink(value: item) {
                        FeedCard(item: item)
                    }
                    .buttonStyle(PressableButtonStyle())
                    .scrollTransition { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1 : 0)
                            .offset(y: phase.isIdentity ? 0 : 28)
                            .scaleEffect(phase.isIdentity ? 1 : 0.96)
                    }
                }
            }
        }
    }
}

/// A large gradient hero card with a slowly shifting gradient and a decorative
/// symbol.
private struct FeaturedCard: View {
    @State private var animate = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Palette.brand, Palette.brandSecondary, Palette.accentPink],
                        startPoint: animate ? .topLeading : .leading,
                        endPoint: animate ? .bottomTrailing : .trailing
                    )
                )

            Image(systemName: "sparkles")
                .font(.system(size: 120))
                .foregroundStyle(.white.opacity(0.16))
                .offset(x: 30, y: -20)

            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                Spacer()
                TagPill(text: "Featured", systemImage: "sparkles", tint: .white)
                Text("Build Something Delightful")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                Text("Start from a polished base with a design system and smooth animations baked in.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
            }
            .padding(Theme.Spacing.lg)
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous))
        .shadow(color: Palette.brand.opacity(0.4), radius: 24, y: 14)
        .onAppear {
            withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

/// A single feed row card.
struct FeedCard: View {
    let item: FeedItem

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            Image(systemName: item.symbol)
                .font(.title2.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 52, height: 52)
                .background(item.tint.gradient, in: RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous))

            VStack(alignment: .leading, spacing: 3) {
                Text(item.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(item.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.bold))
                .foregroundStyle(.tertiary)
        }
        .padding(Theme.Spacing.md)
        .background(
            Color(.secondarySystemGroupedBackground),
            in: RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
        )
        .shadow(color: .black.opacity(0.05), radius: 10, y: 6)
    }
}

/// A skeleton placeholder row shown while content loads.
private struct SkeletonRow: View {
    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            SkeletonBlock(cornerRadius: Theme.Radius.md)
                .frame(width: 52, height: 52)
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                SkeletonBlock()
                    .frame(maxWidth: .infinity)
                    .frame(height: 14)
                SkeletonBlock()
                    .frame(width: 150, height: 12)
            }
        }
        .padding(Theme.Spacing.md)
        .background(
            Color(.secondarySystemGroupedBackground),
            in: RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
        )
    }
}

#Preview {
    HomeView()
        .environment(AppEnvironment())
}
