import SwiftUI

/// A sample content model. Replace with your own domain type — the views only
/// rely on `title`, `subtitle`, `symbol`, `tint`, and `detail`.
struct FeedItem: Identifiable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let symbol: String
    let tint: Color
    let detail: String

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        symbol: String,
        tint: Color,
        detail: String
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.symbol = symbol
        self.tint = tint
        self.detail = detail
    }

    static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension FeedItem {
    static let samples: [FeedItem] = [
        FeedItem(
            title: "Design System",
            subtitle: "Reusable colors, spacing, and components.",
            symbol: "paintpalette.fill",
            tint: Palette.brand,
            detail: "A small set of design tokens and view components keep the UI consistent. Adjust the palette and spacing in one place and the whole app follows."
        ),
        FeedItem(
            title: "Fluid Animations",
            subtitle: "Springs, transitions, and matched geometry.",
            symbol: "bolt.fill",
            tint: Palette.accentTeal,
            detail: "Interactions use spring animations and scroll transitions so everything feels alive without being distracting."
        ),
        FeedItem(
            title: "Haptic Feedback",
            subtitle: "Tactile responses on key interactions.",
            symbol: "hand.tap.fill",
            tint: Palette.accentPink,
            detail: "Buttons and selections trigger subtle haptics. The whole system can be toggled off from Settings."
        ),
        FeedItem(
            title: "Adaptive Layout",
            subtitle: "Looks great in light and dark mode.",
            symbol: "circle.lefthalf.filled",
            tint: Palette.accentAmber,
            detail: "Surfaces use system colors so the app adapts automatically, while brand accents stay vivid in both appearances."
        ),
        FeedItem(
            title: "Modular Structure",
            subtitle: "Feature folders that scale with your app.",
            symbol: "square.stack.3d.up.fill",
            tint: Palette.accentBlue,
            detail: "Each feature lives in its own folder with its views and view models, making it easy to grow the codebase cleanly."
        )
    ]
}
