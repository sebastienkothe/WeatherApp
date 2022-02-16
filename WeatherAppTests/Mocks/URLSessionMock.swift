//
//  URLSessionMock.swift
//  WeatherAppTests
//
//  Created by Sébastien Kothé on 16/02/2022.
//

import Foundation
@testable import WeatherApp

class URLSessionMock: URLSessionProtocol {
    
    // MARK: - Initializer
    init(completionHandler: (Data?, URLResponse?, Error?)) {
        self.completionHandler = completionHandler
    }
    
    // MARK: - Internal methods
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        completionHandler(
            self.completionHandler.0,
            self.completionHandler.1,
            self.completionHandler.2
        )
        return dataTask
    }
    
    // MARK: - Private properties
    private let dataTask = URLSessionDataTaskMock()
    private let completionHandler: (Data?, URLResponse?, Error?)
}
