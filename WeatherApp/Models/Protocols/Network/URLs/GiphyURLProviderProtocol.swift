//
//  GiphyURLProviderProtocol.swift
//  WeatherApp
//
//  Created by Sébastien Kothé on 16/02/2022.
//

import Foundation

protocol GiphyURLProviderProtocol {
    func buildGiphyURL(keyword: String) -> URL?
}
