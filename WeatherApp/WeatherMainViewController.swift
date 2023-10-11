//
//  WeatherMainViewController.swift
//  WeatherApp
//
//  Created by Master on 09.10.2023.
//

import UIKit
import Combine

struct WeatherResponce: Codable {
    static var placeholder: Self {
        if let savedData = UserDefaults.standard.data(forKey: "lastSessionWeatherData") {
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
                                                              code: 0)),
                        forecast: nil)
    }
    
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
    var days: Int
    var lang: String
    
    init(q: String, key: String, days: Int = 1, lang: String = "") {
        self.q = q
        self.key = key
        self.days = days
        self.lang = lang
    }
}

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }
}

class WeatherMainViewController: UIViewController {
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var titleParentView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var forecastTable: UITableView!
    
    private let vm = WeatherViewModel()
    private var cancellableSet = Set<AnyCancellable>()
    var data: [Forecastday] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forecastTable.dataSource = self
        forecastTable.delegate = self
        
        forecastTable.backgroundColor = .clear
        titleParentView.backgroundColor = .clear
        searchField.alpha = 0.35
        searchField.textColor = .gray
        forecastTable.keyboardDismissMode = .onDrag
        
        searchField.textPublisher
            .assign(to: \.city, on: vm)
            .store(in: &cancellableSet)
        
        vm.$currentWeather
            .sink(receiveValue: { [weak self] currentWeather in
                guard let self else { return }
                self.cityLabel.text = currentWeather.location.name
                self.conditionLabel.text = currentWeather.current.condition.text
                self.temperatureLabel.text = "\(Int(currentWeather.current.temp_c))"
            })
            .store(in: &cancellableSet)
        vm.$currentForecast
            .sink(receiveValue: { [weak self] currentForecast in
                guard let self else { return }
                self.data = currentForecast.forecast?.forecastday ?? []
                self.forecastTable.reloadData()
            })
            .store(in: &cancellableSet)
    }
    
}
extension WeatherMainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! ForecastViewCell
        
        cell.configureView(data: data[indexPath.row])
        
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
