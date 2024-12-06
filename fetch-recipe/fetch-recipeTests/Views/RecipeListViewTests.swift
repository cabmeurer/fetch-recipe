//
//  RecipeListViewTests.swift
//  fetch-recipeTests
//
//  Created by Caleb Meurer on 12/6/24.
//

import XCTest
@testable import fetch_recipe

@MainActor
class RecipeListViewTests: XCTestCase {
    
    func testRecipeListViewInitialization() {
        
        let mockViewModel = RecipeListViewModel(MockRecipeService())
        
        let view = RecipeListView(mockViewModel)
        
        XCTAssertNotNil(view, "The view should not be nil after initialization")
    }
    
    func testEndpointInitialization() {
        
        let mockViewModel = RecipeListViewModel(MockRecipeService())
        let view = RecipeListView(mockViewModel)
        
        let initialEndpoint = view.endpoint
        
        XCTAssertEqual(initialEndpoint, .valid, "The initial endpoint should be .valid")
    }
    
    func testEndpointsArray() {
        
        let mockViewModel = RecipeListViewModel(MockRecipeService())
        let view = RecipeListView(mockViewModel)
        
        let endpoints = view.endpoints
        
        XCTAssertEqual(endpoints, [.valid, .empty, .malformed], "The endpoints array should contain .valid, .empty, and .malformed")
    }
    
    func testLoadRecipesCallsViewModel() async throws {
        let mockService = MockRecipeService()
        let mockViewModel = RecipeListViewModel(mockService)
        let view = RecipeListView(mockViewModel)
        mockService.fetchRecipesResult = .success([])
        
        await view.loadRecipes(.valid)
        
        XCTAssertTrue(mockService.fetchRecipesCalled, "fetchRecipes should have been called")
    }
}
