import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let symbol: String
    let title: String
    let description: String
    let tint: Color
}

extension OnboardingPage {
    static let pages: [OnboardingPage] = [
        OnboardingPage(
            symbol: "wand.and.stars",
            title: "Welcome",
            description: "A polished SwiftUI starting point you can clone and make your own in minutes.",
            tint: Palette.brand
        ),
        OnboardingPage(
            symbol: "paintbrush.pointed.fill",
            title: "Beautiful by Default",
            description: "A ready-made design system of colors, components, and spacing keeps everything consistent.",
            tint: Palette.accentPink
        ),
        OnboardingPage(
            symbol: "bolt.fill",
            title: "Smooth & Fluid",
            description: "Spring animations, haptics, and tasteful transitions give every interaction a premium feel.",
            tint: Palette.accentTeal
        )
    ]
}

/// A paged welcome flow with an animated background, springy page content,
/// and a custom animated page indicator.
struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var index = 0

    private let pages = OnboardingPage.pages

    private var isLastPage: Bool { index == pages.count - 1 }

    var body: some View {
        ZStack {
            AuroraBackground(palette: [pages[index].tint, Palette.brandSecondary, Palette.brand])
                .animation(.smooth(duration: 0.6), value: index)

            VStack(spacing: 0) {
                skipButton

                TabView(selection: $index) {
                    ForEach(Array(pages.enumerated()), id: \.element.id) { offset, page in
                        OnboardingPageView(page: page)
                            .tag(offset)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                pageIndicator

                PrimaryButton(
                    title: isLastPage ? "Get Started" : "Continue",
                    systemImage: isLastPage ? "checkmark" : "arrow.right"
                ) {
                    advance()
                }
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.lg)
        }
    }

    private var skipButton: some View {
        HStack {
            Spacer()
            Button("Skip") {
                complete()
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.white.opacity(0.9))
            .opacity(isLastPage ? 0 : 1)
            .animation(.smooth, value: isLastPage)
        }
        .padding(.top, Theme.Spacing.sm)
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(pages.indices, id: \.self) { i in
                Capsule()
                    .fill(.white.opacity(i == index ? 1 : 0.4))
                    .frame(width: i == index ? 26 : 8, height: 8)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: index)
        .padding(.vertical, Theme.Spacing.lg)
    }

    private func advance() {
        if isLastPage {
            complete()
        } else {
            withAnimation(.smooth) { index += 1 }
        }
    }

    private func complete() {
        Haptics.notify(.success)
        withAnimation(.smooth) { hasCompletedOnboarding = true }
    }
}

/// A single onboarding page with a springy entrance and an animated symbol.
private struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var appear = false

    var body: some View {
        VStack(spacing: Theme.Spacing.xl) {
            Spacer()

            Image(systemName: page.symbol)
                .font(.system(size: 88, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 180, height: 180)
                .background(.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 44, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 44, style: .continuous)
                        .strokeBorder(.white.opacity(0.25))
                )
                .shadow(color: .black.opacity(0.2), radius: 30, y: 16)
                .scaleEffect(appear ? 1 : 0.6)
                .opacity(appear ? 1 : 0)
                .symbolEffect(.bounce, value: appear)

            VStack(spacing: Theme.Spacing.sm) {
                Text(page.title)
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                Text(page.description)
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.Spacing.sm)
            }
            .opacity(appear ? 1 : 0)
            .offset(y: appear ? 0 : 24)

            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                appear = true
            }
        }
    }
}

#Preview {
    OnboardingView()
}
