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
                print(error)
            }
        }.resume()
    }
    
}
