//
//  RegisterComment.swift
//  5_BoxOffice
//
//  Created by byungtak on 2018. 9. 24..
//  Copyright © 2018년 byungtak. All rights reserved.
//

import Foundation

let DidReceiveCommentResponseNotification: Notification.Name = Notification.Name("DidReceiveCommentResponse")

func registerComment(id: String?, nickname: String, comment: String, rating: Double) {
    guard let url: URL = URL(string: Constants.baseUrl + "comment") else {
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
    
    let session: URLSession = URLSession(configuration: .default)
    
    let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
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
            
            NotificationCenter.default.post(name: DidReceiveCommentResponseNotification, object: nil, userInfo: ["status": Constants.success])
            return
        }
        
        NotificationCenter.default.post(name: DidReceiveCommentResponseNotification, object: nil, userInfo: ["status": Constants.failure])
    }
    
    dataTask.resume()
    
}















