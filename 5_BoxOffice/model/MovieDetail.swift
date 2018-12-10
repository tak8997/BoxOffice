//
//  MovieDetail.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 22..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import Foundation

//{
//    audience: 11676822,
//    grade: 12,
//    actor: "하정우(강림), 차태현(자홍), 주지훈(해원맥), 김향기(덕춘)",
//    duration: 139,
//    reservation_grade: 1,
//    title: "신과함께-죄와벌",
//    reservation_rate: 35.5,
//    user_rating: 7.98,
//    date: "2017-12-20",
//    director: "김용화",
//    id: "5a54c286e8a71d136fb5378e",
//    image: "http://movie.phinf.naver.net/20171201_181/1512109983114kcQVl_JPEG/movi
//    e_image.jpg",
//    synopsis: "저승 법에 의하면, (중략) 고난과 맞닥뜨리는데... 누구나 가지만 아무도 본 적 없는 곳, 새로
//    운 세계의 문이 열린다!", genre: "판타지, 드라마"
//}
struct MovieDetail: Codable {
    let audience: Int
    let grade: Int
    let actor: String
    let duration: Int
    let reservationGrade: Int
    let title: String
    let reservationRate: Double
    let userRating: Double
    let date: String
    let director: String
    let id: String
    let image: String
    let synopsis: String
    let genre: String
    
    enum CodingKeys: String, CodingKey {
        case audience, grade, actor, duration, title, date, director, id, image, synopsis, genre
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }
}
