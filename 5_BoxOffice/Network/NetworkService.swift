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
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorView.Style.gray)
    
    private init() {
        if let window = UIApplication.shared.keyWindow {
            activityIndicator.center = window.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            window.addSubview(activityIndicator)
        }
    }

    public func fetchData(url: URL, completion: @escaping (Any) -> ()) {
        activityIndicator.startAnimating()
        session.dataTask(with: url) {[weak self] (data, response, error) in
            guard let data = data, self = self else {
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
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }.resume()
    }
    
    public func fetchImage(imageURL: URL, completion: @escaping (UIImage, Int) -> ()) {
        activityIndicator.startAnimating()
        session.dataTask(with: imageURL) { [weak self] (data, response, error) in
            guard let data = data,
                let image = UIImage(data: data),
                let self = self else { return }
            
            DispatchQueue.main.async {
                completion(image, data.count)
                self.activityIndicator.stopAnimating()
            }
        }.resume()
    }
    
    public func postData(request: URLRequest, completion: @escaping (Any) -> ()) {
        activityIndicator.startAnimating()
        session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data, self = self else {
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
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }.resume()
    }
}

