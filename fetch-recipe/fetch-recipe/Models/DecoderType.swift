//
//  DecoderType.swift
//  fetch-recipe
//
//  Created by Caleb Meurer on 12/6/24.
//

import Foundation

protocol DecoderTypeProtocol {
    /// Decode method matches the method declaration in JSONDecoder so there is no need for an implementation.
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONDecoder: DecoderTypeProtocol {}

enum DecoderType {
    case json
    
    var value: DecoderTypeProtocol {
        switch self {
        case .json:
            return JSONDecoder()
        }
    }
}
