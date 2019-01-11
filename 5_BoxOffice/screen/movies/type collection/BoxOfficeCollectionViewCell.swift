//
//  BoxOfficeCollectionViewCell.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 12..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import UIKit

class BoxOfficeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieThumb: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieGrade: UIImageView!          //관람등급
    @IBOutlet weak var movieUserRating: UILabel!         //평점
    @IBOutlet weak var movieReservationGrade: UILabel!   //에매순위
    @IBOutlet weak var movieReservationRate: UILabel!    //예매율
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieViewContainer: UIView!
    
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    
    func configure(_ movie: Movie, item: Int, index: IndexPath) {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.frame = bounds
        
        self.imageWidth.constant = UIScreen.main.bounds.width / 2 - 20
        self.imageHeight.constant = UIScreen.main.bounds.height / 2 - 60 - 85
        
        self.movieTitle.text = movie.title
        self.movieUserRating.text = "(\(movie.userRating))"
        self.movieReservationGrade.text = "\(movie.reservationGrade)위"
        self.movieReservationRate.text = "\(movie.reservationRate)%"
        self.movieReleaseDate.text = movie.date
        self.movieGrade.image = UIImage(named: MovieGrade(rawValue: movie.grade)?.movieGrade ?? "")
        self.movieThumb.image = UIImage(named: "img_placeholder")
        
        BoxOfficeService.fetchImage(imageURL: movie.thumb) { (image) in
            if item == index.item {
                self.movieThumb.image = image
            }
        }
    }
}
