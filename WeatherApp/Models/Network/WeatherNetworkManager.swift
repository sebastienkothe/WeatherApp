//
//  WeatherNetworkManager.swift
//  WeatherApp
//
//  Created by Sébastien Kothé on 15/02/2022.
//

import Foundation

final class WeatherNetworkManager {
    
    // MARK: - Initializer
    
    /// Used to be able to perform dependency injection
    init(
        networkManager: NetworkManager = NetworkManager(),
        weatherUrlProvider: WeatherUrlProviderProtocol = WeatherURLProvider()
    ) {
        self.networkManager = networkManager
        self.weatherUrlProvider = weatherUrlProvider
    }
    
    // MARK: - Internal methods
    
    /// Used to get weather information based on the user's current location
    func fetchWeatherInformationForUserLocation(longitude: String, latitude: String, completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        
        guard let url = weatherUrlProvider.buildOpenWeatherUrl(longitude: longitude, latitude: latitude) else {
            completion(.failure(.failedToCreateURL))
            return
        }
        
        networkManager.fetch(url: url, completion: completion)
    }
    
    // MARK: - Private properties
    private let networkManager: NetworkManager
    private let weatherUrlProvider: WeatherUrlProviderProtocol
}
