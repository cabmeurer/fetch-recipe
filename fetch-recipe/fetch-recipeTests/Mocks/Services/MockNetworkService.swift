//
//  MockNetworkService.swift
//  fetch-recipeTests
//
//  Created by Caleb Meurer on 12/6/24.
//

import Foundation
@testable import fetch_recipe

class MockNetworkService: Networkable {
    var fetchDataResult: Result<Any, NetworkError> = .failure(.request("No response set"))

    func fetchData<T: Decodable>(from endpoint: Endpoint, for type: T.Type) async -> Result<T, NetworkError> {
        switch fetchDataResult {
        case .success(let value):
            if let typedValue = value as? T {
                return .success(typedValue)
            } else {
                return .failure(.malformed("Invalid data type"))
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
