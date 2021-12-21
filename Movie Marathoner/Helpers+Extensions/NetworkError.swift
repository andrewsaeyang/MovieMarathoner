//
//  NetworkError.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 12/20/21.
//

import Foundation

enum NetworkError: LocalizedError{
    
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    case noImage
    
    var errorDescription: String?{
        
        switch self{
        
        case .invalidURL:
            return "Unable to reach the server"
        case .thrownError(let error):
            return "Error in \(#function) : \(error.localizedDescription) \n---\n \(error)"
        case .noData:
            return "The server responded with no data"
        case .unableToDecode:
            return "There was an error trying to decode the data."
        case .noImage:
            return "Could not create UIImage from data"
        }
    }
}// End of enum
