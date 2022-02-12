//
//  Marathon.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 2/9/22.
//

import Foundation
import CloudKit
enum MarathonStrings{
    static let recordTypeKey = "Marathon"
    fileprivate static let moviesKey = "movies"
    fileprivate static let marathonName = "name"
}
class Marathon{
    let movies: [String]
    let name: String
    let recordID: CKRecord.ID
    init(movies: [String], name: String, recordID: CKRecord.ID = (CKRecord.ID(recordName: UUID().uuidString))){
        self.movies = movies
        self.name = name
        self.recordID = recordID
    }
}

extension CKRecord{
    convenience init(marathon: Marathon){
        self.init(recordType: MarathonStrings.recordTypeKey, recordID: marathon.recordID)
    
        self.setValuesForKeys([
            MarathonStrings.moviesKey : marathon.movies,
            MarathonStrings.marathonName : marathon.name
        ])
    }
}// End of Extension

extension Marathon:Equatable{
    
    convenience init?(ckRecord: CKRecord){
        guard let movies = ckRecord[MarathonStrings.moviesKey] as? [String],
        let name = ckRecord[MarathonStrings.marathonName] as? String else { return nil}
        self.init(movies: movies, name: name, recordID: ckRecord.recordID)
    }
    
    static func == (lhs: Marathon, rhs: Marathon ) -> Bool{
        
        return lhs.recordID == rhs.recordID
        
    }
}
