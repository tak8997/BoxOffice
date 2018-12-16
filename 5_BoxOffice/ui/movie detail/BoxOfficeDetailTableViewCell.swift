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
}
