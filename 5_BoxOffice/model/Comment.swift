//
//  Comments.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 16..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import Foundation

//{
//    rating: 10,
//    timestamp: 1515748870.80631,
//    writer: "두근반 세근반",
//    movie_id: "5a54c286e8a71d136fb5378e",
//    contents:"정말 다섯 번은 넘게 운듯 ᅲᅲᅲ 감동 쩔어요.꼭 보셈 두 번 보셈"
//}

struct MovieCommentsApiResponse: Codable {
    let comments: [Comment]
    
    enum CodingKeys: String, CodingKey {
        case comments
    }
}

struct Comment: Codable {
    
    let rating: Double
    let timestamp: Double
    let writer: String
    let movieId: String
    let contents: String
    
    enum CodingKeys: String, CodingKey {
        case rating, timestamp, writer, contents
        case movieId = "movie_id"
    }
    
    init(contents: String, movieId: String, rating: Double, timestamp: Double, writer: String) {
        self.contents = contents
        self.movieId = movieId
        self.rating = rating
        self.timestamp = timestamp
        self.writer = writer
    }
}
