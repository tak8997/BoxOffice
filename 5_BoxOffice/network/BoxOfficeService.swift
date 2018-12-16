//
//  BoxOfficeService.swift
//  5_BoxOffice
//
//  Created by byungtak on 15/12/2018.
//  Copyright © 2018 byungtak. All rights reserved.
//

import Foundation


class BoxOfficeService {
    
    private static let baseUrl = "http://connect-boxoffice.run.goorm.io/"
    
    private static var movies: [String : [Movie]] = [:]
    private static var movie: [String : MovieDetail] = [:]
    private static var comments: [String: [Comment]] = [:]
    
    static func fetchMovies(orderType: String, completion: @escaping([Movie]) -> ()) {
        guard let url: URL = URL(string: baseUrl + "movies?order_type=" + orderType) else {
            return
        }
        
        if let movies = movies[orderType] {
            print("movie list local cache")
            completion(movies)
            return
        }
        
        NetworkService.shared.fetchData(url: url) { (json) in
            
            do {
                let response = try MoviesApiResponse(json: json)
                
                self.movies[orderType] = response.movies
                
                completion(response.movies)
            } catch {
                NotificationCenter.default.post(name: networkErrorNotificationName, object: nil)
                print(error)
            }
        }
    }
    
    static func fetchMovieDetail(movieId: String, completion: @escaping(MovieDetail) -> ()) {
        guard let url: URL = URL(string: baseUrl + "movie?id=" + movieId) else {
            return
        }
        
        if let movie = movie[movieId] {
            print("movie detail local cache")
            completion(movie)
            return
        }
        
        NetworkService.shared.fetchData(url: url) { (json) in
            
            do {
                let response = try MovieDetailApiResponse(json: json)
                
                self.movie[movieId] = response.movie
                
                completion(response.movie)
            } catch {
                NotificationCenter.default.post(name: networkErrorNotificationName, object: nil)
                print(error)
            }
        }
    }
    
    static func fetchMovieComment(movieId: String, completion: @escaping([Comment]) -> ()) {
        guard let url: URL = URL(string: baseUrl + "comments?movie_id=" + movieId) else {
            return
        }
        
        if let comments = comments[movieId] {
            print("comments local cache \(comments.count)")
            completion(comments)
            return
        }
        
        NetworkService.shared.fetchData(url: url) { (json) in
            
            do {
                let response = try MovieCommentsApiResponse(json: json)
                
                self.comments[movieId] = response.comments
                
                completion(response.comments)
            } catch {
                NotificationCenter.default.post(name: networkErrorNotificationName, object: nil)
                print(error)
            }
        }
    }
    
    static func registerMovieComment(id: String?, nickname: String, comment: String, rating: Double, completion: @escaping(NetworkStatus) -> ()) {
        guard let url: URL = URL(string: baseUrl + "comment") else {
            return
        }
        
        guard let id: String = id else {
            return
        }
        
        let parameterDictionary = ["rating": rating, "writer": nickname, "movie_id": id, "contents": comment] as [String : Any]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        NetworkService.shared.postData(request: request) { (json) in
            completion(NetworkStatus.success)
        }
    }
    
}
