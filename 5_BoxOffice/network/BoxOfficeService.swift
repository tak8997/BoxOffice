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
    
    static func fetchMovies(orderType: String, completion: @escaping(MoviesApiResponse) -> ()) {
        guard let url: URL = URL(string: baseUrl + "movies?order_type=" + orderType) else {
            return
        }
        
        NetworkService.shared.fetchData(url: url) { (json) in
            
            do {
                let response = try MoviesApiResponse(json: json)
                
                completion(response)
            } catch {
                NotificationCenter.default.post(name: networkErrorNotificationName, object: nil)
                print(error)
            }
        }
    }
    
    static func fetchMovieDetail(movieId: String, completion: @escaping(MovieDetailApiResponse) -> ()) {
        guard let url: URL = URL(string: baseUrl + "movie?id=" + movieId) else {
            return
        }
        
        NetworkService.shared.fetchData(url: url) { (json) in
            
            do {
                let movieDetailApiResponse = try MovieDetailApiResponse(json: json)
                
                completion(movieDetailApiResponse)
            } catch {
                NotificationCenter.default.post(name: networkErrorNotificationName, object: nil)
                print(error)
            }
        }
    }
    
    static func fetchMovieComment(movieId: String, completion: @escaping(MovieCommentsApiResponse) -> ()) {
        guard let url: URL = URL(string: baseUrl + "comments?movie_id=" + movieId) else {
            return
        }
        
        NetworkService.shared.fetchData(url: url) { (json) in
            
            do {
                let movieCommentsApiResponse = try MovieCommentsApiResponse(json: json)
                
                completion(movieCommentsApiResponse)
            } catch {
                NotificationCenter.default.post(name: networkErrorNotificationName, object: nil)
                print(error)
            }
        }
    }
    
    static func registerMovieComment(id: String?, nickname: String, comment: String, rating: Double, completion: @escaping(Int) -> ()) {
        
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
            print("zzz")
            completion(Constants.success)
        }
    }
    
}
