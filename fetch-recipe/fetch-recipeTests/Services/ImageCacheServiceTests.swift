//
//  ImageCacheServiceTests.swift
//  fetch-recipeTests
//
//  Created by Caleb Meurer on 12/6/24.
//

import XCTest
@testable import fetch_recipe

class ImageCacheServiceTests: XCTestCase {
    var imageCache: ImageCacheService!
    
    override func setUp() {
        super.setUp()
        imageCache = ImageCacheService()
    }
    
    override func tearDown() {
        imageCache = nil
        super.tearDown()
    }

    func testStoreAndRetrieveImage() {
        
        let url = URL(string: "https://example.com/image.png")!
        let image = UIImage(systemName: "photo")!
        
        imageCache[url] = image
        let cachedImage = imageCache[url]
        
        XCTAssertNotNil(cachedImage, "Cached image should not be nil")
        XCTAssertEqual(cachedImage?.pngData(), image.pngData(), "Cached image should match the stored image")
    }
    
    func testRemoveImage() {
        
        let url = URL(string: "https://example.com/image.png")!
        let image = UIImage(systemName: "photo")!
        imageCache[url] = image
        
        imageCache[url] = nil
        let cachedImage = imageCache[url]
        
        XCTAssertNil(cachedImage, "Cached image should be nil after removal")
    }
    
    func testRetrieveNonExistentImage() {
        
        let url = URL(string: "https://example.com/nonexistent.png")!
        
        let cachedImage = imageCache[url]
        
        XCTAssertNil(cachedImage, "Cached image should be nil for a non-existent key")
    }
    
    func testStoreAndRetrieveMultipleImages() {
        
        let url1 = URL(string: "https://example.com/image1.png")!
        let image1 = UIImage(systemName: "photo")!
        let url2 = URL(string: "https://example.com/image2.png")!
        let image2 = UIImage(systemName: "house")!
        
        imageCache[url1] = image1
        imageCache[url2] = image2
        
        let cachedImage1 = imageCache[url1]
        let cachedImage2 = imageCache[url2]
        
        XCTAssertNotNil(cachedImage1, "Cached image1 should not be nil")
        XCTAssertNotNil(cachedImage2, "Cached image2 should not be nil")
        XCTAssertEqual(cachedImage1?.pngData(), image1.pngData(), "Cached image1 should match the stored image1")
        XCTAssertEqual(cachedImage2?.pngData(), image2.pngData(), "Cached image2 should match the stored image2")
    }
}
