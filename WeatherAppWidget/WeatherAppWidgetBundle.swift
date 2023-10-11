//
//  WeatherAppWidgetBundle.swift
//  WeatherAppWidget
//
//  Created by Master on 11.10.2023.
//

import WidgetKit
import SwiftUI

@main
struct WeatherAppWidgetBundle: WidgetBundle {
    var body: some Widget {
        WeatherAppWidget()
        WeatherAppWidgetLiveActivity()
    }
}
