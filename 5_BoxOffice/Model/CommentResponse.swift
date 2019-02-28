//
//  CommentResponse.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 24..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import Foundation


struct CommentResponse: Codable {
    let contents: String
    let movieId: String
    let rating: Double
    let timestamp: Double
    let writer: String
    
    init(contents: String, movieId: String, rating: Double, timestamp: Double, writer: String) {
        self.contents = contents
        self.movieId = movieId
        self.rating = rating
        self.timestamp = timestamp
        self.writer = writer
    }
    
    enum CodingKeys: String, CodingKey {
        case rating, timestamp, writer, contents
        case movieId = "movie_id"
    }
}
