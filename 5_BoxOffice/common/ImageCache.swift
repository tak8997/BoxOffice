//
//  ImageCache.swift
//  5_BoxOffice
//
//  Created by byungtak on 22/12/2018.
//  Copyright © 2018 byungtak. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
    static let shared: NSCache = { () -> NSCache<NSString, UIImage> in
        let cache = NSCache<NSString, UIImage>()
        
        cache.name = "BoxOfficeImageCache"
        cache.countLimit = 20
        cache.totalCostLimit = 10 * 1024 * 1024
        
        return cache
    } ()
}
