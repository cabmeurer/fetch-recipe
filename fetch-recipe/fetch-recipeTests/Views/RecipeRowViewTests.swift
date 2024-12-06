//
//  RecipeRowViewTests.swift
//  fetch-recipeTests
//
//  Created by Caleb Meurer on 12/6/24.
//

import XCTest
@testable import fetch_recipe

@MainActor
class RecipeRowViewTests: XCTestCase {
    var viewModel: MockRecipeRowViewModel!
    var recipe: Recipe!
    var view: RecipeRowView!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        recipe = Recipe(
            uuid: UUID(),
            cuisine: "Italian",
            name: "Pasta",
            photoURLLarge: nil,
            photoURLSmall: URL(string: "https://example.com/image.png"),
            sourceURL: nil,
            youtubeURL: nil
        )
        let mockRecipeService = MockRecipeService()
        viewModel = MockRecipeRowViewModel(recipe, mockRecipeService)
        view = RecipeRowView(viewModel)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        recipe = nil
        view = nil
        try super.tearDownWithError()
    }
    
    func testRecipeRowViewInitialization() {
        XCTAssertNotNil(view, "The view should not be nil after initialization")
        XCTAssertNotNil(view.viewModel, "The view model should not be nil")
        XCTAssertEqual(view.viewModel.recipe.name, "Pasta", "The recipe name should be 'Pasta'")
    }
    
    func testViewHoldsCorrectViewModel() {
        XCTAssertEqual(view.viewModel.recipe, recipe, "The view's recipe should match the initialized recipe")
    }
    
    func testLoadImageUpdatesViewModelProperties() async {
        
        let expectedImage = UIImage(systemName: "photo")!
        viewModel.mockImage = expectedImage
        
        await viewModel.loadImage()
        
        XCTAssertTrue(viewModel.loadImageCalled, "loadImage() should have been called")
        XCTAssertNotNil(viewModel.image, "Image should not be nil after loading")
        XCTAssertEqual(viewModel.image?.pngData(), expectedImage.pngData(), "The loaded image should match the expected image")
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false after loading")
        XCTAssertNil(viewModel.errorMessage, "errorMessage should be nil on success")
    }
    
    func testLoadImageHandlesError() async {
        
        let expectedError = ImageServiceError.loadingImage("Network error")
        viewModel.mockError = expectedError
        
        await viewModel.loadImage()
        
        XCTAssertTrue(viewModel.loadImageCalled, "loadImage() should have been called")
        XCTAssertNil(viewModel.image, "Image should be nil on error")
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false after loading")
        XCTAssertEqual(viewModel.errorMessage, expectedError, "errorMessage should be set to the expected error")
    }
}
