//
//  ImageServiceTests.swift
//  fetch-recipeTests
//
//  Created by Caleb Meurer on 12/6/24.
//

import XCTest
@testable import fetch_recipe

final class ImageServiceTests: XCTestCase {
    var imageService: ImageService!
    var mockSession: MockURLSession!
    var mockCache: MockImageCacheService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockSession = MockURLSession()
        mockCache = MockImageCacheService()
        imageService = ImageService(cache: mockCache, session: mockSession)
    }
    
    override func tearDownWithError() throws {
        imageService = nil
        mockSession = nil
        mockCache = nil
        try super.tearDownWithError()
    }

    func testLoadImage_InvalidURL() async throws {
        
        let invalidURL: URL? = nil
        
        let result = await imageService.loadImage(from: invalidURL)
       
        switch result {
        case .success:
            XCTFail("Expected failure due to invalid URL, got success.")
        case .failure(let error):
            XCTAssertEqual(error, .invalidURL, "Expected ImageServiceError.invalidURL")
        }
    }

    func testLoadImage_CachedImage() async throws {
        let url = URL(string: "https://example.com/image.png")!
        let expectedImage = UIImage(systemName: "photo")!
        mockCache[url] = expectedImage
        
        let result = await imageService.loadImage(from: url)
        
        switch result {
        case .success(let image):
            XCTAssertEqual(image.pngData(), expectedImage.pngData(), "The returned image should match the cached image.")
        case .failure(let error):
            XCTFail("Expected success due to cached image, got failure: \(error)")
        }
    }
    
    func testLoadImage_NetworkError() async throws {
        let url = URL(string: "https://example.com/image.png")!
        let expectedError = URLError(.notConnectedToInternet)
        mockSession.error = expectedError
        
        let result = await imageService.loadImage(from: url)
        
        switch result {
        case .success:
            XCTFail("Expected failure due to network error, got success.")
        case .failure(let error):
            if case .loadingImage(let message) = error {
                XCTAssertTrue(message.contains(expectedError.localizedDescription), "Expected loadingImage error with network error message.")
            } else {
                XCTFail("Expected ImageServiceError.loadingImage, got \(error)")
            }
        }
    }
    
    func testLoadImage_InvalidImageData() async throws {
        let url = URL(string: "https://example.com/image.png")!
        let invalidData = "Not image data".data(using: .utf8)!
        mockSession.data = invalidData
        mockSession.response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let result = await imageService.loadImage(from: url)
        
        switch result {
        case .success:
            XCTFail("Expected failure due to invalid image data, got success.")
        case .failure(let error):
            if case .loadingImage(let message) = error {
                XCTAssertTrue(message.contains("Unable to construct image"), "Expected loadingImage error due to invalid image data.")
            } else {
                XCTFail("Expected ImageServiceError.loadingImage, got \(error)")
            }
        }
    }

    func testLoadImage_SuccessfulDownloadAndCache() async throws {
        let url = URL(string: "https://example.com/image.png")!
        let expectedImage = UIImage(systemName: "photo")!
        let imageData = expectedImage.pngData()!
        mockSession.data = imageData
        mockSession.response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        XCTAssertNil(mockCache[url], "Cache should be empty before loading the image.")
        
        let result = await imageService.loadImage(from: url)
        
        switch result {
        case .success(let image):
            XCTAssertEqual(image.pngData()?.count, expectedImage.pngData()?.count, "The returned image should match the fetched image.")
            XCTAssertNotNil(mockCache[url], "Image should be cached after successful load.")
            XCTAssertEqual(mockCache[url]?.pngData()?.count, expectedImage.pngData()?.count, "Cached image should match the loaded image.")
        case .failure(let error):
            XCTFail("Expected success, got failure: \(error)")
        }
    }
}
