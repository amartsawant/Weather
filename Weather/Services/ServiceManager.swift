//
//  ServiceManager.swift
//  Weather
//
//  Created by Amar Sawant on 18/11/20.
//  Copyright © 2020 atsawant.com. All rights reserved.
//

import Foundation

typealias completionHandler = ((Data?, Error?) -> Void)

class ServiceManager {
    
    func featchRemoteData(with url: String, completion: @escaping completionHandler) -> Void {
        
        if let requestUrl = URL(string: url) {
            debugPrint(requestUrl)
            var urlRequest = URLRequest(url: requestUrl)
            urlRequest.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
               
                guard let data = data, error == nil else {
                    // Error scenario
                    debugPrint("error: \(String(describing: error))")
                    completion(nil, error)
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    // Success scenario
                    let responseString = String("response: \(String(describing: response))")
                    debugPrint(responseString)
                    let customError = AppError.code(httpStatus.statusCode)
                    completion(nil, customError)
                } else {
                    // Failure scenario
                    completion(data, error)
                }
            }
            dataTask.resume()
        } else {
            // Bad request
            let customError = AppError.httpInvalidRequest
            completion(nil, customError)
        }
    }
}
