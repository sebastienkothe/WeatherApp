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
    @IBOutlet weak var gifIV: UIImageView!
    
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
    private let giphyNetworkManager = GiphyNetworkManager()
    
    private var fetchedWeatherData: WeatherResponse? {
        didSet {
            
        }
    }
    
    // MARK: - Private methods
    
    /// Used to handle errors
    private func handleError(_ error: NetworkError) {
        let alert = UIAlertController(title: "ERROR", message: error.title, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    /// Used to hide items
    private func toggleActivityIndicator(shown: Bool, activityIndicator: UIActivityIndicatorView, stackView: UIStackView) {
        activityIndicator.isHidden = !shown
        stackView.isHidden = shown
    }
}

extension WeatherVC: WeatherDelegate {
    func didChangeLocation(longitude: String, latitude: String) {
        weatherNetworkManager.fetchWeatherInformationForUserLocation(longitude: longitude, latitude: latitude, completion: { [weak self] (result) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.toggleActivityIndicator(shown: false, activityIndicator: self.activityIndicator, stackView: self.weatherInfoStackView)
                
                switch result {
                case .success(let weatherResponse):
                    self.fetchedWeatherData = weatherResponse
                    self.cityNameLbl.text = weatherResponse.name == "" ? .unknownPlace : weatherResponse.name
                    self.tempLbl.text = "\(Int(weatherResponse.main.temp))" + " " + .celsiusDegreeSymbol
                case .failure(let error):
                    self.handleError(error)
                }
            }
        })
    }
}

