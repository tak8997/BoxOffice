//
//  SupportExtension.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 5..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import Foundation
import UIKit.UIColor

extension String {
    func hexStringToUIColor() -> UIColor {
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count != 6 {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension Int {
    func convertNumberToDecimalFormatter() -> String {
        let numFormatter : NumberFormatter = NumberFormatter();
        numFormatter.numberStyle = NumberFormatter.Style.decimal
        
        guard let decimalFormat = numFormatter.string(from: NSNumber(value: self)) else {
            return "0"
        }
        
        return decimalFormat
    }
}

extension Double {
    func convertDateFormatter() -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }
}


