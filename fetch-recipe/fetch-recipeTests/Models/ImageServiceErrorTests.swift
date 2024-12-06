//
//  ImageServiceErrorTests.swift
//  fetch-recipeTests
//
//  Created by Caleb Meurer on 12/6/24.
//

import XCTest
@testable import fetch_recipe

class ImageServiceErrorTests: XCTestCase {
    func testImageServiceErrorEquatability() {
        XCTAssertEqual(ImageServiceError.invalidURL, .invalidURL)
        XCTAssertEqual(ImageServiceError.loadingImage("msg"), .loadingImage("msg"))
        XCTAssertNotEqual(ImageServiceError.loadingImage("one"), .loadingImage("two"))
        XCTAssertEqual(ImageServiceError.unknown("x"), .unknown("x"))
    }

    func testImageServiceErrorLocalizedDescription() {
        XCTAssertTrue(ImageServiceError.invalidURL.localizedDescription.contains("Invalid URL"))
        let loadingError = ImageServiceError.loadingImage("SomeError")
        XCTAssertTrue(loadingError.localizedDescription.contains("Error loading image"))
        let unknownError = ImageServiceError.unknown("Mystery")
        XCTAssertTrue(unknownError.localizedDescription.contains("Unknown image service error"))
    }
}
