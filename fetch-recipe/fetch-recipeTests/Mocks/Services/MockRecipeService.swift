//
//  MockRecipeService.swift
//  fetch-recipeTests
//
//  Created by Caleb Meurer on 12/6/24.
//

import UIKit
@testable import fetch_recipe

class MockRecipeService: RecipeServiceProtocol {
    var fetchRecipesResult: Result<[Recipe], NetworkError> = .failure(.request("No response set"))
    var loadImageResult: Result<UIImage, ImageServiceError> = .failure(.unknown("Unknown"))
    var delay: TimeInterval = 0.0
    var fetchRecipesCalled = false
    
    func fetchRecipes(from endpoint: Endpoint) async -> Result<[Recipe], NetworkError> {
        fetchRecipesCalled = true
        if delay > 0 {
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        return fetchRecipesResult
    }
    
    func loadImage(from url: URL?) async -> Result<UIImage, ImageServiceError> {
        if delay > 0 {
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        return loadImageResult
    }
}
