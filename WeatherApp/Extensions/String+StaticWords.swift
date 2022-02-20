//
//  String+.swift
//  WeatherApp
//
//  Created by Sébastien Kothé on 17/02/2022.
//

import Foundation

extension String {
    static let unknownPlace = "Unknown place"
    static let degreeSymbol = "°"
    
    static let error = "ERROR"
    static let okay = "Okay"
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
