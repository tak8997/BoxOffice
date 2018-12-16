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
    
    func configure(_ movie: Movie) {
        movieTitle.text = movie.title
        movieUserRating.text = String(movie.userRating)
        movieReservationGrade.text = String(movie.reservationGrade)
        movieReservationRate.text = String(movie.reservationRate)
        movieReleaseDate.text = movie.date
        
        let gradeImageType: String
        
        switch movie.grade {
        case 0: gradeImageType = "ic_12"
        case 12: gradeImageType = "ic_15"
        case 15: gradeImageType = "ic_19"
        case 19: gradeImageType = "ic_allages"
        default: gradeImageType = "ic_allages"
        }
        
        movieGrade.image = UIImage(named: gradeImageType)
        movieThumb.image = UIImage(named: "img_placeholder")
    }
    
}
