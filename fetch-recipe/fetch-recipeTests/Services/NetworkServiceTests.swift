//
//  NetworkServiceTests.swift
//  fetch-recipeTests
//
//  Created by Caleb Meurer on 12/6/24.
//

import XCTest
@testable import fetch_recipe

final class NetworkServiceTests: XCTestCase {
    
    var networkService: NetworkService!
    var mockSession: MockURLSession!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockSession = MockURLSession()
        networkService = NetworkService(session: mockSession)
    }
    
    override func tearDownWithError() throws {
        networkService = nil
        mockSession = nil
        try super.tearDownWithError()
    }
    
    func testFetchData_Success() async throws {
        let expectedData = """
        {
            "uuid": "123e4567-e89b-12d3-a456-426614174000",
            "cuisine": "Italian",
            "name": "Pasta",
            "photo_url_large": null,
            "photo_url_small": null,
            "source_url": null,
            "youtube_url": null
        }
        """.data(using: .utf8)!
        
        let expectedRecipe = Recipe(
            uuid: UUID(uuidString: "123e4567-e89b-12d3-a456-426614174000")!,
            cuisine: "Italian",
            name: "Pasta",
            photoURLLarge: nil,
            photoURLSmall: nil,
            sourceURL: nil,
            youtubeURL: nil
        )
        
        mockSession.data = expectedData
        mockSession.response = HTTPURLResponse(
            url: URL(string: Endpoint.valid.rawValue)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let result: Result<Recipe, NetworkError> = await networkService.fetchData(from: .valid, for: Recipe.self)
        
        switch result {
        case .success(let recipe):
            XCTAssertEqual(recipe, expectedRecipe, "The fetched recipe should match the expected recipe.")
        case .failure(let error):
            XCTFail("Expected success, but got failure with error: \(error)")
        }
    }
    
    func testFetchData_InvalidURL() async throws {
        let result: Result<Recipe, NetworkError> = await networkService.fetchData(from: .invalid, for: Recipe.self)
        
        switch result {
        case .success:
            XCTFail("Expected failure due to invalid URL, but got success.")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, NetworkError.malformed("The data couldn’t be read because it isn’t in the correct format").localizedDescription)
        }
    }
    
    func testFetchData_NetworkError() async throws {
        let expectedError = URLError(.notConnectedToInternet)
        mockSession.error = expectedError
        
        let result: Result<Recipe, NetworkError> = await networkService.fetchData(from: .valid, for: Recipe.self)
        
        switch result {
        case .success:
            XCTFail("Expected failure due to network error, but got success.")
        case .failure(let error):
            XCTAssertEqual(error, .request(expectedError.localizedDescription), "Expected NetworkError.request with the appropriate error message.")
        }
    }
    
    func testFetchData_ServerError() async throws {
        mockSession.data = Data()
        mockSession.response = HTTPURLResponse(
            url: URL(string: Endpoint.valid.rawValue)!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )
        
        let result: Result<Recipe, NetworkError> = await networkService.fetchData(from: .valid, for: Recipe.self)
        
        switch result {
        case .success:
            XCTFail("Expected failure due to server error, but got success.")
        case .failure(let error):
            XCTAssertEqual(error, NetworkError.server("HTTP Error 500"))
        }
    }
    
    func testFetchData_DecodingError() async throws {
        let invalidJSONData = "Invalid JSON".data(using: .utf8)!
        mockSession.data = invalidJSONData
        mockSession.response = HTTPURLResponse(
            url: URL(string: Endpoint.valid.rawValue)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let result: Result<Recipe, NetworkError> = await networkService.fetchData(from: .valid, for: Recipe.self)
        
        switch result {
        case .success:
            XCTFail("Expected failure due to decoding error, but got success.")
        case .failure(let error):
            if case .malformed = error {
            } else {
                XCTFail("Expected NetworkError.malformed, but got \(error)")
            }
        }
    }
}
