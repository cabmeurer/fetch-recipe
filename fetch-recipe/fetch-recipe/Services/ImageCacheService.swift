//
//  ImageCacheService.swift
//  fetch-recipe
//
//  Created by Caleb Meurer on 12/6/24.
//

import UIKit

protocol Cacheable {
    subscript(_ url: URL) -> UIImage? { get set }
}

class ImageCacheService: Cacheable {
    
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
