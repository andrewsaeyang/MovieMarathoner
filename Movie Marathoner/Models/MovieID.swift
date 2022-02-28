//
//  MovieID.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 2/11/22.
//

import Foundation
import CloudKit

enum MovieIDStrings{
    static let recordTypeKey = "Movie"
    fileprivate static let movieIDKey = "movieID"
    fileprivate static let owningMarathonKey = "owningMarathon"
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
    convenience init(movie: MovieID, parent: Marathon){
        self.init(recordType: MovieIDStrings.recordTypeKey, recordID: movie.recordID)
        let reference = CKRecord.Reference(recordID: parent.recordID, action: .deleteSelf)
        
        self.setValuesForKeys([
            MovieIDStrings.movieIDKey : movie.movieID,
            MovieIDStrings.owningMarathonKey : reference
        ])

    }
}

extension MovieID:Equatable{
    
    convenience init?(ckRecord: CKRecord){
        guard let movieID = ckRecord[MovieIDStrings.movieIDKey] as? String else {return nil}
        self.init(movieID: movieID, recordID: ckRecord.recordID)
    }
    
    static func == (lhs: MovieID, rhs: MovieID ) -> Bool{
        
        return lhs.recordID == rhs.recordID
        
    }
}
