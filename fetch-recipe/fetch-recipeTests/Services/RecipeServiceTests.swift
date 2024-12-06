//
//  RecipeServiceTests.swift
//  fetch-recipeTests
//
//  Created by Caleb Meurer on 12/6/24.
//

import XCTest
@testable import fetch_recipe

class RecipeServiceTests: XCTestCase {
    
    var recipeService: RecipeService!
    var mockNetworkService: MockNetworkService!
    var mockImageService: MockImageService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockImageService = MockImageService()
        recipeService = RecipeService(mockNetworkService, mockImageService)
    }
    
    override func tearDown() {
        recipeService = nil
        mockNetworkService = nil
        mockImageService = nil
        super.tearDown()
    }
    
    func testFetchRecipes_Success() async {
        let sampleRecipe = Recipe(
            uuid: UUID(),
            cuisine: "Italian",
            name: "Pasta",
            photoURLLarge: nil,
            photoURLSmall: nil,
            sourceURL: nil,
            youtubeURL: nil
        )
        let sampleResponse = RecipeResponse(recipes: [sampleRecipe])
        mockNetworkService.fetchDataResult = .success(sampleResponse)
        
        let result = await recipeService.fetchRecipes(from: .valid)
        
        switch result {
        case .success(let recipes):
            XCTAssertEqual(recipes.count, 1)
            XCTAssertEqual(recipes.first?.name, "Pasta")
        case .failure(let error):
            XCTFail("Expected success but got failure with error: \(error)")
        }
    }

    func testFetchRecipes_EmptyResponse() async {
        let sampleResponse = RecipeResponse(recipes: [])
        mockNetworkService.fetchDataResult = .success(sampleResponse)
        
        let result = await recipeService.fetchRecipes(from: .valid)
        
        switch result {
        case .success:
            XCTFail("Expected failure due to empty recipes but got success")
        case .failure(let error):
            XCTAssertEqual(error, NetworkError.empty("Empty response from server"))
        }
    }

    func testFetchRecipes_Failure() async {
        mockNetworkService.fetchDataResult = .failure(.server("Internal Server Error"))
        
        let result = await recipeService.fetchRecipes(from: .valid)
        
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertEqual(error, NetworkError.server("Internal Server Error"))
        }
    }

    func testLoadImage_Success() async {
        let image = UIImage(systemName: "photo")!
        mockImageService.loadImageResult = .success(image)
        
        let result = await recipeService.loadImage(from: URL(string: "https://example.com/image.png"))
        
        switch result {
        case .success(let returnedImage):
            XCTAssertEqual(returnedImage, image)
        case .failure(let error):
            XCTFail("Expected success but got failure with error: \(error)")
        }
    }

    func testLoadImage_Failure() async {
        mockImageService.loadImageResult = .failure(.loadingImage("Network error"))
        
        let result = await recipeService.loadImage(from: URL(string: "https://example.com/image.png"))
        
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertEqual(error, ImageServiceError.loadingImage("Network error"))
        }
    }

    func testLoadImage_InvalidURL() async {
        mockImageService.loadImageResult = .failure(.invalidURL)
        
        let result = await recipeService.loadImage(from: nil)
        
        switch result {
        case .success:
            XCTFail("Expected failure due to invalid URL but got success")
        case .failure(let error):
            XCTAssertEqual(error, ImageServiceError.invalidURL)
        }
    }
}
