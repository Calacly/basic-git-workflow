import Foundation

/// Unified, user-presentable error type. Map lower-level errors (URLSession,
/// decoding, etc.) into these cases so views only ever show readable copy.
enum AppError: LocalizedError, Equatable {
    case network(String)
    case decoding
    case unauthorized
    case notFound
    case server(Int)
    case unknown

    var errorDescription: String? {
        switch self {
        case .network(let message):
            return message.isEmpty ? "A network error occurred." : message
        case .decoding:
            return "We couldn't read the server response."
        case .unauthorized:
            return "Your session has expired. Please sign in again."
        case .notFound:
            return "We couldn't find what you were looking for."
        case .server(let code):
            return "The server ran into a problem (\(code))."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}
