//
//  UIApplication.swift
//  5_BoxOffice
//
//  Created by Tak on 30/12/2018.
//  Copyright © 2018 byungtak. All rights reserved.
//

import UIKit

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector("statusBar")) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
