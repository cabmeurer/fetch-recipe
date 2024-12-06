//
//  MockRecipeRowViewModel.swift
//  fetch-recipeTests
//
//  Created by Caleb Meurer on 12/6/24.
//

import UIKit
@testable import fetch_recipe

class MockRecipeRowViewModel: RecipeRowViewModel {
    var loadImageCalled = false
    var mockImage: UIImage?
    var mockError: ImageServiceError?
    
    override func loadImage() async {
        loadImageCalled = true
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        if let error = mockError {
            self.errorMessage = error
        } else if let image = mockImage {
            self.image = image
        }
    }
}
