import SwiftUI

/// Settings backed by `@AppStorage`. Changing the appearance updates the whole
/// app live; "Reset Onboarding" returns to the welcome flow.
struct SettingsView: View {
    @AppStorage("appearance") private var appearance: ColorSchemePreference = .system
    @AppStorage("hapticsEnabled") private var hapticsEnabled = true
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true

    var body: some View {
        NavigationStack {
            Form {
                appearanceSection
                preferencesSection
                aboutSection

                Section {
                    Button(role: .destructive) {
                        Haptics.notify(.warning)
                        withAnimation(.smooth) { hasCompletedOnboarding = false }
                    } label: {
                        Label("Reset Onboarding", systemImage: "arrow.counterclockwise")
                    }
                }
            }
            .navigationTitle("Settings")
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .toolbar(.hidden, for: .tabBar)
        }
    }

    private var appearanceSection: some View {
        Section("Appearance") {
            Picker(selection: $appearance) {
                ForEach(ColorSchemePreference.allCases) { preference in
                    Label(preference.label, systemImage: preference.symbol)
                        .tag(preference)
                }
            } label: {
                Label("Theme", systemImage: "paintpalette")
            }
            .pickerStyle(.menu)
        }
    }

    private var preferencesSection: some View {
        Section("Preferences") {
            Toggle(isOn: $hapticsEnabled) {
                Label("Haptics", systemImage: "hand.tap")
            }
            Toggle(isOn: $notificationsEnabled) {
                Label("Notifications", systemImage: "bell.badge")
            }
        }
        .tint(Palette.brand)
        .sensoryFeedback(.selection, trigger: hapticsEnabled)
        .sensoryFeedback(.selection, trigger: notificationsEnabled)
    }

    private var aboutSection: some View {
        Section("About") {
            LabeledContent("Version", value: "1.0.0")
            LabeledContent("Build", value: "1")
            Link(destination: URL(string: "https://developer.apple.com/documentation/swiftui")!) {
                Label("SwiftUI Documentation", systemImage: "book")
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(AppEnvironment())
}
