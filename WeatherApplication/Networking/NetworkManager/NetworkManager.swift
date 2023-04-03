//
//  NetworkManager.swift
//  WeatherApplication
//
//  Created by UW-IN-LPT0108 on 4/1/23.
//

import Foundation
import Combine

protocol NetworkSession: AnyObject {
    
    /// Method to return a publisher that wraps a URL session data task for a given URL request.
    /// - Parameters:
    ///   - urlRequest: The URL request for which to create a data task.
    ///   - token: token
    ///   - isNoResponseDataModel: Indicates response model is needed or not
    /// - Returns: A publisher that wraps a data task for the URL request
    func publisher(for urlRequest: URLRequest) -> AnyPublisher<Data, Error>
}

extension URLSession: NetworkSession {
    
    func publisher(for urlRequest: URLRequest) -> AnyPublisher<Data, Error> {
        return dataTaskPublisher(for: urlRequest)
            .tryMap({ result in
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    let error = try JSONDecoder().decode(ServiceError.self, from: result.data)
                    throw error
                }
                
                if httpResponse.statusCode == 200 {
                    // Handle the case, if service response is success with statusCode 200, but there is no response data
                    // And also if response is no longer needed in view model
                    // Use NoResponseData.json file to send the dummy response data to view model
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: result.data, options: .allowFragments)
                        if jsonResponse is String {
                            let jsonData: NSData
                            do {
                                jsonData = try JSONSerialization.data(withJSONObject: self.convertAStringToJSON(serviceResponse: jsonResponse as! String), options: JSONSerialization.WritingOptions()) as NSData
                                return jsonData as Data
                            } catch _ {
                                print ("String conversion to JSON Failure")
                            }
                        }
                    } catch let error {
                        print(error)
                    }
                    
                    // Default response
                    return result.data
                } else {
                    let responseObject = try JSONSerialization.jsonObject(with: result.data, options: JSONSerialization.ReadingOptions()) as? JSONDictionary
                    var error: Error? = nil
                    switch (httpResponse.statusCode) {
                    case 404:
                        error = APIError.invalidRequest
                    case 409:
                        error = APIError.service(statusCode: httpResponse.statusCode, response: responseObject)
                    default:
                        error = APIError.UnexpectedTechnicalError(statusCode: httpResponse.statusCode, response: responseObject)
                    }
                    throw error ?? APIError.UnexpectedTechnicalError(statusCode: httpResponse.statusCode)
                }
            })
            .eraseToAnyPublisher()
    }
    
    func convertAStringToJSON(serviceResponse: String) -> [String:Any]{
        return ["url":serviceResponse]
    }
}


private let timeoutInterval = 60.0

struct NetworkManager {
    private let session: NetworkSession
    
    ///  Initialize the network session
    /// - Parameter session: url session
    init(session: NetworkSession = URLSession.shared) {
      self.session = session
    }
  
    func performRequest<T>(url: URLRequest, type: T.Type) -> AnyPublisher<T, Error> where T: Decodable {
        return session.publisher(for: url)
            .share()
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    /// Method for constructing the url request
    /// - Parameters:
    ///   - urlString: url string
    ///   - method: http method
    ///   - params: http body
    ///   - headers: headers
    ///   - timeOut: timeout interval
    /// - Returns: URLRequest
    static func requestForURL(_ urlString: String, timeOut: Double = 0) -> NSMutableURLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        let timeoutIntervalEx = (timeOut == 0 ? timeoutInterval : timeOut)
        return NSMutableURLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutIntervalEx)
    }
}
