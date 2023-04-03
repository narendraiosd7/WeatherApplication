//
//  CityViewModel.swift
//  WeatherApplication
//
//  Created by UW-IN-LPT0108 on 4/1/23.
//

import Foundation
import Combine

final class CityViewModel {
    private var cancellables: [AnyCancellable] = []
    var showLoadingIndicator: ((Bool) -> Void)?
    var showAlert: ((String, String) -> Void)?
    var weatherDataSuccess: ((Bool) -> Void)?
    var weather: WeatherResponse?

    func getWeather(for city: String) {
        self.showLoadingIndicator?(true)
        DataSourceManager.sharedManager.getWether(for: city)
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                switch value {
                case .failure(let error):
                    if let error = error as? APIError {
                        self?.showAlert?("Error", error.errorMessage)
                    } else {
                        self?.showAlert?("Error", error.localizedDescription)
                    }
                    self?.showLoadingIndicator?(false)
                case .finished:
                    self?.showLoadingIndicator?(false)
                }
            } receiveValue: { [weak self] responseData in
                self?.weather = responseData
                self?.weatherDataSuccess?(true)
            }
            .store(in: &cancellables)
    }
    
}
