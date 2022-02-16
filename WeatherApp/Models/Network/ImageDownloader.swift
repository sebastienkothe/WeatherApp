//
//  ImageDownloader.swift
//  WeatherApp
//
//  Created by Sébastien Kothé on 16/02/2022.
//

import UIKit

class ImageDownloader {
    
    // MARK: - Initializer
    init(withSession session: URLSessionProtocol = URLSession.shared,
         weatherUrlProvider: WeatherUrlProviderProtocol = WeatherURLProvider()) {
        self.session = session
        self.weatherUrlProvider = weatherUrlProvider
    }
    
    // MARK: - Internal methods
    func fetchImage(from iconName: String, with completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        
        guard let url = weatherUrlProvider.buildIconURL(iconName: iconName) else {
            completion(.failure(.failedToCreateURL))
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.unknownError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                200...299 ~= httpResponse.statusCode
            else {
                completion(.failure(.incorrectHttpResponseCode))
                return
            }
            
            guard let image = UIImage(data: data) else { return }
            completion(.success(image))
        }
        .resume()
    }
    
    // MARK: - Private properties
    private let weatherUrlProvider: WeatherUrlProviderProtocol
    private let session: URLSessionProtocol
}

