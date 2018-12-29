//
//  MovieGrade.swift
//  5_BoxOffice
//
//  Created by Tak on 29/12/2018.
//  Copyright © 2018 byungtak. All rights reserved.
//

import Foundation

enum MovieGrade: Int {
    case ic_12 = 12
    case ic_15 = 15
    case ic_19 = 19
    case ic_allages = 0
    
    var movieGrade: String {
        switch self {
        case .ic_12: return "ic_12"
        case .ic_15: return "ic_15"
        case .ic_19: return "ic_19"
        case .ic_allages: return "ic_allages"
        }
    }
}
