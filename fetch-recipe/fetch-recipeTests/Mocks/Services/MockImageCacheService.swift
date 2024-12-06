//
//  MockImageCacheService.swift
//  fetch-recipeTests
//
//  Created by Caleb Meurer on 12/6/24.
//

import UIKit
@testable import fetch_recipe

class MockImageCacheService: Cacheable {
    
    let cache = NSCache<NSURL, UIImage>()
    
    subscript(url: URL) -> UIImage? {
        get {
            cache.object(forKey: url as NSURL)
        }
        set {
            if let image = newValue {
                cache.setObject(image, forKey: url as NSURL)
            } else {
                cache.removeObject(forKey: url as NSURL)
            }
        }
    }
}
