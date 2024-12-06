//
//  NetworkErrorTests.swift
//  fetch-recipeTests
//
//  Created by Caleb Meurer on 12/6/24.
//

import XCTest
@testable import fetch_recipe

class NetworkErrorTests: XCTestCase {
    func testNetworkErrorEquatability() {
        XCTAssertEqual(NetworkError.invalidURL, .invalidURL)
        XCTAssertEqual(NetworkError.request("msg"), .request("msg"))
        XCTAssertNotEqual(NetworkError.request("one"), .request("two"))
        XCTAssertEqual(NetworkError.server("500"), .server("500"))
        XCTAssertEqual(NetworkError.malformed("data"), .malformed("data"))
        XCTAssertEqual(NetworkError.empty("none"), .empty("none"))
    }

    func testNetworkErrorLocalizedDescription() {
        XCTAssertTrue(NetworkError.invalidURL.localizedDescription.contains("Invalid URL"))
        XCTAssertTrue(NetworkError.request("Timeout").localizedDescription.contains("Request error"))
        XCTAssertTrue(NetworkError.server("500").localizedDescription.contains("Error response from server"))
        XCTAssertTrue(NetworkError.malformed("Bad Data").localizedDescription.contains("Malformed response from server"))
        XCTAssertTrue(NetworkError.empty("No data").localizedDescription.contains("Empty response from server"))
    }
}
