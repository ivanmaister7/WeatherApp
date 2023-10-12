//
//  WeatherDetailsViewController.swift
//  WeatherApp
//
//  Created by Master on 09.10.2023.
//

import UIKit

class WeatherDetailsViewController: UIViewController {
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var avarageTempLabel: UILabel!
    
    var forecast = Day(maxtemp_c: 0,
                       mintemp_c: 0,
                       avgtemp_c: 0,
                       maxwind_kph: 0,
                       condition: Condition(text: "", icon: "", code: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.avarageTempLabel.text = "\(Int(forecast.avgtemp_c))"
        self.minTempLabel.text = "\(Int(forecast.mintemp_c))"
        self.maxTempLabel.text = "\(Int(forecast.maxtemp_c))"
        self.windLabel.text = "\(forecast.maxwind_kph)"
        self.conditionLabel.text = forecast.condition.text
        if let image = ForecastViewCell.weatherImage(for: forecast.condition) {
            self.weatherImage.image = image
        }
    }
    
}
