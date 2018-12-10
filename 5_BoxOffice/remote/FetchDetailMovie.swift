//
//  FetchMovie.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 22..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import Foundation

let DidReceiveMovieDetailNotification: Notification.Name = Notification.Name("DidReceiveMovieDetail")

func fetchDetailMovie(movieId: String) {
    guard let url: URL = URL(string: Constants.baseUrl + "movie?id=" + movieId) else {
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
            let movieDetailApiResponse: MovieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
            
            NotificationCenter.default.post(name: DidReceiveMovieDetailNotification, object: nil, userInfo: ["movieDetail" : movieDetailApiResponse])
        } catch(let err) {
            print("fetchmoviedetail_jsondecoder_error:\(err.localizedDescription)")
            
            NotificationCenter.default.post(name: getNetworkErrorNotification(), object: nil)
        }
    }
    
    dataTask.resume()
}


