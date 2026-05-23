import XCTest
@testable import SwiftAppTemplate

final class EndpointTests: XCTestCase {
    private let baseURL = URL(string: "https://api.example.com")!

    func testGetRequestBuildsPathAndQuery() throws {
        let endpoint = Endpoint(
            path: "v1/items",
            queryItems: [URLQueryItem(name: "page", value: "2")]
        )
        let request = try XCTUnwrap(endpoint.urlRequest(baseURL: baseURL))

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url?.absoluteString, "https://api.example.com/v1/items?page=2")
    }

    func testPostRequestCarriesBodyAndHeaders() throws {
        let body = Data("{}".utf8)
        let endpoint = Endpoint(
            path: "v1/items",
            method: .post,
            headers: ["Content-Type": "application/json"],
            body: body
        )
        let request = try XCTUnwrap(endpoint.urlRequest(baseURL: baseURL))

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.httpBody, body)
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }
}
