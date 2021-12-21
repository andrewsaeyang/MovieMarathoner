//
//  Favorite.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 12/20/21.
//

import UIKit
import CloudKit

enum FavoriteStrings{
    static let recordTypeKey = "favorite"
    fileprivate static let filmTitleKey = "title"
    fileprivate static let idKey = "id"
}
class Favorite{
    
    let filmID: String
    let filmTitle: String
    let recordID: CKRecord.ID
    init(id: String, title: String, recordID: CKRecord.ID = (CKRecord.ID(recordName: UUID().uuidString))){
        self.filmID = id
        self.filmTitle = title
        self.recordID = recordID
    }
    
    /*
     hit favorite button, store movie as CKRecord -> private database
     fetch favorites from CloudKit > Fetch API with IDs> reload view at call site
     fetch cloud kit first> when fetching form SG all films, check if ID is contained in favorites. Toggle button.
     */
}// End of class

extension CKRecord{
    
    ///turning a favorite into a record
    convenience init(favorite: Favorite){
        self.init(recordType:FavoriteStrings.recordTypeKey, recordID: favorite.recordID)
        
        self.setValuesForKeys([
            FavoriteStrings.idKey : favorite.filmID,
            FavoriteStrings.filmTitleKey : favorite.filmTitle
        ])
    }
} // End of Extension

extension Favorite: Equatable{
    convenience init?(ckRecord: CKRecord){
        guard let id = ckRecord[FavoriteStrings.idKey] as? String,
              let title = ckRecord[FavoriteStrings.filmTitleKey] as? String else { return nil}
        
        self.init(id: id, title: title, recordID: ckRecord.recordID)
    }
    
    static func == (lhs: Favorite, rhs: Favorite) -> Bool {
        //lhs.recordID == rhs.recordID
        lhs.filmID == rhs.filmID
    }
} // End of Extension
