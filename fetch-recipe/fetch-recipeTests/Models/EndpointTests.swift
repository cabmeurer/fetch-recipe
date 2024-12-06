//
//  EndpointTests.swift
//  fetch-recipeTests
//
//  Created by Caleb Meurer on 12/6/24.
//

import XCTest
@testable import fetch_recipe

class EndpointTests: XCTestCase {
    func testEndpointNameAndRawValue() {
        XCTAssertEqual(Endpoint.valid.name, "Valid")
        XCTAssertEqual(Endpoint.valid.rawValue, "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
        
        XCTAssertEqual(Endpoint.invalid.name, "Invalid")
        XCTAssertEqual(Endpoint.invalid.rawValue, "https://d3jbb8n5wk0qxi.cloudfront.net/\n")
        
        XCTAssertEqual(Endpoint.malformed.name, "Malformed")
        XCTAssertEqual(Endpoint.malformed.rawValue, "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
        
        XCTAssertEqual(Endpoint.empty.name, "Empty")
        XCTAssertEqual(Endpoint.empty.rawValue, "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")
    }
}
