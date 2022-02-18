//
//  GiphyNetworkManager.swift
//  WeatherApp
//
//  Created by Sébastien Kothé on 17/02/2022.
//

import FLAnimatedImage

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
    func fetchJSONDataFromGiphyAPI(from keyword: String, completion: @escaping (Result<GiphyResponse, NetworkError>) -> Void) {
        
        guard let url = giphyURLProvider.buildGiphyURL(keyword: keyword) else {
            completion(.failure(.failedToCreateURL))
            return
        }
        
        networkManager.fetch(url: url, completion: completion)
    }
    
    func getGifFrom(_ gifURLAsString: String, completion: @escaping ((FLAnimatedImage?) -> Void)) {
        guard let imageURL = URL(string: gifURLAsString),
              let imageData: Data = try? Data(contentsOf: imageURL),
              let image = FLAnimatedImage(animatedGIFData: imageData) else {
                  completion(nil)
                  return
              }
        
        completion(image)
    }
    
    // MARK: - Private properties
    private let networkManager: NetworkManager
    private let giphyURLProvider: GiphyURLProviderProtocol
}
