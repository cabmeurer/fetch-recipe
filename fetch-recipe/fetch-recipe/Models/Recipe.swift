//
//  Recipe.swift
//  fetch-recipe
//
//  Created by Caleb Meurer on 12/6/24.
//

import Foundation

struct Recipe: Codable, Identifiable, Equatable {
    
    let uuid: UUID
    let cuisine: String
    let name: String
    let photoURLLarge: URL?
    let photoURLSmall: URL?
    let sourceURL: URL?
    let youtubeURL: URL?
    
    var id: UUID { uuid }
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case cuisine
        case name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}

