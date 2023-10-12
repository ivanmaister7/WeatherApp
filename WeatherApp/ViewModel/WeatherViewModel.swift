//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Master on 10.10.2023.
//

import Foundation
import Combine

final class WeatherViewModel: ObservableObject {
    @Published var city: String = ""
    @Published var currentWeather: WeatherResponce = WeatherResponce.placeholder
    @Published var currentForecast: WeatherResponce = WeatherResponce.placeholder
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        $city
            .debounce(for: 2.0, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap {
                WeatherAPI.shared.fetchCurrentWeather(for: $0)
            }
            .assign(to: \.currentWeather, on: self)
            .store(in: &self.cancellableSet)
        
        $city
            .debounce(for: 2.0, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap {
                WeatherAPI.shared.fetchForecast(for: $0)
            }
            .assign(to: \.currentForecast, on: self)
            .store(in: &self.cancellableSet)
    }
    
}
