import XCTest
@testable import SwiftAppTemplate

final class AppErrorTests: XCTestCase {
    func testEveryCaseProvidesUserFacingCopy() {
        let cases: [AppError] = [
            .network(""), .decoding, .unauthorized, .notFound, .server(500), .unknown
        ]
        for error in cases {
            XCTAssertFalse(error.errorDescription?.isEmpty ?? true,
                           "\(error) should have a non-empty description")
        }
    }

    func testServerErrorIncludesStatusCode() {
        XCTAssertEqual(AppError.server(503).errorDescription, "The server ran into a problem (503).")
    }

    func testNetworkErrorUsesProvidedMessage() {
        XCTAssertEqual(AppError.network("Offline").errorDescription, "Offline")
    }
}
