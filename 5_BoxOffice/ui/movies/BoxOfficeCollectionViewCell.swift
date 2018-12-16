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
}
