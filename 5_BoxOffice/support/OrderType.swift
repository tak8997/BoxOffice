//
//  OrderType.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 13..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import Foundation

class OrderType {
    static let type: OrderType = OrderType()
    
    let rate = "0"
    let curation = "1"
    let date = "2"
    
    lazy var requestOrderType = rate
}
