//
//  WeatherMainViewController.swift
//  WeatherApp
//
//  Created by Master on 09.10.2023.
//

import UIKit
import Alamofire

struct WeatherResponce: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast?
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
    var days = 1
}

class WeatherMainViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var forecastTable: UITableView!
    
    var data: [Forecastday] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forecastTable.dataSource = self
        forecastTable.delegate = self
        
        var params = Parameters(q: "London", key: "84aaefc410e74b45aa2101435230910")
        AF
            .request("https://api.weatherapi.com/v1/current.json",
                     method: .get,
                     parameters: params)
            .responseDecodable(of: WeatherResponce.self) { responce in
                if let data = responce.value {
                    self.cityLabel.text = data.location.name
                    self.conditionLabel.text = data.current.condition.text
                    self.temperatureLabel.text = "\(Int(data.current.temp_c))"
                }
            }
        params.days = 7
        AF
            .request("https://api.weatherapi.com/v1/forecast.json",
                     method: .get,
                     parameters: params)
            .responseDecodable(of: WeatherResponce.self) { responce in
                if let data = responce.value?.forecast?.forecastday {
                    self.data = data
                    print(data)
                    self.forecastTable.reloadData()
                }
            }
    }
    
}
extension WeatherMainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! ForecastViewCell
        cell.infoLabel.text = "\(data[indexPath.row].date) ± \(data[indexPath.row].day.avgtemp_c)"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = forecastTable.indexPathForSelectedRow{
            let selectedRow = indexPath.row
            let nextPost = segue.destination as! WeatherDetailsViewController
            nextPost.info = "\(data[selectedRow].date) ± \(data[selectedRow].day.avgtemp_c)"
        }
    }
}
