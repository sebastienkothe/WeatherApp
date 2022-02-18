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
    @IBOutlet weak var weatherInfoStackView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
    
    /// Used to hide items
    private func toggleActivityIndicator<T: UIView>(shown: Bool, activityIndicator: UIActivityIndicatorView, view: T) {
        activityIndicator.isHidden = !shown
        view.isHidden = shown
    }
}

extension WeatherVC: WeatherDelegate {
    func didChangeLocation(longitude: String, latitude: String) {
        weatherNetworkManager.fetchWeatherInformationForUserLocation(longitude: longitude, latitude: latitude, completion: { [weak self] (result) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.toggleActivityIndicator(shown: false, activityIndicator: self.activityIndicator, view: self.weatherInfoStackView)
                
                switch result {
                case .success(let weatherResponse):
                    self.cityNameLbl.text = weatherResponse.name.count == 0 ? .unknownPlace : weatherResponse.name
                    self.tempLbl.text = "\(Int(weatherResponse.main.temp))" + .whiteSpace + .celsiusDegreeSymbol
                case .failure(let error):
                    self.handleError(error)
                }
            }
        })
    }
}
