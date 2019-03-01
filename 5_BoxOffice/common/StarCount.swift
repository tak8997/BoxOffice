//
//  StarCount.swift
//  5_BoxOffice
//
//  Created by byungtak on 16/12/2018.
//  Copyright © 2018 byungtak. All rights reserved.
//

import Foundation

struct StarCount {
    let rating: Double
    
    func getStartCount() -> Double {
        return ceil(rating) * 0.5
    }

}

