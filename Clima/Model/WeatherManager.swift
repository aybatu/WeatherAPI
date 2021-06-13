//
//  WeatherManager.swift
//  Clima
//
//  Created by Aybatu Kerkukluoglu on 3.06.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func weatherModel(weatherModel: WeatherModel)
    func didGetError(error: Error)
}

struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    
  
    
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=a727d69ff1b788b51d469623a5753d62&units=metric&lang=tr"
        performRequest(url: url)
    }
    
    func fetchWeather(with city: String) {
       let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=a727d69ff1b788b51d469623a5753d62&units=metric&lang=tr"
        
        performRequest(url: url)
    }
    
    func performRequest(url: String) {
        if let urlString = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: urlString) { data, response, error in
                if error != nil {
                    print("Error task: \(error!)")
                } else {
                    if let dataSafe = data {
                        if let weatherData = parseJSON(data: dataSafe) {
                            let cityName = weatherData.name
                            let temperature = weatherData.main.temp
                            let conditionID = weatherData.weather[0].id
                            let description = weatherData.weather[0].description
                            
                            let weatherModel = WeatherModel(cityName: cityName, weatherDescription: description, conditionID: conditionID, temp: temperature)
                            
                            delegate?.weatherModel(weatherModel: weatherModel)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(data: Data) -> WeatherData? {
        let decoder = JSONDecoder()
        do{
            let dataAll = try decoder.decode(WeatherData.self, from: data)
            return dataAll
        } catch {
            delegate?.didGetError(error: error)
            return nil
        }
    }
    
    func didGetError(error: Error) {
        
    }
}
