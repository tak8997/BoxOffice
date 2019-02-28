//
//  UIAlertController+ErrorAlert.swift
//  5_BoxOffice
//
//  Created by Tak on 27/02/2019.
//  Copyright © 2019 byungtak. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlertController(title: String, message: String) {
        let style = UIAlertControllerStyle.alert
        
        let alertController: UIAlertController = UIAlertController(title: "요청 실패", message: "알수없는 네트워크 에러 입니다.", preferredStyle: style)
        
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
            print("OK preseed \(action.title ?? "")")
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}


