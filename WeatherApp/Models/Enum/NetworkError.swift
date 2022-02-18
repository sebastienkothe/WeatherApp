//
//  NetworkError.swift
//  WeatherApp
//
//  Created by Sébastien Kothé on 15/02/2022.
//

import Foundation

enum NetworkError: Error, CaseIterable {
    case unknownError
    case failedToDecodeJSON
    case noData
    case failedToCreateURL
    case incorrectHttpResponseCode
    case locationServiceDisabled
    
    var title: String {
        switch self {
        case .unknownError: return "Unknown Error"
        case .failedToDecodeJSON: return "Cannot decode JSON"
        case .noData: return "No data recovered"
        case .failedToCreateURL: return "Cannot create URL"
        case .incorrectHttpResponseCode: return "Incorrect HTTP response code"
        case .locationServiceDisabled: return "The location service is disabled"
        }
    }
}
