//
//  ForecastViewCell.swift
//  WeatherApp
//
//  Created by Master on 09.10.2023.
//

import UIKit

class ForecastViewCell: UITableViewCell {
    
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    let dateFormatter = DateFormatter()
    
    func configureView(data: Forecastday) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let components = Calendar.current.dateComponents([.month, .day],
                                                         from: dateFormatter.date(
                                                            from: data.date) ?? Date())
        self.dateLabel.text = "\(components.day ?? 0).\(components.month ?? 0)"
        self.windLabel.text    = "\(data.day.maxwind_kph)"
        self.minTempLabel.text = "\(Int(data.day.mintemp_c))"
        self.maxTempLabel.text = "\(Int(data.day.maxtemp_c))"
        if let image = ForecastViewCell.weatherImage(for: data.day.condition) {
            self.weatherImage.image = image
        }
    }
    
    static func weatherImage(for condition: Condition) -> UIImage? {
        var imageName = ""
        switch condition.code {
        case 1000:
            imageName = "sun.max.fill"
        case 1003:
            imageName = "cloud.sun.fill"
        case 1006:
            imageName = "cloud.fill"
        default:
            imageName = "cloud.rain.fill"
        }
        return UIImage(systemName: imageName)?.withRenderingMode(.alwaysOriginal)
    }
}
