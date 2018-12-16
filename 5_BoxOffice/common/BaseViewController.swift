//
//  BaseViewController.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 25..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import UIKit
 

class BaseViewController: UIViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeNetworkFailNotification()
    }
    
    @objc func didReceiveNetworkErrorEvent(_ noti: Notification) {
        print("network_error")
        hideIndicator()
        
        DispatchQueue.main.async {
            self.showAlertController()
        }
    }
    
    func showIndicator() {
        DispatchQueue.main.async {
            if self.indicator.isAnimating == false {
                self.indicator.isHidden = false
                self.indicator.startAnimating()
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        }
    }
    
    func hideIndicator() {
        DispatchQueue.main.async {
            if self.indicator.isAnimating == true {
                self.indicator.stopAnimating()
                self.indicator.isHidden = true
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    private func showAlertController() {
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
    
    private func initializeNetworkFailNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveNetworkErrorEvent(_:)), name: getNetworkErrorNotification(), object: nil)
    }
}
