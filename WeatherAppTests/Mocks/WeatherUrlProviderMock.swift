//
//  WeatherUrlProviderMock.swift
//  WeatherAppTests
//
//  Created by Sébastien Kothé on 16/02/2022.
//

import Foundation
@testable import WeatherApp

class WeatherUrlProviderMock: WeatherUrlProviderProtocol {
    
    // MARK: - Internal methods
    func buildIconURL(iconName: String) -> URL? {
        return nil
    }
    
    func buildOpenWeatherUrl(longitude: String, latitude: String) -> URL? {
        return nil
    }
}
