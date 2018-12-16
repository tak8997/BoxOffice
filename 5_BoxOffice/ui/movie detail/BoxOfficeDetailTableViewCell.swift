//
//  BoxOfficeCommentTableViewCell.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 16..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import UIKit
import Cosmos

class BoxOfficeDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieGrade: UIImageView!
    @IBOutlet weak var movieDate: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieDuration: UILabel!
    @IBOutlet weak var movieReservationGrade: UILabel!
    @IBOutlet weak var movieReservationRate: UILabel!
    @IBOutlet weak var movieUserRating: UILabel!
    @IBOutlet weak var movieUserRatingStar: CosmosView!
    @IBOutlet weak var movieAudienceCount: UILabel!
    
    func configure(movieDetail: MovieDetail?) {
        movieTitle.text = movieDetail?.title
        movieGenre.text = movieDetail?.genre
        
        if  let duration = movieDetail?.duration,
            let grade = movieDetail?.reservationGrade,
            let rate = movieDetail?.reservationRate,
            let rating = movieDetail?.userRating,
            let audience = movieDetail?.audience,
            let date = movieDetail?.date {
            
            movieDuration.text = "\(duration)분"
            movieReservationGrade.text = "\(grade)위"
            movieReservationRate.text = "\(rate)%"
            movieUserRating.text = String(rating)
            movieAudienceCount.text = audience.convertNumberToDecimalFormatter()
            movieDate.text = "\(date)개봉"
            
            let startCount: Double = StarCount(rating: rating).getStartCount()
            
            movieUserRatingStar.settings.updateOnTouch = false
            movieUserRatingStar.rating = startCount
        }
        
        let gradeImageType: String
        
        switch movieDetail?.grade {
        case 0: gradeImageType = "ic_12"
        case 12: gradeImageType = "ic_15"
        case 15: gradeImageType = "ic_19"
        case 19: gradeImageType = "ic_allages"
        default: gradeImageType = "ic_allages"
        }
        
        movieGrade.image = UIImage(named: gradeImageType)
        movieImage.image = UIImage(named: "img_placeholder")
        movieImage.isUserInteractionEnabled = true        
    }
}
