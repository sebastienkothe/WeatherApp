//
//  GiphyNetworkManagerTests.swift
//  WeatherAppTests
//
//  Created by Sébastien Kothé on 18/02/2022.
//

import XCTest
@testable import WeatherApp

class GiphyNetworkManagerTests: XCTestCase {
    
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
    
    var subjectUnderTest: GiphyNetworkManager!
    
    var mockSession: URLSessionMock!
    
    override func tearDown() {
        subjectUnderTest = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testGiphyNetworkManager_fetchJSONDataFromGiphyAPI_SuccessResult() {
        mockSession = createMockSession(fromJsonFile: "GiphyResponse", andStatusCode: 200, andError: nil)
        subjectUnderTest = GiphyNetworkManager(networkManager: NetworkManager(withSession: mockSession))
        
        subjectUnderTest.fetchJSONDataFromGiphyAPI(from: "sun", completion: {(result) in
            do {
                let giphyResponse = try result.get()
                XCTAssertNotNil(giphyResponse)
            } catch {
                XCTAssertNil(error)
            }
        })
    }
    
    func testGiphyNetworkManager_fetchJSONDataFromGiphyAPI_buildGiphyURLMustReturnNil() {
        mockSession = createMockSession(fromJsonFile: "GiphyResponse", andStatusCode: 200, andError: nil)
        subjectUnderTest = GiphyNetworkManager(networkManager: NetworkManager(withSession: mockSession), giphyURLProvider: GiphyURLProviderMock())
        
        subjectUnderTest.fetchJSONDataFromGiphyAPI(from: "sun", completion: {(result) in
            do {
                let giphyResponse = try result.get()
                XCTAssertNil(giphyResponse)
            } catch {
                XCTAssertEqual(error as? NetworkError, NetworkError.failedToCreateURL)
            }
        })
    }
    
    func testGiphyNetworkManager_getGifFrom_getGifFromMustReturnNil() {
        subjectUnderTest = GiphyNetworkManager()
        
        subjectUnderTest.getGifFrom("", completion: { (result) in
            XCTAssertNil(result)
        })
    }
    
    func testGiphyNetworkManager_getGifFrom_getGifFromMustReturnNotNil() {
        subjectUnderTest = GiphyNetworkManager()
        
        subjectUnderTest.getGifFrom("sun", completion: { (result) in
            XCTAssertNotNil(result)
        })
    }
}
