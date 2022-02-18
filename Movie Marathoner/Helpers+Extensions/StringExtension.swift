//
//  File.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 2/17/22.
//

import Foundation
import CloudKit

extension String{
    init?(ckRecord: CKRecord){
        guard let movieID = ckRecord["movieID"] as? String else { return nil}
        
        self.init(movieID)
    }
}
