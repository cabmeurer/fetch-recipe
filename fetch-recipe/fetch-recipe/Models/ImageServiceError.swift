//
//  ImageServiceError.swift
//  fetch-recipe
//
//  Created by Caleb Meurer on 12/6/24.
//

import Foundation

enum ImageServiceError: Error, Equatable {
    case invalidURL
    case loadingImage(String)
    case unknown(String)
}

extension ImageServiceError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL, unable to load images", comment: "Invalid URL")
        case .loadingImage(let message):
            return NSLocalizedString("Error loading image", comment: message)
        case .unknown(let message):
            return NSLocalizedString("Unknown image service error", comment: message)
        }
    }
}
