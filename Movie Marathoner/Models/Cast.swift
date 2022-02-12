//
//  Cast.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 2/9/22.
//

import Foundation

struct Cast: Decodable{
    let id: Int?
    let name: String?
    let knownForDepartment: String?
    let character: String?
    let profilePath: URL?
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case character
        case knownForDepartment = "known_for_department"
        case profilePath = "profile_path"
    }
}
