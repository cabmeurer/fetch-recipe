//
//  RecipeRowViewModel.swift
//  fetch-recipe
//
//  Created by Caleb Meurer on 12/6/24.
//

import SwiftUI

@MainActor
class RecipeRowViewModel: ObservableObject {
    
    private let recipeService: RecipeServiceProtocol
    let recipe: Recipe
    @Published var image: UIImage?
    @Published var isLoading: Bool = false
    @Published var errorMessage: ImageServiceError?
    
    func loadImage() async {
        isLoading = true
        errorMessage = nil
 
        defer {
            isLoading = false
        }
        
        let response = await recipeService.loadImage(from: recipe.photoURLSmall)
        switch response {
        case .success(let image):
            self.image = image
        case .failure(let error):
            errorMessage = error
        }
    }
    
    init(_ recipe: Recipe, _ recipeService: RecipeServiceProtocol) {
        self.recipe = recipe
        self.recipeService = recipeService
    }
}
