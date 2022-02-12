//
//  MarathonController.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 2/9/22.
//

import Foundation
import CloudKit

class MarathonController{
    
    static let shared = MarathonController()
    var marathons: [Marathon] = []
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
    // MARK: - CRUD
    func createMarathon(with movies: [String], name: String, completion: @escaping(Result<String, MarathonError>) -> Void){
        let marathon = Marathon(movies: movies, name: name)
        let ckRecord = CKRecord(marathon: marathon)
        
        privateDB.save(ckRecord) { record, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return(completion(.failure(.couldNotUnwrap)))
            }
            guard let record = record,
                  let savedMarathon = Marathon(ckRecord: record) else { return completion(.failure(.couldNotUnwrap))}
            
            self.marathons.append(savedMarathon)
            self.add(movieID: movies[0], marathon: ckRecord) { result in
                switch result{
                    
                case .success(let p):
                    print(p)
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
            
            completion(.success("Successfully created a marathon with recordID: \(savedMarathon.recordID.recordName) called \(savedMarathon.name)"))
        }
        
        
    }
    
    func fetchAllMarathons(completion: @escaping (Result<String, MarathonError>) -> Void){
        
        let predicate = NSPredicate (value: true)
        
        let query = CKQuery(recordType: MarathonStrings.recordTypeKey, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil){records, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.cKerror(error)))
            }
            guard let records = records else { return completion(.failure(.couldNotUnwrap))}
            
            let fetchedMarathons = records.compactMap{Marathon(ckRecord: $0)}
            self.marathons = fetchedMarathons
            
            completion(.success("Successfully fetched \(fetchedMarathons.count) marathons"))
            
        }
        
    }
    
    func updateMarathon(marathon: Marathon, completion: @escaping(Result<String, MarathonError>) -> Void){
        let record = CKRecord(marathon: marathon)
        
        let modOP = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        
        modOP.savePolicy = .changedKeys
        modOP.qualityOfService = .userInteractive
        
        modOP.modifyRecordsCompletionBlock = {records, _ , error in
            if let error = error{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.cKerror(error)))
            }
            guard let record = records?.first,
                  let updatedMarathon = Marathon(ckRecord: record) else { return completion (.failure(.couldNotUnwrap))}
            
            return completion(.success("Successfully updated Marathon with id:\(updatedMarathon.recordID.recordName)"))
        }
        privateDB.add(modOP)
    }
    
    func deleteMarathon(){
        
    }
    
    func add(movieID: String?, marathon: CKRecord, completion: @escaping(Result <String, MarathonError>) -> Void){
        let MarathonRecord = CKRecord(recordType: "MovieID")
        let reference = CKRecord.Reference(recordID: marathon.recordID, action: .deleteSelf)
        MarathonRecord["movieID"] = movieID! as CKRecordValue
        MarathonRecord["owningMovie"] = reference as CKRecordValue
        
        privateDB.save(MarathonRecord) { record, error in
            
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return(completion(.failure(.couldNotUnwrap)))
            }
            print("Movie added with ID of: \(movieID!)")
            
        }
        
        
        
    }
    
}
