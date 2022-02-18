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
    
    ///Creates a new marathon with a list of movies from the recommendation view.
    func createMarathonFromRecommendation(with movies: [String], name: String, completion: @escaping(Result<String, MarathonError>) -> Void){
        let marathon = Marathon(name: name)
        let ckRecord = CKRecord(marathon: marathon)
        
        privateDB.save(ckRecord) { record, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return(completion(.failure(.couldNotUnwrap)))
            }
            guard let record = record,
                  let savedMarathon = Marathon(ckRecord: record) else { return completion(.failure(.couldNotUnwrap))}
            
            for movie in movies{
                self.createMovieReferences(with: movie, marathon: ckRecord) { result in
                    switch result{
                        
                    case .success(let p):
                        savedMarathon.movieIDs.append(movie)
                        print(p)
                    case .failure(let error):
                        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    }
                }
            }
            
            self.marathons.append(savedMarathon)
            
            
            completion(.success("Successfully created a marathon with recordID: \(savedMarathon.recordID.recordName) called \(savedMarathon.name)"))
        }
    }
    
    ///Creates a new marathon.
    func createMarathon(with name: String, completion: @escaping(Result<String, MarathonError>) -> Void){
        let marathon = Marathon(name: name)
        let ckRecord = CKRecord(marathon: marathon)
        
        privateDB.save(ckRecord) { record, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return(completion(.failure(.couldNotUnwrap)))
            }
            guard let record = record,
                  let savedMarathon = Marathon(ckRecord: record) else { return completion(.failure(.couldNotUnwrap))}
            self.marathons.append(savedMarathon)
            completion(.success("Successfully created a marathon with recordID: \(savedMarathon.recordID.recordName) called \(savedMarathon.name)"))
        }
    }
    
    ///Converts a CKReference of a movie and which is owned by a Marathon.
    func createMovieReferences(with movieID: String, marathon: CKRecord, completion: @escaping(Result <String, MarathonError>) -> Void){
        let MarathonRecord = CKRecord(recordType: "MovieID")
        let reference = CKRecord.Reference(recordID: marathon.recordID, action: .deleteSelf)
        
        MarathonRecord["movieID"] = movieID as CKRecordValue
        MarathonRecord["owningMovie"] = reference as CKRecordValue
        
        privateDB.save(MarathonRecord) { record, error in
            
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return(completion(.failure(.couldNotUnwrap)))
            }
            print("Movie added with ID of: \(movieID)")
        }
    }
    ///Fetches all of the user's marathons along with the marathon's movies.
    func fetchMarathons(completion: @escaping (Result<String, MarathonError>) -> Void){
        
        let predicate = NSPredicate (value: true)
        
        let query = CKQuery(recordType: MarathonStrings.recordTypeKey, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil){records, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.cKerror(error)))
            }
            guard let records = records else { return completion(.failure(.couldNotUnwrap))}
            
            let fetchedMarathons = records.compactMap{ Marathon(ckRecord: $0)}
            self.marathons = fetchedMarathons
            completion(.success("Successfully fetched \(fetchedMarathons.count) marathons"))
            
        }
    }
    
    ///Fetches all movies owned by a Marathon
    func fetchMovieReferences(with marathon: Marathon, completion: @escaping(Result <String, MarathonError>) -> Void){
        let recordToMatch = CKRecord.Reference(recordID: marathon.recordID, action: .deleteSelf)
        let predicate = NSPredicate(format: "owningMovie == %@", recordToMatch)
        
        let query = CKQuery(recordType: "movieID", predicate: predicate)
        privateDB.perform(query, inZoneWith: nil){ records, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return(completion(.failure(.cKerror(error))))
            }
            guard let records = records else { return completion(.failure(.couldNotUnwrap))}
            
            let fetchedRecords = records.compactMap{ String(ckRecord: $0) }
            marathon.movieIDs = fetchedRecords
            completion(.success("Successfully fetched \(fetchedRecords.count) movieIDs"))
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
    
    
    
}// End of class
