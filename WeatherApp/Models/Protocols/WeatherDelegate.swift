//
//  WeatherDelegate.swift
//  WeatherApp
//
//  Created by Sébastien Kothé on 15/02/2022.
//

import Foundation

protocol WeatherDelegate: AnyObject {
    func didChangeLocation(longitude: String, latitude: String)
}
