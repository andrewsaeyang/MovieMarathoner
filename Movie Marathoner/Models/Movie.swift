//
//  Movie.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 2/9/22.
//

import Foundation

struct Movie: Decodable{
    let originalTitle: String?
    let posterPath: URL?
    let overview: String?
    let rating: Double?
    let id: Int?
    let runtime: Int?
    let releaseDate: String?
    
    
    enum CodingKeys: String, CodingKey{
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case overview = "overview"
        case rating = "vote_average"
        case id = "id"
        case runtime = "runtime"
        case releaseDate = "release_date"
    }
    
    var releaseDateFormatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let releaseDate = releaseDate,
              let date = dateFormatter.date(from: releaseDate) else { return "No release date available"}
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        
        return dateFormatterPrint.string(from: date)
    }
    
    var releaseYearFormatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let releaseDate = releaseDate,
              let date = dateFormatter.date(from: releaseDate) else { return "No release date available"}
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy"
        
        return dateFormatterPrint.string(from: date)
    }
}
extension Movie: Equatable{
    
    static func == (lhs: Movie, rhs: Movie ) -> Bool{
        
        return lhs.id == rhs.id
        
    }
}
