//
//  WeatherService.swift
//  WeatherApplication
//
//  Created by UW-IN-LPT0108 on 4/1/23.
//

import Foundation
import Combine

enum WeatherService: APIService {
    case getWeatherFor(_ city: String)
    
    func resource() -> APIRequestResourceProtocol {
        var resource = APIRequestResource()
        
        switch self {
        case .getWeatherFor(let city):
            let searchCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            resource.url = WeatherAPIProvider.url(service: .getWeatherFor(searchCity))
        }
        
        return resource
    }
}
