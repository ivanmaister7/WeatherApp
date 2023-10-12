//
//  WeatherMainViewController.swift
//  WeatherApp
//
//  Created by Master on 09.10.2023.
//

import UIKit
import Combine



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
    
    @IBOutlet weak var currentWeatherImage: UIImageView!
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
                
                if let image = ForecastViewCell.weatherImage(for: currentWeather.current.condition) {
                    self.currentWeatherImage.image = image
                }
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
            nextPost.forecast = data[selectedRow].day
        }
    }
}
