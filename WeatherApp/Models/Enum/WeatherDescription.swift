//
//  WeatherDescription.swift
//  WeatherApp
//
//  Created by Sébastien Kothé on 18/02/2022.
//

import Foundation

enum WeatherDescription: String, CaseIterable {
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case scatteredClouds = "scattered clouds"
    case brokenClouds = "broken clouds"
    case showerRain = "shower rain"
    case rain, thunderstorm, snow, mist
    
    var truncatedDescription: String {
        switch self {
        case .clearSky: return "sun"
        case .fewClouds, .scatteredClouds, .brokenClouds: return "clouds"
        case .showerRain: return "rain"
        case .rain, .thunderstorm, .snow, .mist: return rawValue
        }
    }
}
