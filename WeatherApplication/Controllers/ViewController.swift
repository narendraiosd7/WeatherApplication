//
//  ViewController.swift
//  WeatherApplication
//
//  Created by UW-IN-LPT0108 on 4/1/23.
//

import UIKit

class ViewController: BaseViewController {

    @IBOutlet var weatherView: WeatherView!
    
    let viewModel = CityViewModel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getWeather(for: "Hyderabad")
    }
    
    func configureUI() {
        weatherView.delegate = self
        weatherView.dataSource = self
    }
    
    private func configureViewModel() {
        // Showing loading indicator or hiding loading indicator
        viewModel.showLoadingIndicator = { [weak self] showLoader in
            DispatchQueue.main.async {
                showLoader ? self?.showActivityIndicatorOverlayViewAnimated() : self?.hideActivityIndicatorOverlayViewAnimated()
            }
        }
        
        // Showing alert message
        viewModel.showAlert = { [weak self] (title, message) in
            self?.showAlertView(alertTitle: title, alertMessage: message)
        }
        
        viewModel.weatherDataSuccess = { [weak self] _ in
            self?.weatherView.updateUI()
        }
    }
    
    fileprivate func isValid(_ city:String) -> Bool {
        return city.range(of: "^(?=.{2,100}$)[A-Za-zÀ-ú][A-Za-zÀ-ú.'-]+(?: [A-Za-zÀ-ú.'-]+)* *$", options: .regularExpression) != nil
    }
}

extension ViewController: WeatherViewDelegate {
    func getWeather(for city: String) {
        if isValid(city) {
            viewModel.getWeather(for: city)
        } else {
            showAlertView(alertTitle: "Invalid City", alertMessage: "Please enter the valid city")
        }
    }
}

extension ViewController: WeatherViewDataSource {
    var pressureTitle: String {
        "Pressure"
    }
    
    var pressureDescription: String {
        "\(viewModel.weather?.main?.pressure ?? 0)"
    }
    
    var humidityTitle: String {
        "Humidity"
    }
    
    var humidityDescription: String {
        "\(viewModel.weather?.main?.humidity ?? 0)"
    }
    
    var windTitle: String {
        "Wind Speed"
    }
    
    var windDescription: String {
        "\(viewModel.weather?.wind?.speed ?? 0)"
    }
    
    var visibilityTitle: String {
        "Visibility"
    }
    
    var visibilityDescription: String {
        "\(viewModel.weather?.visibility ?? 0)"
    }
    
    var temperature: String {
        "\(viewModel.weather?.main?.temp ?? 0)°"
    }
    
    var cityName: String {
        "\(viewModel.weather?.name ?? ""), \(viewModel.weather?.sys?.country ?? "")"
    }
    
    var weatherDescription: String {
        viewModel.weather?.weather?.first?.description ?? ""
    }
    
    var highTemperature: String {
        "\(viewModel.weather?.main?.tempMax ?? 0)°"
    }
    
    var lowTemperature: String {
        "\(viewModel.weather?.main?.tempMin ?? 0)°"
    }
    
    var imageURL: String {
        viewModel.weather?.weather?.first?.iconURL ?? ""
    }
}

