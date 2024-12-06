//
//  DecoderTypeTests.swift
//  fetch-recipeTests
//
//  Created by Caleb Meurer on 12/6/24.
//

import XCTest
@testable import fetch_recipe

class DecoderTypeTests: XCTestCase {
    func testDecoderType_JSONValueReturnsJSONDecoder() {
        let decoder = DecoderType.json.value
        XCTAssertTrue(decoder is JSONDecoder, "DecoderType.json.value should return a JSONDecoder instance.")
    }
}
