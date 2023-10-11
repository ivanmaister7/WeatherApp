//
//  WeatherAppWidjetService.swift
//  WeatherAppWidgetExtension
//
//  Created by Master on 11.10.2023.
//

import Foundation
import Combine
import Alamofire

struct WeatherResponce: Codable {
    static var placeholder: Self {
        if let storage = UserDefaults(suiteName: "group.ivanmaister.weatherapp"),
           let savedData = storage.data(forKey: "lastSessionWeatherData") {
            if let loadedWeatherData = try? JSONDecoder().decode(WeatherResponce.self, from:savedData) {
                return loadedWeatherData
            }
        }
        return WeatherResponce(location:
                                Location(name: NSLocalizedString("No location", comment: ""),
                                         country: NSLocalizedString("No country", comment: ""),
                                         lat: 0,
                                         lon: 0),
                               current: Current(temp_c: 0,
                                                feelslike_c: 0,
                                                wind_kph: 0,
                                                condition: Condition(text: "-",
                                                                     icon: "",
                                                                     code: 0)))
    }
    
    let location: Location
    let current: Current
}

// MARK: - Location
struct Location: Codable {
    let name, country: String
    let lat, lon: Double
}

// MARK: - Current
struct Current: Codable {
    let temp_c, feelslike_c, wind_kph: Double
    let condition: Condition
}

// MARK: - Condition
struct Condition: Codable {
    let text, icon: String
    let code: Int
}

struct Parameters: Codable {
    let q: String
    let key: String
    var days: Int
    var lang: String
    
    init(q: String, key: String = "84aaefc410e74b45aa2101435230910", days: Int = 1, lang: String = "") {
        self.q = q
        self.key = key
        self.days = days
        self.lang = lang
    }
}

class WeatherAppWidgetService {
    func getCurrentWeather(from url: String,
                                   parameters: Parameters,
                                   complition: @escaping (DataResponse<WeatherResponce, AFError>) -> ()) {
        AF
            .request(url,
                     method: .get,
                     parameters: parameters)
            .responseDecodable(of: WeatherResponce.self, completionHandler: complition)
    }
    
}
