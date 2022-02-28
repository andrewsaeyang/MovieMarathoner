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
    fileprivate static let marathonName = "marathonName"
}

class Marathon{
    let name: String
    let recordID: CKRecord.ID
    var movieIDs: [MovieID]
    init(name: String, movieIDs: [MovieID] = [], recordID: CKRecord.ID = (CKRecord.ID(recordName: UUID().uuidString))){

        self.name = name
        self.movieIDs = movieIDs
        self.recordID = recordID
    }
}

extension CKRecord{
    convenience init(marathon: Marathon){
        self.init(recordType: MarathonStrings.recordTypeKey, recordID: marathon.recordID)
    
        self.setValuesForKeys([
            MarathonStrings.marathonName : marathon.name
        ])
    }
}// End of Extension

extension Marathon: Equatable{
    convenience init?(ckRecord: CKRecord){
        guard let name = ckRecord[MarathonStrings.marathonName] as? String else { return nil}
        self.init(name: name, recordID: ckRecord.recordID)
    }
    
    static func == (lhs: Marathon, rhs: Marathon ) -> Bool{
        
        return lhs.recordID == rhs.recordID
    }
}// End of Extension
