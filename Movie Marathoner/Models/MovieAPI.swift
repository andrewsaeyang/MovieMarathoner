//
//  MovieTopLevelObject.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 12/20/21.
//

import Foundation

// MARK: - MovieTopLevelObject
struct MovieTopLevelObject: Decodable {
    let page: Int
    let results: [Movie]
}

// MARK: - CastTopLevelObject
struct CastTopLevelObject: Decodable {
    let cast: [Cast]
}


