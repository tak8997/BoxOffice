//
//  UIViewController.swift
//  5_BoxOffice
//
//  Created by byungtak on 16/12/2018.
//  Copyright © 2018 byungtak. All rights reserved.
//

import UIKit


extension UIViewController {
    func showOrderSettingActionSheet(completion: @escaping (_ orderType: OrderType) -> Void) {
        let orderAlertController: UIAlertController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let actionOrderingByRate: UIAlertAction = UIAlertAction(title: "예매율", style: UIAlertActionStyle.default) { (action) in
            completion(OrderType.rate)
        }
        
        let actionOrderingByCuration: UIAlertAction = UIAlertAction(title: "큐레이션", style: UIAlertActionStyle.default) { (action) in
            completion(OrderType.curation)
        }
        
        let actionOrderingByDate: UIAlertAction = UIAlertAction(title: "개봉일", style: UIAlertActionStyle.default) { (action) in
            completion(OrderType.date)
        }
        
        let actionCancel: UIAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        orderAlertController.addAction(actionOrderingByRate)
        orderAlertController.addAction(actionOrderingByCuration)
        orderAlertController.addAction(actionOrderingByDate)
        orderAlertController.addAction(actionCancel)
        
        self.present(orderAlertController, animated: true)
    }
}
