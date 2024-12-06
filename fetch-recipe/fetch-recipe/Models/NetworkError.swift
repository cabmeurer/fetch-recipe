//
//  NetworkError.swift
//  fetch-recipe
//
//  Created by Caleb Meurer on 12/6/24.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case request(String)
    case server(String)
    case malformed(String)
    case empty(String)
}

extension NetworkError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL, unable to make request to server", comment: "Invalid URL")
        case .request(let message):
            return NSLocalizedString("Request error", comment: message)
        case .server(let message):
            return NSLocalizedString("Error response from server", comment: message)
        case .malformed(let message):
            return NSLocalizedString("Malformed response from server", comment: message)
        case .empty(let message):
            return NSLocalizedString("Empty response from server", comment: message)
        }
    }
}
