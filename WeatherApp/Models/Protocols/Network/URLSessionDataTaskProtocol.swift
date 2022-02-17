//
//  URLSessionDataTaskProtocol.swift
//  WeatherApp
//
//  Created by Sébastien Kothé on 16/02/2022.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
