//
//  WeatherAPIProvider.swift
//  WeatherApplication
//
//  Created by UW-IN-LPT0108 on 4/1/23.
//

import Foundation

struct WeatherAPIProvider {
    
    /// To get the different service URL based on service type
    /// - Parameter service: Service type
    /// - Returns: Service url
    static func url(service: WeatherService) -> String {
        var serviceUrl = API.baseURLString
        
        switch service {
        case .getWeatherFor(let city):
            serviceUrl = serviceUrl + "weather?q=\(city)&appid=\(API.key)&units=imperial"
        }
        return serviceUrl
    }
}
