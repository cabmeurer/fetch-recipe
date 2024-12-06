//
//  Endpoint.swift
//  fetch-recipe
//
//  Created by Caleb Meurer on 12/6/24.
//

import Foundation

enum Endpoint: String {
    case valid
    case invalid
    case malformed
    case empty
    
    var base: String {
        return "https://d3jbb8n5wk0qxi.cloudfront.net/"
    }
    
    var name: String {
        switch self {
        case .invalid:
            "Invalid"
        case .valid:
            "Valid"
        case .malformed:
            "Malformed"
        case .empty:
            "Empty"
        }
    }
    
    var rawValue: String {
        switch self {
        case .valid:
            base.appending("recipes.json")
        case .invalid:
            base.appending("\n")
        case .malformed:
            base.appending("recipes-malformed.json")
        case .empty:
            base.appending("recipes-empty.json")
        }
    }
}
