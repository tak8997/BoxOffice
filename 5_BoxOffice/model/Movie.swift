//
//  movie.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 9..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import Foundation
//
//{
//    "movies": [
//    {
//    "reservation_rate": 61.69,
//    "grade": 15,
//    "title": "꾼",
//    "date": "2017-11-22",
//    "thumb": "http://movie2.phinf.naver.net/20171107_251/1510033896133nWqxG_JPEG/movie_image.jpg?type=m99_141_2",
//    "user_rating": 6.4,
//    "id": "5a54be21e8a71d136fb536a1",
//    "reservation_grade": 6
//    },


//    {
//    "reservation_rate": 12.63,
//    "grade": 12,
//    "title": "저스티스 리그",
//    "date": "2017-11-15",
//    "thumb": "http://movie2.phinf.naver.net/20170925_296/150631600340898aUX_JPEG/movie_image.jpg?type=m99_141_2",
//    "reservation_grade": 2,
//    "user_rating": 7.8,
//    "id": "5a54c1e9e8a71d136fb5376c"
//    },

//struct MoviesApiResponse: Codable {
//    let movies: [Movie]
//
//    enum CodingKeys: String, CodingKey {
//        case movies
//    }
//}

struct MoviesApiResponse: Codable {
 
    typealias JSON = [String: AnyObject]
    
    let movies: [Movie]
    
    init(json: Any) throws {
        guard
            let json = json as? JSON,
            let array = json["movies"] as? [JSON] else {
                
            throw NetworkError.internetError
        }
        
        var movies = [Movie]()
        
        for dictionary in array {
            guard let movie = Movie(dict: dictionary) else {
                continue
            }
            
            movies.append(movie)
        }
        
        self.movies = movies
    }
}

struct Movie: Codable {
    let grade: Int
    let thumb: String
    let reservationGrade: Int  //영화등급
    let title: String
    let reservationRate: Double
    let userRating: Double
    let date: String
    let id: String
    
    init?(dict: [String: AnyObject]) {
        guard
            let grade = dict["grade"] as? Int,
            let thumb = dict["thumb"] as? String,
            let reservationGrade = dict["reservation_grade"] as? Int,
            let title = dict["title"] as? String,
            let reservationRate = dict["reservation_rate"] as? Double,
            let userRating = dict["user_rating"] as? Double,
            let date = dict["date"] as? String,
            let id = dict["id"] as? String else {
                
            return nil
        }
        
        self.grade = grade
        self.thumb = thumb
        self.reservationGrade = reservationGrade
        self.title = title
        self.reservationRate = reservationRate
        self.userRating = userRating
        self.date = date
        self.id = id
    }
    
//    enum CodingKeys: String, CodingKey {
//        case grade, thumb, title, date, id
//        case reservationGrade = "reservation_grade"
//        case reservationRate = "reservation_rate"
//        case userRating = "user_rating"
//    }
}
