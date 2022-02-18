//
//  ViewController.swift
//  WeatherApp
//
//  Created by Sébastien Kothé on 15/02/2022.
//

import UIKit
import CoreLocation
import FLAnimatedImage

class WeatherVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var weatherInfoStackView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var gifIV: FLAnimatedImageView!
    
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
    
    private func runTheGiphyAPIRequest(weatherResponse: WeatherResponse) {
        guard let weatherDescription = weatherResponse.weather.first?.description, let shortWeatherDescription = WeatherDescription.allCases.filter({ $0.rawValue == weatherDescription }).first?.truncatedDescription else { return }
        
        self.giphyNetworkManager.fetchJSONDataFromGiphyAPI(from: shortWeatherDescription) { [weak self] result in
            switch result {
            case .success(let giphyResponse):
                guard let gifURLAsString = giphyResponse.data.first?.images.downsized.url else { return }
                self?.fetchGifFrom(gifURLAsString)
            case.failure(let networkError):
                self?.handleError(networkError)
            }
        }
    }
    
    private func fetchGifFrom(_ gifURLAsString: String) {
        giphyNetworkManager.getGifFrom(gifURLAsString) { [weak self] gif in
            guard let gif = gif else {
                self?.handleError(.unableToCreateImageFromData)
                return
            }
            
            DispatchQueue.main.async {
                self?.gifIV.animatedImage = gif
            }
        }
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
                    self.runTheGiphyAPIRequest(weatherResponse: weatherResponse)
                    self.cityNameLbl.text = weatherResponse.name.count == 0 ? .unknownPlace : weatherResponse.name
                    self.tempLbl.text = "\(Int(weatherResponse.main.temp))" + .whiteSpace + .celsiusDegreeSymbol
                case .failure(let error):
                    self.handleError(error)
                }
            }
        })
    }
}
