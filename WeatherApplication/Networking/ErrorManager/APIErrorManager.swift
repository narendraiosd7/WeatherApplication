//
//  APIErrorManager.swift
//  WeatherApplication
//
//  Created by UW-IN-LPT0108 on 4/1/23.
//

import Foundation


typealias JSONDictionary = [String: Any]
private let domainName = "com.networkmanager.error"

enum APIError: Error {
    case networkError(statusCode: Int, response: JSONDictionary? = nil)
    case unknown(unknown: String, response: JSONDictionary? = nil)
    case urlNotFound
    case invalidRequest
    case dataLoading(statusCode: Int, data: Data, response: JSONDictionary? = nil)
    case service(statusCode: Int, response: JSONDictionary? = nil)
    case UnexpectedTechnicalError(statusCode: Int, response: JSONDictionary? = nil)
        
    var errorMessage: String {
        var message = ""
        
        switch self {
        case .networkError:
            message = "Please verify you have an internet connection and try this operation again."
        case .unknown:
            message = "unknown"
        case .urlNotFound:
            message = "URL not found"
        case .invalidRequest:
            message = "Invalid City"
        case .service:
            message = "Sorry, we couldn't interpret server's response."
            if let dict: JSONDictionary = self.serverResponse, let msg = dict["error_description"] as? String {
                message = msg
            }
        case .UnexpectedTechnicalError:
            message = "An unexpected technical error occurred while processing this request. Please try request again or contact support for assistance."
        case .dataLoading:
            message = "Data loading error"
        }
        return message
    }
    
    var errorTitle: String {
        var title = ""
        
        switch self {
        case .networkError:
            title = "No Internet Connection"
        case .unknown:
            title = "Unknown error"
        case .urlNotFound:
            title = "URL not found"
        case .invalidRequest:
            title = "Invalid request"
        case .service:
            title = "Service error"
        case .UnexpectedTechnicalError:
            title = "Unexpected Error"
        case .dataLoading:
            title = "Dataloading Error"
        }
        return title
    }
        
    var errorDomain: String {
        var domain = domainName
        
        switch self {
        case .networkError, .urlNotFound, .invalidRequest:
            domain = "Connection Error"
        case .UnexpectedTechnicalError:
            domain = "Server Error"
        case .service:
            domain = "No Data"
        case .unknown, .dataLoading:
            domain = "Parse Error"
        }
        return domain
    }
    
    var code: Int {
        var errorCode: Int = 0

        switch self {
        case .networkError(let statusCode,_):
            errorCode = statusCode
        case .UnexpectedTechnicalError(let statusCode,_):
            errorCode = statusCode
        case .service(let statusCode,_):
            errorCode = statusCode
        default:
            break
        }
        return errorCode
    }
    
    var error: Error {
        return NSError(domain: domainName, code: code, userInfo: [ NSLocalizedDescriptionKey: errorMessage ] )
    }
    
    var serverResponse: JSONDictionary? {
        switch self {
        case .networkError(_, let response), .UnexpectedTechnicalError(_, let response), .service(_, let response), .unknown(_, let response), .dataLoading(_,_, let response):
            return response
        default:
        return nil
        }
    }
}
