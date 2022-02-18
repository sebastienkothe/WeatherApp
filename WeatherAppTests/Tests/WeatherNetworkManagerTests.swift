//
//  WeatherNetworkManagerTests.swift
//  WeatherAppTests
//
//  Created by Sébastien Kothé on 18/02/2022.
//

import Foundation

import XCTest
@testable import WeatherApp

class WeatherNetworkManagerTestCase: XCTestCase {
    
    private func loadJsonData(file: String) -> Data? {
        if let jsonFilePath = Bundle(for: type(of: self)).path(forResource: file, ofType: "json") {
            let jsonFileURL = URL(fileURLWithPath: jsonFilePath)
            if let jsonData = try? Data(contentsOf: jsonFileURL) {
                return jsonData
            }
        }
        return nil
    }
    
    private func createMockSession(fromJsonFile file: String, andStatusCode code: Int, andError error: Error?) -> URLSessionMock? {
        let data = loadJsonData(file: file)
        
        let response = HTTPURLResponse(url: URL(string: "TestUrl")!, statusCode: code, httpVersion: nil, headerFields: nil)
        
        return URLSessionMock(completionHandler: (data, response, error))
    }
    
    var subjectUnderTest: WeatherNetworkManager!
    
    var mockSession: URLSessionMock!
    
    override func tearDown() {
        subjectUnderTest = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testWeatherNetworkManager_fetchWeatherInformationForUserLocation_SuccessResult() {
        mockSession = createMockSession(fromJsonFile: "WeatherResponse", andStatusCode: 200, andError: nil)
        subjectUnderTest = WeatherNetworkManager(networkManager: NetworkManager(withSession: mockSession))
        
        subjectUnderTest.fetchWeatherInformationForUserLocation(longitude: "2.9457234900883487", latitude: "42.69925982345143", completion: { (result) in
            
            do {
                let weatherResponse = try result.get()
                XCTAssertNotNil(weatherResponse)
            } catch {
                XCTAssertNil(error)
            }
        })
    }
    
    func testWeatherNetworkManager_fetchWeatherInformationForUserLocation_buildOpenWeatherUrlMustReturnNil() {
        mockSession = createMockSession(fromJsonFile: "WeatherResponse", andStatusCode: 200, andError: nil)
        subjectUnderTest = WeatherNetworkManager(networkManager: NetworkManager(withSession: mockSession), weatherUrlProvider: WeatherUrlProviderMock())
        
        subjectUnderTest.fetchWeatherInformationForUserLocation(longitude: "Anything", latitude: "Anything", completion: {(result) in
            do {
                let weatherResponse = try result.get()
                XCTAssertNil(weatherResponse)
            } catch {
                XCTAssertEqual(error as? NetworkError, NetworkError.failedToCreateURL)
            }
        })
    }
}
