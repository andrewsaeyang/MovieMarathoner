//
//  StudioGhibliAPIController.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 12/20/21.
//

import Foundation

class StudioGhibliAPIController{
    
    // MARK: - Properties
    static let shared = StudioGhibliAPIController()
    
    // Studio Ghibli API
    static let baseURL = URL(string: "https://ghibliapi.herokuapp.com")
    static let filmComponent = "films"
    
} // End of class

//Main fetch functions
extension StudioGhibliAPIController{
    
    static func fetchFilms(completion: @escaping(Result<[Film], NetworkError>) -> Void){
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
        let finalURL = baseURL.appendingPathComponent(filmComponent)
        
        print(finalURL)
        let task = URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData))}
            
            do{
                let films = try JSONDecoder().decode([Film].self, from: data)
                completion(.success(films))
            }catch{
                completion(.failure(.unableToDecode))
            }
        }
        task.resume()
    }
} // End of Extension

