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
//    @IBOutlet weak var movieUserRatingStar: CosmosView!
    @IBOutlet weak var movieAudienceCount: UILabel!
    
    func configure(movieDetail: MovieDetail?, tapGestureRecognizer: UITapGestureRecognizer) {
        self.movieTitle.text = movieDetail?.title
        self.movieGenre.text = movieDetail?.genre
        
        if  let duration = movieDetail?.duration,
            let grade = movieDetail?.reservationGrade,
            let rate = movieDetail?.reservationRate,
            let rating = movieDetail?.userRating,
            let audience = movieDetail?.audience,
            let date = movieDetail?.date {
            
            self.movieDuration.text = "\(duration)분"
            self.movieReservationGrade.text = "\(grade)위"
            self.movieReservationRate.text = "\(rate)%"
            self.movieUserRating.text = String(rating)
            self.movieAudienceCount.text = audience.convertNumberToDecimalFormatter()
            self.movieDate.text = "\(date)개봉"
            
            let startCount: Double = StarCount(rating: rating).getStartCount()
            
//            self.movieUserRatingStar.settings.updateOnTouch = false
//            self.movieUserRatingStar.rating = startCount
        }
        
        self.movieGrade.image = UIImage(named: MovieGrade(rawValue: movieDetail?.grade ?? 12)?.movieGrade ?? "")
        self.movieImage.image = UIImage(named: "img_placeholder")
        self.movieImage.isUserInteractionEnabled = true
  
        BoxOfficeService.fetchImage(imageURL: movieDetail?.image ?? "") { (image) in
            self.movieImage.image = image
            self.movieImage.addGestureRecognizer(tapGestureRecognizer)
        }
    }
}
