//
//  RecipeListViewModelTests.swift
//  fetch-recipeTests
//
//  Created by Caleb Meurer on 12/6/24.
//

import XCTest
@testable import fetch_recipe

@MainActor
class RecipeListViewModelTests: XCTestCase {
    
    var mockRecipeService: MockRecipeService!
    var recipeListViewModel: RecipeListViewModel!
    
    override func setUp() async throws {
        try await super.setUp()
        mockRecipeService = MockRecipeService()
        recipeListViewModel = RecipeListViewModel(mockRecipeService)
    }
    
    override func tearDown() {
        super.tearDown()
        mockRecipeService = nil
        recipeListViewModel = nil
    }
    
    func testLoadRecipes_Success() async {
        XCTAssertNotNil(recipeListViewModel)
        XCTAssertNotNil(mockRecipeService)
        let sampleRecipe = Recipe(
            uuid: UUID(),
            cuisine: "Italian",
            name: "Pasta",
            photoURLLarge: nil,
            photoURLSmall: nil,
            sourceURL: nil,
            youtubeURL: nil
        )
        mockRecipeService.fetchRecipesResult = .success([sampleRecipe])
        await recipeListViewModel.loadRecipes(.valid)
        
        XCTAssertFalse(recipeListViewModel.isLoading, "isLoading should be false after loading")
        XCTAssertNil(recipeListViewModel.errorMessage, "errorMessage should be nil on success")
        XCTAssertEqual(recipeListViewModel.recipes.count, 1, "Should have one recipe")
        XCTAssertEqual(recipeListViewModel.recipes.first?.name, "Pasta", "Recipe name should match")
    }
    
    func testLoadRecipes_Failure() async {
        let error = NetworkError.server("Internal Server Error")
        mockRecipeService.fetchRecipesResult = .failure(error)
        
        await recipeListViewModel.loadRecipes(.valid)
        
        XCTAssertFalse(recipeListViewModel.isLoading, "isLoading should be false after loading")
        XCTAssertEqual(recipeListViewModel.errorMessage, error, "errorMessage should be set to the error")
        XCTAssertTrue(recipeListViewModel.recipes.isEmpty, "recipes should be empty on failure")
    }
    
    func testLoadRecipes_EmptyResponse() async {
        let error = NetworkError.empty("Empty response from server")
        mockRecipeService.fetchRecipesResult = .failure(error)
        await recipeListViewModel.loadRecipes(.valid)
        
        XCTAssertFalse(recipeListViewModel.isLoading, "isLoading should be false after loading")
        XCTAssertEqual(recipeListViewModel.errorMessage, error)
        XCTAssertTrue(recipeListViewModel.recipes.isEmpty, "recipes should be empty on empty response")
    }

    func testLoadRecipes_InvalidEndpoint() async {
        let error = NetworkError.invalidURL
        mockRecipeService.fetchRecipesResult = .failure(error)
        
        await recipeListViewModel.loadRecipes(.invalid)
        
        XCTAssertFalse(recipeListViewModel.isLoading, "isLoading should be false after loading")
        XCTAssertEqual(recipeListViewModel.errorMessage, error)
        XCTAssertTrue(recipeListViewModel.recipes.isEmpty, "recipes should be empty on invalid endpoint")
    }
}

