//
//  APIRequestResource.swift
//  WeatherApplication
//
//  Created by UW-IN-LPT0108 on 4/2/23.
//

import Foundation

protocol APIRequestResourceProtocol {
    var url: String { get set }
}

struct APIRequestResource: APIRequestResourceProtocol {
    var url: String = API.baseURLString
}
