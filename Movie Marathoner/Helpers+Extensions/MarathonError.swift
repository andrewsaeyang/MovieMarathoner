//
//  FavoriteError.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 12/20/21.
//

import Foundation

enum MarathonError: LocalizedError {
    case cKerror(Error)
    case couldNotUnwrap
    var errorDescription: String?{
        switch self{
        case .cKerror(let error):
            return error.localizedDescription
            
        case .couldNotUnwrap:
            return "could not unwrap Marathon information"
        }
    }
}//End of enum
