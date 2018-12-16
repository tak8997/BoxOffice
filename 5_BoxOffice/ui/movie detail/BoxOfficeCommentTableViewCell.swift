//
//  BoxOfficeCommentTableViewCell.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 17..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import UIKit
import Cosmos

//rating: 10,
//timestamp: 1515748870.80631,
//writer: "두근반 세근반",
//movie_id: "5a54c286e8a71d136fb5378e",
//contents:"정말 다섯 번은
class BoxOfficeCommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var userRatingStar: CosmosView!
    @IBOutlet weak var userCommentDate: UILabel!
    @IBOutlet weak var userComment: UILabel!
    
    func configure(comment: Comment) {
        let date = Date(timeIntervalSince1970: comment.timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strDate = dateFormatter.string(from: date)
        
        let starCount = StarCount(rating: comment.rating).getStartCount()
        
        userId.text = comment.writer
        userCommentDate.text = strDate
        userComment.text = comment.contents
        userRatingStar.rating = starCount
        userRatingStar.settings.updateOnTouch = false
    }
}
