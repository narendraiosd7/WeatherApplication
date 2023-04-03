//
//  DataSourceManager + GetWeather.swift
//  WeatherApplication
//
//  Created by UW-IN-LPT0108 on 4/2/23.
//

import Foundation
import Combine

extension DataSourceManager {
    
    func getWether(for city: String) -> AnyPublisher<WeatherResponse, Error> {
        return WeatherService.getWeatherFor(city).request(type: WeatherResponse.self)
    }
}
