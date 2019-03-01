//
//  BoxOfficeMovieImageModalViewController.swift
//  5_BoxOffice
//
//  Created by byungtak on 28/09/2018.
//  Copyright © 2018 byungtak. All rights reserved.
//

import UIKit

class BoxOfficeMovieImageModalViewController: UIViewController {

    @IBOutlet weak var moviePoster: UIImageView!
    
    var movieImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        intializeViews()
        
        fetchMovieImage()
    }
    
    private func fetchMovieImage() {
        guard let movieImage = self.movieImage else {
            return
        }
        
        BoxOfficeService.shared.fetchImage(imageURL: movieImage) { (image) in
            self.moviePoster.image = image
        }
    }
    
    private func intializeViews() {
        intializeNavigationBar()
        
        moviePoster.image =  UIImage(named: "img_placeholder")
    }
    
    private func intializeNavigationBar() {
        navigationController?.navigationBar.topItem?.title = "영화 포스터"
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(tappedModalDismiss(sender:)) )
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        navigationController?.navigationBar.barTintColor = "#84A3F6".hexStringToUIColor()
    }
    
    @objc func tappedModalDismiss(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
