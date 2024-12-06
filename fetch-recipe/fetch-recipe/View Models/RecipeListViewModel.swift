//
//  RecipeListViewModel.swift
//  fetch-recipe
//
//  Created by Caleb Meurer on 12/6/24.
//

import SwiftUI

@MainActor
class RecipeListViewModel: ObservableObject {
    
    let recipeService: RecipeServiceProtocol
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: NetworkError?

    func loadRecipes(_ endpoint: Endpoint) async {
        isLoading = true
        errorMessage = nil
 
        defer {
            isLoading = false
        }
        
        let response = await recipeService.fetchRecipes(from: endpoint)
        switch response {
        case .success(let recipes):
            self.recipes = recipes
        case .failure(let error):
            errorMessage = error
        }
    }
    
    init(_ recipeService: RecipeServiceProtocol) {
        self.recipeService = recipeService
    }
}
