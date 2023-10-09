//
//  WeatherDetailsViewController.swift
//  WeatherApp
//
//  Created by Master on 09.10.2023.
//

import UIKit

class WeatherDetailsViewController: UIViewController {
    @IBOutlet weak var infoLabel: UILabel!
    
    var info = "info"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.infoLabel.text = info
    }
    
}
