//
//  MapService.swift
//  MetroMap
//
//  Created by Роман Мисников on 01.06.2018.
//  Copyright © 2018 Роман Мисников. All rights reserved.
//

import Foundation
import Alamofire

typealias MetroModelComplitionHandler = (MetroModel?, MapServiceError?)->()

enum MapServiceError: Error {
    case urlError
    case requestError
    case response200Error
    case jsonParsingError
    case dataError
    
}

class MapService {
    func loadMapData(complition: @escaping MetroModelComplitionHandler) {
        // get url constant
        let urlPath = URL_METRO_MAP
        // create URL
        guard let url = URL(string: urlPath) else {
            complition(nil, MapServiceError.urlError)
            return
        }
        // make request with url
        Alamofire.request(url).responseData { (response) in
            // safety checks
            guard response.error == nil else {
                complition(nil, MapServiceError.requestError)
                return
            }
            guard response.response?.statusCode == 200 else {
                complition(nil, MapServiceError.response200Error)
                return
            }
            guard let data = response.data else {
                complition(nil, MapServiceError.dataError)
                return
            }
            
            // JSON parsing
            do {
                // create decoder
                let decoder = JSONDecoder()
                // use decoder
                let metroMap = try decoder.decode(MetroModel.self, from: data)
                // in case of success - return parsed object
                complition(metroMap, nil)
                
            } catch {
                complition(nil, MapServiceError.jsonParsingError)
            }
            
        }
        
    }
}
