//
//  RecipeRowViewModelTests.swift
//  fetch-recipeTests
//
//  Created by Caleb Meurer on 12/6/24.
//

import XCTest
@testable import fetch_recipe

@MainActor
class RecipeRowViewModelTests: XCTestCase {
    var viewModel: RecipeRowViewModel!
    var mockRecipeService: MockRecipeService!
    var sampleRecipe: Recipe!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockRecipeService = MockRecipeService()
        sampleRecipe = Recipe(
            uuid: UUID(),
            cuisine: "Italian",
            name: "Pasta",
            photoURLLarge: nil,
            photoURLSmall: URL(string: "https://example.com/image.png"),
            sourceURL: nil,
            youtubeURL: nil
        )
        viewModel = RecipeRowViewModel(sampleRecipe, mockRecipeService)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockRecipeService = nil
        sampleRecipe = nil
        try super.tearDownWithError()
    }

    func testLoadImage_Success() async throws {
        
        let expectedImage = UIImage(systemName: "photo")!
        mockRecipeService.loadImageResult = .success(expectedImage)
        
        await viewModel.loadImage()
        
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false after loading")
        XCTAssertNil(viewModel.errorMessage, "errorMessage should be nil on success")
        XCTAssertNotNil(viewModel.image, "Image should not be nil after successful load")
        XCTAssertEqual(viewModel.image?.pngData(), expectedImage.pngData(), "Loaded image should match the expected image")
    }

    func testLoadImage_Failure() async throws {
        
        let expectedError = ImageServiceError.loadingImage("Network error")
        mockRecipeService.loadImageResult = .failure(expectedError)
        
        await viewModel.loadImage()
        
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false after loading")
        XCTAssertEqual(viewModel.errorMessage, expectedError, "errorMessage should be set to the error")
        XCTAssertNil(viewModel.image, "Image should be nil after failed load")
    }

    func testLoadImage_InvalidURL() async throws {
        sampleRecipe = Recipe(
            uuid: UUID(),
            cuisine: "Italian",
            name: "Pasta",
            photoURLLarge: nil,
            photoURLSmall: nil,
            sourceURL: nil,
            youtubeURL: nil
        )
        viewModel = RecipeRowViewModel(sampleRecipe, mockRecipeService)
        let expectedError = ImageServiceError.invalidURL
        mockRecipeService.loadImageResult = .failure(expectedError)
        
        await viewModel.loadImage()
        
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false after loading")
        XCTAssertEqual(viewModel.errorMessage, expectedError, "errorMessage should be set to invalidURL")
        XCTAssertNil(viewModel.image, "Image should be nil when URL is invalid")
    }

    func testLoadImage_ErrorMessageSetOnFailure() async throws {
        let expectedError = ImageServiceError.loadingImage("Network error")
        mockRecipeService.loadImageResult = .failure(expectedError)
        
        await viewModel.loadImage()
        
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false after loading")
        XCTAssertEqual(viewModel.errorMessage, expectedError, "errorMessage should be set to the error")
        XCTAssertNil(viewModel.image, "Image should be nil after failed load")
    }
}
