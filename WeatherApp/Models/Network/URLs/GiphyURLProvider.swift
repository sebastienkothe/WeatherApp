//
//  GiphyURLProvider.swift
//  WeatherApp
//
//  Created by Sébastien Kothé on 16/02/2022.
//

import Foundation

class GiphyURLProvider: GiphyURLProviderProtocol {
    
    // MARK: - Internal methods
    func buildGiphyURL(keyword: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.giphy.com"
        urlComponents.path = "/v1/gifs/search"
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: "69oigQHHKkAXzjsXIHaWeTwbGoaYdRmN"),
            URLQueryItem(name: "q", value: keyword),
            URLQueryItem(name: "limit", value: "1")
        ]
        return urlComponents.url
    }
}
