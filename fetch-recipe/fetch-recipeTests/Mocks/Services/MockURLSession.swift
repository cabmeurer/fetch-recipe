//
//  MockURLSession.swift
//  fetch-recipeTests
//
//  Created by Caleb Meurer on 12/6/24.
//

import Foundation
@testable import fetch_recipe

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }

        let response = self.response ?? HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        let data = self.data ?? Data()

        return (data, response)
    }
}
