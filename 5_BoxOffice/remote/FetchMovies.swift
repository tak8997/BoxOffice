//
//  Request.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 9..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import Foundation


let DidReceiveMoviesNotification: Notification.Name = Notification.Name("DidReceiveMovies")

func fetchMovies(orderType: String) {
    guard let url: URL = URL(string: Constants.baseUrl + "movies?order_type=" + orderType) else {
        return
    }
    
    let session: URLSession = URLSession(configuration: .default)
    
    let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
        if let error = error {
            print("data_task_error: \(error.localizedDescription)")
            
            NotificationCenter.default.post(name: getNetworkErrorNotification(), object: nil)
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            print("status_code: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode != 200 {
                NotificationCenter.default.post(name: getNetworkErrorNotification(), object: nil)
                return
            }
        }
        
        guard let data = data else {
            return
        }
        
        do {
            let moviesApiResponse: MoviesApiResponse = try JSONDecoder().decode(MoviesApiResponse.self, from: data)
            
            NotificationCenter.default.post(name: DidReceiveMoviesNotification, object: nil, userInfo: ["movies" : moviesApiResponse.movies])
        } catch(let err) {
            print("moviesjsondecoder_error:\(err.localizedDescription)")
            
            NotificationCenter.default.post(name: getNetworkErrorNotification(), object: nil)
        }
    }
    
    dataTask.resume()
}
