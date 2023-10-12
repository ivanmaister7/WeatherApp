//
//  WeatherResponce.swift
//  WeatherApp
//
//  Created by Master on 12.10.2023.
//

import Foundation

// MARK: - WeatherResponce
struct WeatherResponce: Codable {
    static var placeholder: Self {
        if let storage = UserDefaults(suiteName: "group.ivanmaister.weatherapp"),
           let savedData = storage.data(forKey: "lastSessionWeatherData") {
            if let loadedWeatherData = try? JSONDecoder().decode(WeatherResponce.self, from:savedData) {
                return loadedWeatherData
            }
        }
        return WeatherResponce(location: Location.placeholder,
                               current: Current.placeholder,
                               forecast: nil)
    }
    
    let location: Location
    let current: Current
    let forecast: Forecast?
}

// MARK: - Location
struct Location: Codable {
    static var placeholder: Self {
        Location(name: NSLocalizedString("No location", comment: ""),
                 country: NSLocalizedString("No country", comment: ""),
                 lat: 0,
                 lon: 0)
    }
    let name, country: String
    let lat, lon: Double
}

// MARK: - Current
struct Current: Codable {
    static var placeholder: Self {
        Current(temp_c: 0,
                feelslike_c: 0,
                wind_kph: 0,
                condition: Condition.placeholder)
    }
    
    let temp_c, feelslike_c, wind_kph: Double
    let condition: Condition
}

// MARK: - Condition
struct Condition: Codable {
    static var placeholder: Self {
        Condition(text: "-",
                  icon: "",
                  code: 0)
    }
    
    let text, icon: String
    let code: Int
}

// MARK: - Forecast
struct Forecast: Codable {
    let forecastday: [Forecastday]
}

// MARK: - Forecastday
struct Forecastday: Codable {
    let date: String
    let day: Day
    let hour: [Hour]
}

// MARK: - Day
struct Day: Codable {
    let maxtemp_c, mintemp_c: Double
    let avgtemp_c, maxwind_kph: Double
    let condition: Condition
}

// MARK: - Hour
struct Hour: Codable {
    let time: String
    let temp_c,wind_kph: Double
    let condition: Condition
    let uv: Int
}

struct Parameters: Codable {
    let q: String
    let key: String
    var days: Int
    var lang: String
    
    init(q: String, key: String, days: Int = 1, lang: String = "") {
        self.q = q
        self.key = key
        self.days = days
        self.lang = lang
    }
}
