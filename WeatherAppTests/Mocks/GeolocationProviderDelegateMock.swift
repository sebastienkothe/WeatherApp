//
//  GeolocationProviderDelegateMock.swift
//  WeatherAppTests
//
//  Created by Sébastien Kothé on 18/02/2022.
//

import Foundation
@testable import WeatherApp

class GeolocationProviderDelegateMock: WeatherDelegate {
    
    var latitude: String?
    var longitude: String?
    
    func didChangeLocation(longitude: String, latitude: String) {
        self.longitude = longitude
        self.latitude = latitude
    }
}
