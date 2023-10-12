//
//  WeatherAppWidjetService.swift
//  WeatherAppWidgetExtension
//
//  Created by Master on 11.10.2023.
//

import Foundation
import Combine
import Alamofire

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
