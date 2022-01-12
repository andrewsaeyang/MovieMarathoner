//
//  BingNewsAPIController.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 12/20/21.
//

import UIKit

class BingNewsAPIController{
    
    static let searchURL = "https://bing-news-search1.p.rapidapi.com/news/search?q=movies&textFormat=Raw&safeSearch=Moderate"
    static let headers = [
        "x-bingapis-sdk": "true",
        "x-rapidapi-host": "bing-news-search1.p.rapidapi.com",
        "x-rapidapi-key": KeyConstants.BingAPIKey
    ]
    
    static func fetchNews(completion:@escaping(Result<BingTopLevelObject, NetworkError>) -> Void){
        
        var request = URLRequest(url: URL(string: searchURL)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return(completion(.failure(.thrownError(error))))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200
                {
                    print("STATUS CODE: \(response.statusCode)")
                }
            }
            
            guard let data = data else { return completion(.failure(.noData))}
            
            do{
                let bingTLO = try JSONDecoder().decode(BingTopLevelObject.self, from: data)
                completion(.success(bingTLO))
            }catch{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.unableToDecode))
            }
        }
        task.resume()
    }
}// End of class
