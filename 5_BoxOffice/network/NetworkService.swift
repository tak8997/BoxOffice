//
//  NetworkService.swift
//  5_BoxOffice
//
//  Created by byungtak on 15/12/2018.
//  Copyright © 2018 byungtak. All rights reserved.
//

import Foundation
import UIKit

class NetworkService {
    
    static let shared = NetworkService()
    
    private let session = URLSession.shared
    
    private init() { }

    public func fetchData(url: URL, completion: @escaping (Any) -> ()) {
        
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                DispatchQueue.main.async {
                    completion(json)
                }
            } catch {
                NotificationCenter.default.post(name: networkErrorNotificationName, object: nil)
                print(error)
            }
        }.resume()
    }
    
    public func fetchImage(imageURL: URL, completion: @escaping (UIImage, Int) -> ()) {
        
        session.dataTask(with: imageURL) { (data, response, error) in
            guard
                let data = data,
                let image = UIImage(data: data) else {
                    
                return
            }
            
            DispatchQueue.main.async {
                completion(image, data.count)
            }
        }.resume()
    }
    
    public func postData(request: URLRequest, completion: @escaping (Any) -> ()) {
        
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("status_code: \(httpResponse.statusCode)")
                    
                    if httpResponse.statusCode != 200 {
                        NotificationCenter.default.post(name: networkErrorNotificationName, object: nil)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        completion(json)
                    }
                }
            } catch {
                NotificationCenter.default.post(name: networkErrorNotificationName, object: nil)
                print(error)
            }
        }.resume()
    }
}
