//
//  OrderType.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 13..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import Foundation

enum OrderType: String {
    case rate = "0"
    case curation = "1"
    case date = "2"
    
    var navigationTitle: String {
        switch self {
        case .rate: return "예매율 순"
        case .date: return "개봉일"
        case .curation: return "큐레이션"
        }
    }
    
}
