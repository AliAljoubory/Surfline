//
//  NetworkManager.swift
//  Surfline
//
//  Created by Ali Aljoubory on 14/12/2020.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let baseUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    
    let cache = NSCache<NSString, UIImage>()
    
    private let radius = "1000"
    private let keyword = "surf"
    private var apiKey = String()
    
    private init() {}
    
    func getPlaces(latitude: String?, longitude: String?, completed: @escaping (Result<Place, SurflineError>) -> Void) {
        apiKey = PersistenceManager.retrieveAPIKey()
        
        guard apiKey != "" else {
            completed(.failure(.noAPIKey))
            return
        }
        
        let endpoint = baseUrl + "location=\(latitude ?? ""),\(longitude ?? "")&radius=\(radius)&keyword=\(keyword)&key=\(apiKey)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let _ = response as? HTTPURLResponse else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let place = try decoder.decode(Place.self, from: data)
                completed(.success(place))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self,
                  error == nil,
                  let _ = response as? HTTPURLResponse,
                  let data = data,
                  let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
}
