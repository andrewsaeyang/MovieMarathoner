//
//  MovieID.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 2/11/22.
//

import Foundation
import CloudKit
enum MovieIDStrings{
    static let recordTypeKey = "movie"
    fileprivate static let movieIDKey = "movieID"
}

class MovieID{
    let movieID: String
    let recordID: CKRecord.ID
    
    init(movieID: String, recordID: CKRecord.ID = (CKRecord.ID(recordName: UUID().uuidString))){
        self.movieID = movieID
        self.recordID = recordID
    }
    
}

extension CKRecord{
 
}
