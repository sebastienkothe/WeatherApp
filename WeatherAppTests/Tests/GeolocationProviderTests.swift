//
//  GeolocationProviderTests.swift
//  WeatherAppTests
//
//  Created by Sébastien Kothé on 18/02/2022.
//

import XCTest
import CoreLocation
@testable import WeatherApp

class GeolocationProviderTestCase: XCTestCase {
    var geolocationProvider: GeolocationProvider!
    var geolocationProviderDelegateMock: GeolocationProviderDelegateMock!
    
    override func setUp() {
        geolocationProvider = GeolocationProvider()
        geolocationProviderDelegateMock = GeolocationProviderDelegateMock()
        geolocationProvider.delegate = geolocationProviderDelegateMock
    }
    
    func testGivenCoordinatesAreDefined_WhenPassingThemInDidUpdateLocations_ThenLongitudeAndLatitudeMustChangeValue() {
        
        // Given
        let coordinates = [
            CLLocation(latitude: 42.69925982345143, longitude: 2.9457234900883487)
        ]
        
        // When
        geolocationProvider.locationManager(CLLocationManager(), didUpdateLocations: coordinates)
        
        // Then
        XCTAssertEqual(geolocationProviderDelegateMock.latitude, "42.69925982345143")
        XCTAssertEqual(geolocationProviderDelegateMock.longitude, "2.9457234900883487")
    }
    
    func testGivenGetUserLocationWasStarted_WhenTyingToCheckIfDelegatePropertyIsEmpty_ThenTheTestShouldFail() {
        
        // Given
        geolocationProvider.getUserLocation()
        
        // Then
        XCTAssertNotNil(geolocationProvider.delegate)
    }
}
