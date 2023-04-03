//
//  APIService.swift
//  WeatherApplication
//
//  Created by UW-IN-LPT0108 on 4/2/23.
//

import Foundation
import Combine

protocol APIService {
    
    /// To create the API request resource
    /// - Returns: APIRequestResourceProtocol
    func resource() -> APIRequestResourceProtocol
    
    /// To construct the url request
    /// - Parameter timeOut: timeout interval
    /// - Returns: url request
    func URLRequest(timeOut: Double) -> NSMutableURLRequest?
}

extension APIService {
    
    /// Getting Resource
    /// - Returns: APIRequestResourceProtocol
    func resource() -> APIRequestResourceProtocol {
        return APIRequestResource()
    }
    
    /// URL request
    /// - Parameter timeOut: Double
    /// - Returns: NSMutableURLRequest?
    func URLRequest(timeOut: Double = 0) -> NSMutableURLRequest? {
        let resource = self.resource()
        return NetworkManager.requestForURL(resource.url, timeOut: timeOut)
    }
    
    /// Method to create a url request, initialize the network session and performing athenticated request
    /// - Parameters:
    ///   - timeOut: timeout interval
    ///   - type: response model type
    /// - Returns: Response model or Error
    func request<T>(timeOut: Double = 0, type: T.Type) -> AnyPublisher<T, Error> where T : Decodable {
        guard let request = URLRequest(timeOut: timeOut) else {
            return Fail(error: APIError.urlNotFound)
                .eraseToAnyPublisher()
        }
        let session = URLSession.shared
        let manager = NetworkManager.init(session: session)
        return manager.performRequest(url: request as URLRequest, type: type)
    }
}
