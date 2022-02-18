//
//  GiphyURLProviderMock.swift
//  WeatherAppTests
//
//  Created by Sébastien Kothé on 18/02/2022.
//

import Foundation
@testable import WeatherApp

class GiphyURLProviderMock: GiphyURLProviderProtocol {
    func buildGiphyURL(keyword: String) -> URL? {
        return nil
    }
}
