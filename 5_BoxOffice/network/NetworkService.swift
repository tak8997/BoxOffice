//
//  NetworkService.swift
//  5_BoxOffice
//
//  Created by byungtak on 15/12/2018.
//  Copyright © 2018 byungtak. All rights reserved.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    private init() { }

    public func fetchData(url: URL, completion: @escaping (Any) -> ()) {
        
        let session = URLSession.shared
        
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
    
    public func postData(request: URLRequest, completion: @escaping (Any) -> ()) {
        
        let session = URLSession.shared
        
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
                    return
                }
            } catch {
                NotificationCenter.default.post(name: networkErrorNotificationName, object: nil)
                print(error)
            }
        }.resume()
    }
}
