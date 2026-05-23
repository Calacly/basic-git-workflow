import XCTest
@testable import SwiftAppTemplate

final class MockAPIClientTests: XCTestCase {
    func testReturnsStubbedValue() async throws {
        let client = MockAPIClient(handler: { _ in ["a", "b"] }, delay: .zero)
        let result = try await client.send(Endpoint(path: "items"), as: [String].self)
        XCTAssertEqual(result, ["a", "b"])
    }

    func testThrowsWhenStubTypeMismatches() async {
        let client = MockAPIClient(handler: { _ in 42 }, delay: .zero)
        do {
            _ = try await client.send(Endpoint(path: "items"), as: [String].self)
            XCTFail("Expected a decoding error")
        } catch {
            XCTAssertEqual(error as? AppError, .decoding)
        }
    }

    func testPropagatesThrownError() async {
        let client = MockAPIClient(handler: { _ in throw AppError.unauthorized }, delay: .zero)
        do {
            _ = try await client.send(Endpoint(path: "items"), as: [String].self)
            XCTFail("Expected the handler error to propagate")
        } catch {
            XCTAssertEqual(error as? AppError, .unauthorized)
        }
    }
}
