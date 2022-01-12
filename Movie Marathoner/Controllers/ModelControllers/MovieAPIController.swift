//
//  MovieAPIController.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 12/20/21.
//


import Foundation
import UIKit

class MovieAPIController{
    
    //Cache
    static let cache = NSCache<NSString, UIImage>()
    
    //The Movie Database API
    //https://api.themoviedb.org/3/movie/76341?api_key=<<api_key>>
    // MARK: - BASEURL
    //https://api.themoviedb.org
    static let baseURL = URL(string: "https://api.themoviedb.org")
    static let imageBaseURL = URL(string: "https://image.tmdb.org/t/p/w500")
    
    // MARK: - COMPONENTS
    static let versionComponent = "3"
    static let searchComponent = "search"
    static let movieComponent = "movie"
    static let creditsComponent = "credits"
    
    // MARK: - QUERY ITEMS
    static let apiKeyKey = "api_key"
    static let apiKeyValue = KeyConstants.TMDBAPIKey
    
    static let appendToResponseKey = "append_to_response"
    static let appendToResponseValue = "person"
    
    static let searchTermKey = "query"
    
    // MARK: - FETCHES
    static func fetchMovies(with searchTerm: String, completion: @escaping (Result<[Movie], NetworkError>) -> Void){
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
        
        // adding components
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let searchURL = versionURL.appendingPathComponent(searchComponent)
        let movieURL = searchURL.appendingPathComponent(movieComponent)
        
        // adding queries
        var components = URLComponents(url: movieURL, resolvingAgainstBaseURL: true)
        let accessQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        let searchTermQuery = URLQueryItem(name: searchTermKey, value: searchTerm)
        
        components?.queryItems = [accessQuery, searchTermQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL))}
        print(finalURL)
        
        let task = URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData))}
            
            do{
                let MovieTL = try JSONDecoder().decode(MovieTopLevelObject.self, from: data)
                completion(.success(MovieTL.results ))
            }catch{
                print("IS THIS THE Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.unableToDecode))
            }
            
        }
        task.resume()
    }
    
    static func fetchMoviePoster(with url: URL, completion: @escaping (Result<UIImage, NetworkError>) -> Void){
        
        let cacheKey = NSString(string: url.absoluteString)
        
        if let image = cache.object(forKey: cacheKey){
            return completion(.success(image))
        }
        
        guard let imageBaseURL = imageBaseURL else { return completion(.failure(.invalidURL))}
        let finalURL = imageBaseURL.appendingPathComponent(url.absoluteString)
        
        print(finalURL)
        let task = URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200
                {
                    print("STATUS CODE: \(response.statusCode)")
                }
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            guard let image = UIImage(data: data) else { return completion(.failure(.noImage))}
            
            let cacheKey = NSString(string: url.absoluteString)
            self.cache.setObject(image, forKey: cacheKey)
            completion(.success(image))
        }
        task.resume()
    }
    
    //https://image.tmdb.org/t/p/w500/xi8z6MjzTovVDg8Rho6atJCcKjL.jpg
    ///This overloaded fetchPoster function is for specifically two films: "Only Yesterday" and "The Cat Returns"
    static func fetchMoviePoster(for poster: Bool, completion: @escaping (Result<UIImage, NetworkError>) -> Void){
        
        let finalURL: URL
        
        if poster {
            finalURL = URL(string: "https://image.tmdb.org/t/p/origin/tOSnFE9e82iH3ZAzSTtuOkBsabJ.jpg")!
            
        }else{
            finalURL = URL(string: "https://image.tmdb.org/t/p/origin/avPMO5cnaGHgLaNiAIhy33WoQLm.jpg")!
        }
        
        print(finalURL)
        let task = URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200
                {
                    print("STATUS CODE: \(response.statusCode)")
                }
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            guard let image = UIImage(data: data) else { return completion(.failure(.noImage))}
            completion(.success(image))
        }
        task.resume()
    }
    
    static func fetchCastMembers(for movieId: Int, completion: @escaping (Result<[Cast], NetworkError>) -> Void){
        
        guard let baseURL = baseURL else { return (completion(.failure(.invalidURL)))}
        //https://api.themoviedb.org/3/movie/8392/credits?api_key=a0c4dab30fc5e01de42209a6868523d2&append_to_response=movie,person
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let movieURL = versionURL.appendingPathComponent(movieComponent)
        let movieIdURL = movieURL.appendingPathComponent(String(movieId))
        let creditsURL = movieIdURL.appendingPathComponent(creditsComponent)
        
        //queries
        var components = URLComponents(url: creditsURL, resolvingAgainstBaseURL: true)
        let accessQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        let appendToResponseQuery = URLQueryItem(name:appendToResponseKey , value: appendToResponseValue)
        
        components?.queryItems = [accessQuery, appendToResponseQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL))}
        print("Final URL for list of People is \(finalURL)")
        
        let task = URLSession.shared.dataTask(with: finalURL) { data, response, error in
            
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return(completion(.failure(.thrownError(error))))
            }
            
            guard let data = data else { return completion(.failure(.noData))}
            
            do{
                let peopleTL = try JSONDecoder().decode(CastTopLevelObject.self, from: data)
                let cast = peopleTL.cast
                completion(.success(cast))
                
            }catch{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.unableToDecode))
                
            }
        }
        task.resume()
    }
}// End of class
