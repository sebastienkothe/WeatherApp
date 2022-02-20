//
//  ViewController.swift
//  WeatherApp
//
//  Created by Sébastien Kothé on 15/02/2022.
//

import UIKit
import CoreLocation

class WeatherVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var weatherInfo: UILabel!
    @IBOutlet weak var weatherDescriptionIV: UIImageView!
    
    // MARK: - IBActions
    @IBAction func updatePositionBtnTapped() {
        
        // Used to manage devices that have location service disabled or non-existent
        guard CLLocationManager.locationServicesEnabled() else {
            handleError(.locationServiceDisabled)
            return
        }
        
        // Get the user location
        geolocationProvider.getUserLocation()
    }
    
    // MARK: - Internal methods
    override func viewDidLoad() {
        super.viewDidLoad()
        geolocationProvider.delegate = self
        geolocationProvider.getUserLocation()
    }
    
    // MARK: - Private properties
    private let geolocationProvider = GeolocationProvider()
    private let weatherNetworkManager = WeatherNetworkManager()
    
    // MARK: - Private methods
    
    /// Used to handle errors
    private func handleError(_ error: NetworkError) {
        let alert = UIAlertController(title: .error, message: error.title, preferredStyle: .alert)
        let action = UIAlertAction(title: .okay, style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension WeatherVC: WeatherDelegate {
    func didChangeLocation(longitude: String, latitude: String) {
        weatherNetworkManager.fetchWeatherInformationForUserLocation(longitude: longitude, latitude: latitude, completion: { [weak self] (result) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let weatherResponse):
                    guard let weather = weatherResponse.weather.first else { return }
                    self.view.backgroundColor = weather.icon.contains("d") ? #colorLiteral(red: 0.9490196078, green: 0.768627451, blue: 0.3450980392, alpha: 1) : #colorLiteral(red: 0.4196078431, green: 0.5450980392, blue: 0.7098039216, alpha: 1)
                    var icon = weather.icon
                    if !["01", "10", "02"].contains(where: { icon.contains($0) }) { icon.removeLast() }
            
                    self.weatherDescriptionIV.image = UIImage(named: icon)
                    self.weatherInfo.text = weather.description.capitalizingFirstLetter()
                    self.cityNameLbl.text = weatherResponse.name.count == 0 ? .unknownPlace : weatherResponse.name
                    self.tempLbl.text = "\(Int(weatherResponse.main.feels_like))" + .degreeSymbol
                case .failure(let error):
                    self.handleError(error)
                }
            }
        })
    }
}
