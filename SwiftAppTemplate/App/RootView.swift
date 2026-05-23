import SwiftUI

/// Top-level view that decides between onboarding and the main app, and
/// applies the user's chosen appearance. Switching between the two is
/// animated for a polished first-launch experience.
struct RootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("appearance") private var appearance: ColorSchemePreference = .system

    var body: some View {
        ZStack {
            if hasCompletedOnboarding {
                MainTabView()
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.98)),
                        removal: .opacity
                    ))
            } else {
                OnboardingView()
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .animation(.smooth(duration: 0.5), value: hasCompletedOnboarding)
        .preferredColorScheme(appearance.colorScheme)
    }
}

#Preview {
    RootView()
        .environment(AppEnvironment())
}
