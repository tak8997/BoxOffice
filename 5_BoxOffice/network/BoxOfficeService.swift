//
//  BoxOfficeService.swift
//  5_BoxOffice
//
//  Created by byungtak on 15/12/2018.
//  Copyright © 2018 byungtak. All rights reserved.
//

import Foundation


class BoxOfficeService {
    
    private let baseUrl = "http://connect-boxoffice.run.goorm.io/"
    
    static func fetchMovies(orderType: String, completion: @escaping(MoviesApiResponse) -> ()) {
        guard let url: URL = URL(string: Constants.baseUrl + "movies?order_type=" + orderType) else {
            return
        }
        
        NetworkService.shared.fetchData(url: url) { (json) in
            
            do {
                let response = try MoviesApiResponse(json: json)
                
                completion(response)
            } catch {
                print(error)
            }
        }
    }
    
    
    
}
