//
//  RecipeResponseTests.swift
//  fetch-recipeTests
//
//  Created by Caleb Meurer on 12/6/24.
//

import XCTest
@testable import fetch_recipe

class RecipeResponseTests: XCTestCase {
    func testRecipeResponseDecoding() throws {
        let json = """
        {
            "recipes": [
                {
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "cuisine": "Italian",
                    "name": "Pasta",
                    "photo_url_large": null,
                    "photo_url_small": "https://example.com/small.jpg",
                    "source_url": "https://example.com/",
                    "youtube_url": "https://youtube.com/video"
                }
            ]
        }
        """
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let response = try decoder.decode(RecipeResponse.self, from: data)

        XCTAssertEqual(response.recipes.count, 1, "Should have one recipe in the response.")
        let recipe = response.recipes.first!
        XCTAssertEqual(recipe.uuid, UUID(uuidString: "123e4567-e89b-12d3-a456-426614174000")!)
        XCTAssertEqual(recipe.cuisine, "Italian")
        XCTAssertEqual(recipe.name, "Pasta")
        XCTAssertNil(recipe.photoURLLarge)
        XCTAssertEqual(recipe.photoURLSmall, URL(string: "https://example.com/small.jpg"))
        XCTAssertEqual(recipe.sourceURL, URL(string: "https://example.com/"))
        XCTAssertEqual(recipe.youtubeURL, URL(string: "https://youtube.com/video"))
    }
}
