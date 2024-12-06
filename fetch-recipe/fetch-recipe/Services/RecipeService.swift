//
//  RecipeService.swift
//  fetch-recipe
//
//  Created by Caleb Meurer on 12/6/24.
//

import UIKit

protocol RecipeServiceProtocol {
    func fetchRecipes(from endpoint: Endpoint) async -> Result<[Recipe], NetworkError>
    func loadImage(from url: URL?) async -> Result<UIImage, ImageServiceError>
}

class RecipeService: RecipeServiceProtocol {
    private let networkService: Networkable
    private let imageService: ImageServiceProtocol

    func fetchRecipes(from endpoint: Endpoint) async -> Result<[Recipe], NetworkError> {
        let response = await networkService.fetchData(from: endpoint, for: RecipeResponse.self)
        switch response {
        case .success(let recipeResponse):
            guard recipeResponse.recipes.count > 0 else {
                return .failure(NetworkError.empty("Empty response from server"))
            }
            return .success(recipeResponse.recipes)
        case .failure(let error):
            return .failure(error)
        }
    }

    func loadImage(from url: URL?) async -> Result<UIImage, ImageServiceError> {
        let response = await imageService.loadImage(from: url)
        switch response {
        case .success(let image):
            return .success(image)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    init(_ networkService: Networkable = NetworkService(), _ imageService: ImageServiceProtocol = ImageService()) {
        self.networkService = networkService
        self.imageService = imageService
    }
}
