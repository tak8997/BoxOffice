//
//  BoxOfficeMovieImageModalViewController.swift
//  5_BoxOffice
//
//  Created by byungtak on 28/09/2018.
//  Copyright © 2018 byungtak. All rights reserved.
//

import UIKit

class BoxOfficeMovieImageModalViewController: BaseViewController {

    var movieImage: String?
    
    @IBOutlet weak var moviePoster: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        intializeViews()
        
        fetchMovieImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideIndicator()
    }
    
    @objc func tappedModalDismiss(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func fetchMovieImage() {
        showIndicator()
        
        DispatchQueue.global().async {
            guard
                let imageUrl: String = self.movieImage,
                let url: URL = URL(string: imageUrl),
                let data: Data = try? Data(contentsOf: url) else {
                    
                    return
            }
            
            DispatchQueue.main.async {
                self.moviePoster.image = UIImage(data: data)
                
                self.hideIndicator()
            }
        }
    }
    
    private func intializeViews() {
        intializeNavigationBar()
        
        indicator.isHidden = true
        
        moviePoster.image =  UIImage(named: "img_placeholder")
    }
    
    private func intializeNavigationBar() {
        let lightBlue = "#84A3F6"
        
        navigationController?.navigationBar.topItem?.title = "영화 포스터"
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(tappedModalDismiss(sender:)) )
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        navigationController?.navigationBar.barTintColor = lightBlue.hexStringToUIColor()
    }
}
