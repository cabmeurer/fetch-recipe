//
//  ImageService.swift
//  fetch-recipe
//
//  Created by Caleb Meurer on 12/6/24.
//

import UIKit

protocol ImageServiceProtocol {
    func loadImage(from url: URL?) async -> Result<UIImage, ImageServiceError>
    var cache: Cacheable { get }
}

class ImageService: ImageServiceProtocol {
    var cache: Cacheable
    private let session: URLSessionProtocol

    init(cache: Cacheable = ImageCacheService(), session: URLSessionProtocol = URLSession.shared) {
        self.cache = cache
        self.session = session
    }

    func loadImage(from url: URL?) async -> Result<UIImage, ImageServiceError> {
        guard let url = url else {
            return .failure(.invalidURL)
        }

        if let cached = cache[url] {
            return .success(cached)
        }

        do {
            let (data, _) = try await session.data(from: url)
            if let image = UIImage(data: data) {
                cache[url] = image
                return .success(image)
            } else {
                return .failure(.loadingImage("Unable to construct image from data"))
            }
        } catch {
            return .failure(.loadingImage(error.localizedDescription))
        }
    }
}
