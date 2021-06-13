//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var weatherManager = WeatherManager()
    var location = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        location.delegate = self
        searchTextField.delegate = self
        weatherManager.delegate = self
        
        
        location.requestWhenInUseAuthorization()
        location.requestLocation()
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        if searchTextField.text != "" {
            weatherManager.fetchWeather(with: searchTextField.text!)
        } else {
            searchTextField.placeholder = "Invalid input"
        }
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        location.requestLocation()
    }
    
}

//MARK: - TextField Delegate

extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        weatherManager.fetchWeather(with: searchTextField.text!)
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Invalid input"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
        textField.placeholder = "Search"
    }
}

//MARK: - WeatherManager Delegate

extension WeatherViewController: WeatherManagerDelegate {
    func weatherModel(weatherModel: WeatherModel) {
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: weatherModel.conditionString)
            self.temperatureLabel.text = weatherModel.tempString
            self.cityLabel.text = weatherModel.cityName
            self.descriptionLabel.text = weatherModel.weatherDescription
        }
    }
    
    func didGetError(error: Error) {
        print(error)
    }
}
//MARK: - Location Delegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(lat: lat, lon: lon)
        }

    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
