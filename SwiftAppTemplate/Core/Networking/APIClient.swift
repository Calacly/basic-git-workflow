import Foundation

/// Network seam. Features depend on this protocol, never on `URLSession`
/// directly, so they can be driven by `MockAPIClient` in previews and tests.
protocol APIClient: Sendable {
    func send<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T
}

extension APIClient {
    /// Convenience for call sites that can infer the return type.
    func send<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        try await send(endpoint, as: T.self)
    }
}

/// Production `APIClient` backed by `URLSession`, mapping transport and status
/// failures into `AppError`.
struct LiveAPIClient: APIClient {
    var baseURL: URL
    var session: URLSession = .shared

    func send<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T {
        guard let request = endpoint.urlRequest(baseURL: baseURL) else {
            throw AppError.network("Invalid request URL.")
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            AppLog.network.error("Request failed: \(error.localizedDescription, privacy: .public)")
            throw AppError.network(error.localizedDescription)
        }

        guard let http = response as? HTTPURLResponse else {
            throw AppError.unknown
        }

        switch http.statusCode {
        case 200..<300:
            do {
                return try Self.decoder.decode(T.self, from: data)
            } catch {
                AppLog.network.error("Decoding failed: \(String(describing: error), privacy: .public)")
                throw AppError.decoding
            }
        case 401:
            throw AppError.unauthorized
        case 404:
            throw AppError.notFound
        default:
            throw AppError.server(http.statusCode)
        }
    }

    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}
