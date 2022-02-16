//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Sébastien Kothé on 15/02/2022.
//

import Foundation

struct WeatherResponse: Codable {
    let weather: [Weather]
    let main: WeatherInformation
    let name: String
}

struct Weather: Codable {
    let description: String
    let icon: String
}

struct WeatherInformation: Codable {
    let temp: Double
}
