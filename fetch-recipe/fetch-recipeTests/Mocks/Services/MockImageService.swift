//
//  MockImageService.swift
//  fetch-recipeTests
//
//  Created by Caleb Meurer on 12/6/24.
//

import UIKit
@testable import fetch_recipe

class MockImageService: ImageServiceProtocol {
    var cache: Cacheable
    
    var loadImageResult: Result<UIImage, ImageServiceError> = .failure(.unknown("Mock \(#function)"))

    func loadImage(from url: URL?) async -> Result<UIImage, ImageServiceError> {
        return loadImageResult
    }
    
    init(cache: Cacheable = MockImageCacheService()) {
        self.cache = cache
    }
}
