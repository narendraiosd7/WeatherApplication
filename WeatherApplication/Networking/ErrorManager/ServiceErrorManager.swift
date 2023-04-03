//
//  ServiceErrorManager.swift
//  WeatherApplication
//
//  Created by UW-IN-LPT0108 on 4/2/23.
//

import Foundation

struct ServiceError: Decodable, Error {
    let errors: [ServiceErrorMessage]
}

enum ServiceErrorMessage: String, Decodable, Error {
    case invalid = "invalid"
}
