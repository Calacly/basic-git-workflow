import UIKit

/// Lightweight wrapper around UIKit feedback generators. Respects the
/// "Haptics" preference toggled in Settings.
enum Haptics {
    private static var isEnabled: Bool {
        UserDefaults.standard.object(forKey: "hapticsEnabled") as? Bool ?? true
    }

    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        guard isEnabled else { return }
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }

    static func selection() {
        guard isEnabled else { return }
        UISelectionFeedbackGenerator().selectionChanged()
    }

    static func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard isEnabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
}
