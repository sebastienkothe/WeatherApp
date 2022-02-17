//
//  GiphyNetworkManager.swift
//  WeatherApp
//
//  Created by Sébastien Kothé on 17/02/2022.
//

final class GiphyNetworkManager {
    
    // MARK: - Initializer
    
    /// Used to be able to perform dependency injection
    init(
        networkManager: NetworkManager = NetworkManager(),
        giphyURLProvider: GiphyURLProviderProtocol = GiphyURLProvider()
    ) {
        self.networkManager = networkManager
        self.giphyURLProvider = giphyURLProvider
    }
    
    // MARK: - Internal methods
    
    /// Used to get weather information based on the user's current location
    func fetchGIF(from keyword: String, completion: @escaping (Result<GiphyResponse, NetworkError>) -> Void) {
        
        guard let url = giphyURLProvider.buildGiphyURL(keyword: keyword) else {
            completion(.failure(.failedToCreateURL))
            return
        }
        
        networkManager.fetch(url: url, completion: completion)
    }
    
    // MARK: - Private properties
    private let networkManager: NetworkManager
    private let giphyURLProvider: GiphyURLProviderProtocol
}
