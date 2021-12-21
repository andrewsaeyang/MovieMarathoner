//
//  FavoriteError.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 12/20/21.
//

import Foundation

enum FavoriteError: LocalizedError {
    case cKerror(Error)
    case couldNotUnwrap
    var errorDescription: String?{
        switch self{
        case .cKerror(let error):
            return error.localizedDescription
            
        case .couldNotUnwrap:
            return "could not unwrap Favorite information"
        }
    }
}//End of enum
