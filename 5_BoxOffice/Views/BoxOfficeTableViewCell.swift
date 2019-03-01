//
//  BoxOfficeTableViewCell.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 9..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import UIKit

class BoxOfficeTableViewCell: UITableViewCell {

    @IBOutlet weak var movieThumb: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieGrade: UIImageView!
    @IBOutlet weak var movieUserRating: UILabel!         //평점
    @IBOutlet weak var movieReservationGrade: UILabel!   //에매순위
    @IBOutlet weak var movieReservationRate: UILabel!    //예매율
    @IBOutlet weak var movieReleaseDate: UILabel!
    
    func configure(_ movie: Movie, row: Int, index: IndexPath) {
        self.movieTitle.text = movie.title
        self.movieUserRating.text = String(movie.userRating)
        self.movieReservationGrade.text = String(movie.reservationGrade)
        self.movieReservationRate.text = String(movie.reservationRate)
        self.movieReleaseDate.text = movie.date
        self.movieGrade.image = UIImage(named: MovieGrade(rawValue: movie.grade)?.movieGrade ?? "")
        self.movieThumb.image = UIImage(named: "img_placeholder")
        
        BoxOfficeService.shared.fetchImage(imageURL: movie.thumb, completion: { [weak self] (image) in
            guard let self = self else { return }
            
            if row == index.row {
                self.movieThumb.image = image
            }
        }) 
    }
    
}
