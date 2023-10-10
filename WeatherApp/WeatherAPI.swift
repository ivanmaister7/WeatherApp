//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Master on 10.10.2023.
//

import Foundation
import Alamofire
import Combine

class WeatherAPI {
    static let shared = WeatherAPI()
    let key = "84aaefc410e74b45aa2101435230910"
    let baseUrl = "https://api.weatherapi.com/v1/"
    
    func fetchCurrentWeather(for city: String) -> AnyPublisher<WeatherResponce, Never> {
        print("Fetch data for: \(city)")
        let parameters = Parameters(q: city, key: key)
        return fetchData(from: baseUrl + "current.json", parameters: parameters)
    }
    
    func fetchForecast(for city: String) -> AnyPublisher<WeatherResponce, Never> {
        let parameters = Parameters(q: city, key: key, days: 7)
        return fetchData(from: baseUrl + "forecast.json", parameters: parameters)
    }
    
    private func fetchData(from url: String,
                           parameters: Parameters) -> AnyPublisher<WeatherResponce, Never> {
        AF
            .request(url,
                     method: .get,
                     parameters: parameters)
            .validate()
            .publishDecodable(type: WeatherResponce.self)
            .compactMap { elem in
                if let encoded = try? JSONEncoder().encode(elem.value) {
                    UserDefaults.standard.set(encoded, forKey: "lastSessionWeatherData")
                }
                return elem.value
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

//            .responseDecodable(of: ) { responce in
//                if let data = responce.value {
//                    responcePublisher = Just(data).eraseToAnyPublisher()
//                }
//            }
