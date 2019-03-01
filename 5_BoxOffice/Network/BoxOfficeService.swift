//
//  BoxOfficeService.swift
//  5_BoxOffice
//
//  Created by byungtak on 15/12/2018.
//  Copyright © 2018 byungtak. All rights reserved.
//

import Foundation
import UIKit

class BoxOfficeService {
    
    static let shared = BoxOfficeService()
    
    private init() { }
    
    private let baseUrl = "http://connect-boxoffice.run.goorm.io/"
    
    private var cachedMovies: [String : [Movie]] = [:]
    private var cachedMovie: [String : MovieDetail] = [:]
    private var cachedComments: [String: [Comment]] = [:]
    
    private var imageURL: URL?
    
    private var diskPath: String {
        let diskPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let cacheDirectory = diskPaths[0] as NSString
        let rtnPath = cacheDirectory.appendingPathComponent("\(String(describing: self.imageURL?.absoluteString.hashValue))")
        
        return rtnPath
    }

    func fetchMovies(orderType: String, completion: @escaping ([Movie]) -> Void, errorHandler: @escaping () -> Void) {
        guard let url: URL = URL(string: baseUrl + "movies?order_type=" + orderType) else {
            errorHandler()
            return
        }
        
        if let movies = cachedMovies[orderType] {
            print("movie list local cache")
            completion(movies)
            return
        }
        
        NetworkService.shared.fetchData(url: url, completion: { [weak self] (json) in
            guard let self = self else { return }
            
            do {
                let response = try MoviesApiResponse(json: json)
                
                self.cachedMovies[orderType] = response.movies
                
                completion(response.movies)
            } catch {
                errorHandler()
            }
        }) { errorHandler() }
    }
    
    func fetchMovieDetail(movieId: String, completion: @escaping (MovieDetail) -> Void, errorHandler: @escaping () -> Void) {
        guard let url: URL = URL(string: baseUrl + "movie?id=" + movieId) else {
            errorHandler()
            return
        }
        
        if let movie = cachedMovie[movieId] {
            print("movie detail local cache")
            completion(movie)
            return
        }
        
        NetworkService.shared.fetchData(url: url, completion: { [weak self] (json) in
            guard let self = self else { return }
            
            do {
                let response = try MovieDetailApiResponse(json: json)
                
                self.cachedMovie[movieId] = response.movie
                
                completion(response.movie)
            } catch {
                errorHandler()
            }
        }) { errorHandler() }
    }
    
    func fetchMovieComment(movieId: String, completion: @escaping ([Comment]) -> Void, errorHandler: @escaping () -> Void) {
        guard let url: URL = URL(string: baseUrl + "comments?movie_id=" + movieId) else {
            errorHandler()
            return
        }
        
        if let comments = cachedComments[movieId] {
            print("comments local cache \(comments.count)")
            completion(comments)
            return
        }
        
        NetworkService.shared.fetchData(url: url, completion: { [weak self] (json) in
            guard let self = self else { return }
            
            do {
                let response = try MovieCommentsApiResponse(json: json)
                
                self.cachedComments[movieId] = response.comments
                
                completion(response.comments)
            } catch {
                errorHandler()
            }
        }) { errorHandler() }
    }
    
    func fetchImage(imageURL: String, completion: @escaping (UIImage) -> Void) {
        guard let imageURL = URL(string: imageURL) else { return }
        
        if let cachedImage = ImageCache.shared.object(forKey: imageURL.absoluteString as NSString) {
            completion(cachedImage)
            return
        } else {
            self.imageURL = imageURL
            
            if FileManager.default.fileExists(atPath: diskPath) {
                if let image = UIImage(contentsOfFile: diskPath) {
                    completion(image)
                    print("disk cache")
                    return
                }
            }
        }
        
        NetworkService.shared.fetchImage(imageURL: imageURL) { (image, dataCount) in
            ImageCache.shared.setObject(
                image,
                forKey: imageURL.absoluteString as NSString,
                cost: dataCount
            )
            
            completion(image)
        }
    }
    
    func registerMovieComment(id: String?, nickname: String, comment: String, rating: Double,
                              completion: @escaping(NetworkStatus) -> Void,
                              errorHandler: @escaping () -> Void) {
        guard
            let url: URL = URL(string: baseUrl + "comment"),
            let id: String = id else {
            errorHandler()
            return
        }
        
        let parameterDictionary = ["rating": rating, "writer": nickname, "movie_id": id, "contents": comment] as [String : Any]
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            errorHandler()
            return
        }
        
        request.httpBody = httpBody
        
        NetworkService.shared.postData(request: request, completion: { (json) in
            completion(NetworkStatus.success)
        }) { errorHandler() }
    }
    
}
