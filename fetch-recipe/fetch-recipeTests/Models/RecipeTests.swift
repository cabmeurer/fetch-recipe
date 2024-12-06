//
//  RecipeTests.swift
//  fetch-recipeTests
//
//  Created by Caleb Meurer on 12/6/24.
//

import XCTest
@testable import fetch_recipe

class RecipeTests: XCTestCase {
    func testRecipeDecoding() throws {
        let json = """
        {
            "uuid": "123e4567-e89b-12d3-a456-426614174000",
            "cuisine": "Italian",
            "name": "Pasta",
            "photo_url_large": null,
            "photo_url_small": "https://example.com/small.jpg",
            "source_url": "https://example.com/",
            "youtube_url": "https://youtube.com/video"
        }
        """
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let recipe = try decoder.decode(Recipe.self, from: data)

        XCTAssertEqual(recipe.uuid, UUID(uuidString: "123e4567-e89b-12d3-a456-426614174000")!)
        XCTAssertEqual(recipe.cuisine, "Italian")
        XCTAssertEqual(recipe.name, "Pasta")
        XCTAssertNil(recipe.photoURLLarge)
        XCTAssertEqual(recipe.photoURLSmall, URL(string: "https://example.com/small.jpg"))
        XCTAssertEqual(recipe.sourceURL, URL(string: "https://example.com/"))
        XCTAssertEqual(recipe.youtubeURL, URL(string: "https://youtube.com/video"))
    }

    func testRecipeEquatability() {
        let uuid = UUID()
        let recipe1 = Recipe(
            uuid: uuid,
            cuisine: "Italian",
            name: "Pasta",
            photoURLLarge: nil,
            photoURLSmall: nil,
            sourceURL: nil,
            youtubeURL: nil
        )

        let recipe2 = Recipe(
            uuid: uuid,
            cuisine: "Italian",
            name: "Pasta",
            photoURLLarge: nil,
            photoURLSmall: nil,
            sourceURL: nil,
            youtubeURL: nil
        )

        XCTAssertEqual(recipe1, recipe2, "Two recipes with the same properties should be equal.")
    }
}
