//
//  WeatherURLProvider.swift
//  WeatherApp
//
//  Created by Sébastien Kothé on 15/02/2022.
//

import Foundation

class WeatherURLProvider: WeatherUrlProviderProtocol {
    
    // MARK: - Internal methods
    func buildOpenWeatherUrl(longitude: String, latitude: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/weather"
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: latitude),
            URLQueryItem(name: "lon", value: longitude),
            URLQueryItem(name: "appid", value: "abfbfbe13ce1ab4e9fbd6abee671f61f"),
            URLQueryItem(name: "units", value: "metric")
        ]
        return urlComponents.url
    }
}
