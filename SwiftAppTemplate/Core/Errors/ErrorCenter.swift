import SwiftUI

/// Observable holder for the most recent user-facing error. Injected at the
/// root; call `present(_:)` from anywhere and surface it with `.errorAlert`.
@Observable
final class ErrorCenter {
    var current: AppError?
    var isPresented = false

    func present(_ error: Error) {
        current = (error as? AppError) ?? .unknown
        isPresented = true
        AppLog.app.error("Presented error: \(self.current?.localizedDescription ?? "unknown", privacy: .public)")
    }
}

private struct ErrorAlertModifier: ViewModifier {
    @Bindable var center: ErrorCenter

    func body(content: Content) -> some View {
        content.alert(
            "Something went wrong",
            isPresented: $center.isPresented,
            presenting: center.current
        ) { _ in
            Button("OK", role: .cancel) {}
        } message: { error in
            Text(error.errorDescription ?? "Please try again.")
        }
    }
}

extension View {
    /// Attaches a global alert that shows whatever the `ErrorCenter` presents.
    /// Apply once, near the root of the view tree.
    func errorAlert(_ center: ErrorCenter) -> some View {
        modifier(ErrorAlertModifier(center: center))
    }
}
