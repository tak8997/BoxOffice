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
        let starCnt: Double
        
        switch rating {
        case 0.0...1.0 : starCnt = 0.5
        case 1.0...2.0 : starCnt = 1.0
        case 2.0...3.0 : starCnt = 1.5
        case 3.0...4.0 : starCnt = 2.0
        case 4.0...5.0 : starCnt = 2.5
        case 5.0...6.0 : starCnt = 3.0
        case 6.0...7.0 : starCnt = 3.5
        case 7.0...8.0 : starCnt = 4.0
        case 8.0...9.0 : starCnt = 4.5
        case 9.0...10.0 : starCnt = 5.0
        default: starCnt = 0.0
        }
        
        return starCnt
    }

}

