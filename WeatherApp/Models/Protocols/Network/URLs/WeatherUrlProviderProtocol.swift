//
//  WeatherUrlProviderProtocol.swift
//  WeatherApp
//
//  Created by Sébastien Kothé on 15/02/2022.
//

import Foundation

protocol WeatherUrlProviderProtocol {
    func buildOpenWeatherUrl(longitude: String, latitude: String) -> URL?
}
