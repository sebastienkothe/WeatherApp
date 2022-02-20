//
//  NetworkManagerTests.swift
//  WeatherAppTests
//
//  Created by Sébastien Kothé on 18/02/2022.
//

import XCTest
@testable import WeatherApp

class NetworkManagerTest: XCTestCase {
    
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
    
    var subjectUnderTest: NetworkManager!
    
    var mockSession: URLSessionMock!
    
    override func tearDown() {
        subjectUnderTest = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testNetworkManager_SuccessResult() {
        mockSession = createMockSession(fromJsonFile: "CorrectData",
                                        andStatusCode: 200, andError: nil)
        subjectUnderTest = NetworkManager(withSession: mockSession)
        subjectUnderTest.fetch(url: URL(string: "TestUrl")!, completion: {(result: Result<WeatherResponse, NetworkError>) in
            do {
                let weatherResponse = try result.get()
                XCTAssertNotNil(weatherResponse)
            } catch {
                XCTAssertNil(error)
            }
        })
    }
    
    func testNetworkManager_404Result() {
        mockSession = createMockSession(fromJsonFile: "CorrectData", andStatusCode: 404, andError: nil)
        subjectUnderTest = NetworkManager(withSession: mockSession)
        subjectUnderTest.fetch(url: URL(string: "TestUrl")!, completion: { (result: Result<WeatherResponse, NetworkError>) in
            do {
                let weatherResponse = try result.get()
                XCTAssertNil(weatherResponse)
            } catch {
                XCTAssertEqual(error as? NetworkError, .incorrectHttpResponseCode)
            }
        })
    }
    
    func testNetworkManager_NoData() {
        mockSession = createMockSession(fromJsonFile: "fileNotFound", andStatusCode: 500, andError: nil)
        subjectUnderTest = NetworkManager(withSession: mockSession)
        subjectUnderTest.fetch(url: URL(string: "TestUrl")!, completion: { (result: Result<WeatherResponse, NetworkError>) in
            do {
                let weatherResponse = try result.get()
                XCTAssertNil(weatherResponse)
            } catch {
                XCTAssertEqual(error as? NetworkError, .noData)
            }
        })
    }
    
    func testNetworkManager_AnotherStatusCode() {
        mockSession = createMockSession(fromJsonFile: "CorrectData", andStatusCode: 401, andError: NetworkError.unknownError)
        subjectUnderTest = NetworkManager(withSession: mockSession)
        subjectUnderTest.fetch(url: URL(string: "TestUrl")!, completion: { (result: Result<WeatherResponse, NetworkError>) in
            do {
                let weatherResponse = try result.get()
                XCTAssertNil(weatherResponse)
            } catch {
                XCTAssertEqual(error as? NetworkError, .unknownError)
            }
        })
    }
    
    func testNetworkManager_InvalidData() {
        mockSession = createMockSession(fromJsonFile: "IncorrectData", andStatusCode: 200, andError: nil)
        subjectUnderTest = NetworkManager(withSession: mockSession)
        subjectUnderTest.fetch(url: URL(string: "TestUrl")!, completion: { (result: Result<WeatherResponse, NetworkError>) in
            do {
                let weatherResponse = try result.get()
                XCTAssertNil(weatherResponse)
            } catch {
                XCTAssertEqual(error as? NetworkError, .failedToDecodeJSON)
            }
        })
    }
}
