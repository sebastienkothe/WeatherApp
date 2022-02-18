//
//  GeolocationProvider.swift
//  WeatherApp
//
//  Created by Sébastien Kothé on 15/02/2022.
//

import CoreLocation

final class GeolocationProvider: NSObject, CLLocationManagerDelegate {
    
    // MARK: - Internal properties
    weak var delegate: WeatherDelegate?
    
    // MARK: - Internal methods
    
    /// Used to get the user's current position
    func getUserLocation() {
        locationManager = CLLocationManager()
        
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.allowsBackgroundLocationUpdates = false
        
        locationManager?.startUpdatingLocation()
    }
    
    /// Used to handle the user's current position
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Used to prevent heavy battery usage
        locationManager?.stopUpdatingLocation()
        
        if let location = locations.last {
            
            // Converting coordinates to String
            let latitudeAsString = String(location.coordinate.latitude)
            let longitudeAsString = String(location.coordinate.longitude)
            
            delegate?.didChangeLocation(longitude: longitudeAsString, latitude: latitudeAsString)
        }
    }
    
    // MARK: - Private properties
    private var locationManager: CLLocationManager?
}

