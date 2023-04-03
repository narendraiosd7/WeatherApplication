//
//  WeatherView.swift
//  WeatherApplication
//
//  Created by UW-IN-LPT0108 on 4/2/23.
//

import UIKit
import QuartzCore

protocol WeatherViewDelegate: AnyObject {
    func getWeather(for city: String)
}

protocol WeatherViewDataSource: AnyObject {
    var temperature: String { get }
    var cityName: String { get }
    var weatherDescription: String { get }
    var highTemperature: String { get }
    var lowTemperature: String { get }
    var imageURL: String { get }
    var pressureTitle: String { get }
    var pressureDescription: String { get }
    var humidityTitle: String { get }
    var humidityDescription: String { get }
    var windTitle: String { get }
    var windDescription: String { get }
    var visibilityTitle: String { get }
    var visibilityDescription: String { get }
}

class WeatherView: UIView {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var searchBarContainer: UIView!
    @IBOutlet weak var searchBarTitleLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var weatherDetailsContainer: UIView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var highTemperatureLabel: UILabel!
    @IBOutlet weak var lowTemperatureLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var windContainer: UIView!
    @IBOutlet weak var windIcon: UIImageView!
    @IBOutlet weak var windTitleLabel: UILabel!
    @IBOutlet weak var windDescription: UILabel!
    @IBOutlet weak var visibilityView: UIView!
    @IBOutlet weak var visibilityIcon: UIImageView!
    @IBOutlet weak var visibilityTitleLabel: UILabel!
    @IBOutlet weak var visibilityDescription: UILabel!
    @IBOutlet weak var humidityView: UIView!
    @IBOutlet weak var humidutyTitleLabel: UILabel!
    @IBOutlet weak var humidutyDescription: UILabel!
    @IBOutlet weak var pressureView: UIView!
    @IBOutlet weak var pressureIcon: UIImageView!
    @IBOutlet weak var pressureTitleLabel: UILabel!
    @IBOutlet weak var pressureDescriptionLabel: UILabel!
    @IBOutlet weak var humidityIcon: UIImageView!
    
    
    weak var delegate: WeatherViewDelegate?
    weak var dataSource: WeatherViewDataSource?
    
    var weather: WeatherResponse?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabelColors()
        defaultSetup()
        setupFontForLabels()
        setupRoundedCornersAndShadowToViews()
    }
    
    private func setupLabelColors() {
        searchBarTitleLabel.textColor = .white
        temperatureLabel.textColor = .white
        descriptionLabel.textColor = .white
        highTemperatureLabel.textColor = .white
        lowTemperatureLabel.textColor = .white
        cityNameLabel.textColor = .white
        searchTextField.textColor = .white
        humidutyTitleLabel.textColor = .white
        humidutyDescription.textColor = .white
        pressureTitleLabel.textColor = .white
        pressureDescriptionLabel.textColor = .white
        visibilityTitleLabel.textColor = .white
        visibilityDescription.textColor = .white
        windTitleLabel.textColor = .white
        windDescription.textColor = .white
    }
    
    private func setupFontForLabels() {
        cityNameLabel.font = .systemFont(ofSize: 24, weight: .heavy)
        temperatureLabel.font = .systemFont(ofSize: 36, weight: .bold)
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .medium)
        highTemperatureLabel.font = .systemFont(ofSize: 14, weight: .medium)
        lowTemperatureLabel.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    private func setupRoundedCornersAndShadowToViews() {
        weatherDetailsContainer.setupRoundedCornersAndShadow()
        windContainer.setupRoundedCornersAndShadow()
        visibilityView.setupRoundedCornersAndShadow()
        humidityView.setupRoundedCornersAndShadow()
        pressureView.setupRoundedCornersAndShadow()
    }
    
    private func defaultSetup() {
        searchBarTitleLabel.text = "Check the weather by the City"
        cityNameLabel.text = ""
        temperatureLabel.text = ""
        descriptionLabel.text = ""
        highTemperatureLabel.text = ""
        lowTemperatureLabel.text = ""
        windTitleLabel.text = ""
        windDescription.text = ""
        visibilityTitleLabel.text = ""
        visibilityDescription.text = ""
        pressureTitleLabel.text = ""
        pressureDescriptionLabel.text = ""
        humidutyTitleLabel.text = ""
        humidutyDescription.text = ""
    }
    
    func updateUI() {
        temperatureLabel.text = dataSource?.temperature ?? ""
        descriptionLabel.text = dataSource?.weatherDescription ?? ""
        highTemperatureLabel.text = "H: \(dataSource?.highTemperature ?? "")"
        lowTemperatureLabel.text = "L: \(dataSource?.lowTemperature ?? "")"
        cityNameLabel.text = dataSource?.cityName ?? ""
        iconImageView.downloaded(from: dataSource?.imageURL ?? "")
        windTitleLabel.text = dataSource?.windTitle ?? ""
        windDescription.text = dataSource?.windDescription ?? ""
        visibilityTitleLabel.text = dataSource?.visibilityTitle ?? ""
        visibilityDescription.text = dataSource?.visibilityDescription ?? ""
        pressureTitleLabel.text = dataSource?.pressureTitle ?? ""
        pressureDescriptionLabel.text = dataSource?.pressureDescription ?? ""
        humidutyTitleLabel.text = dataSource?.humidityTitle ?? ""
        humidutyDescription.text = dataSource?.humidityDescription ?? ""
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        let city = searchTextField.text ?? ""
        delegate?.getWeather(for: city)
    }
}
