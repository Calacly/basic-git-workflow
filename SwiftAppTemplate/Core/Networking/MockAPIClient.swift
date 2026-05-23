import Foundation

/// In-memory `APIClient` for previews and unit tests. Provide a handler that
/// returns a stub for a given endpoint (or throws to exercise error states).
struct MockAPIClient: APIClient {
    /// Returns a value that will be cast to the requested `Decodable` type.
    var handler: @Sendable (Endpoint) async throws -> Any = { _ in
        throw AppError.unknown
    }
    /// Simulated latency so loading states are visible in previews.
    var delay: Duration = .milliseconds(350)

    func send<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T {
        if delay > .zero {
            try? await Task.sleep(for: delay)
        }
        let value = try await handler(endpoint)
        guard let typed = value as? T else {
            throw AppError.decoding
        }
        return typed
    }
}
