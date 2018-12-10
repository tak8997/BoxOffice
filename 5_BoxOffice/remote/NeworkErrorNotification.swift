//
//  NeworkErrorNotification.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 25..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import Foundation

func getNetworkErrorNotification() -> Notification.Name {
    let DidReceiveNetworkErrorNotification: Notification.Name = Notification.Name("ErrorHandling")
    
    return DidReceiveNetworkErrorNotification
}
