import SwiftUI

/// The app's tabs. Add a case here and a matching screen in `MainTabView` to
/// extend the app.
enum AppTab: Int, CaseIterable, Identifiable {
    case home, explore, settings

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .home: "Home"
        case .explore: "Explore"
        case .settings: "Settings"
        }
    }

    var symbol: String {
        switch self {
        case .home: "house"
        case .explore: "square.grid.2x2"
        case .settings: "gearshape"
        }
    }
}

/// Hosts the tab content and a custom floating tab bar. The system tab bar is
/// hidden and replaced with `CustomTabBar`, reserved via `safeAreaInset` so
/// content lays out correctly above it.
struct MainTabView: View {
    @Environment(AppEnvironment.self) private var environment

    var body: some View {
        @Bindable var environment = environment

        TabView(selection: $environment.selectedTab) {
            HomeView()
                .tag(AppTab.home)
            ExploreView()
                .tag(AppTab.explore)
            SettingsView()
                .tag(AppTab.settings)
        }
        .tint(Palette.brand)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            CustomTabBar(selectedTab: $environment.selectedTab)
        }
    }
}

/// A floating, pill-shaped tab bar where the selected item expands to reveal
/// its title, animated with `matchedGeometryEffect` and a spring.
struct CustomTabBar: View {
    @Binding var selectedTab: AppTab
    @Namespace private var namespace

    var body: some View {
        HStack(spacing: 6) {
            ForEach(AppTab.allCases) { tab in
                tabButton(tab)
            }
        }
        .padding(6)
        .background(.regularMaterial, in: Capsule())
        .overlay(Capsule().strokeBorder(Color.primary.opacity(0.06)))
        .shadow(color: .black.opacity(0.12), radius: 16, y: 6)
        .padding(.horizontal, 28)
        .padding(.bottom, 4)
    }

    private func tabButton(_ tab: AppTab) -> some View {
        let isSelected = tab == selectedTab

        return Button {
            Haptics.selection()
            withAnimation(.spring(response: 0.35, dampingFraction: 0.72)) {
                selectedTab = tab
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: tab.symbol)
                    .symbolVariant(isSelected ? .fill : .none)
                    .font(.system(size: 17, weight: .semibold))
                if isSelected {
                    Text(tab.title)
                        .font(.subheadline.weight(.semibold))
                        .fixedSize()
                }
            }
            .foregroundStyle(isSelected ? Color.white : Color.secondary)
            .padding(.vertical, 12)
            .padding(.horizontal, isSelected ? 18 : 14)
            .background {
                if isSelected {
                    Capsule()
                        .fill(LinearGradient.brand)
                        .matchedGeometryEffect(id: "tabHighlight", in: namespace)
                }
            }
            .contentShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MainTabView()
        .environment(AppEnvironment())
}
