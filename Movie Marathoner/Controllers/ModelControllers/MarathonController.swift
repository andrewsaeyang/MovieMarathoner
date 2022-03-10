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
    func createMarathonFromRecommendation(with movies: [Movie], name: String, completion: @escaping(Result<String, MarathonError>) -> Void){
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
                
                self.createMovieReferences(with: movie, marathon: savedMarathon) { result in
                    switch result{
                    case .success(let finish):
                        print(finish)
                        savedMarathon.movies.append(movie)
                        
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
    
    ///Converts a CKReference of a movie which is owned by a Marathon.
    func createMovieReferences(with movie: Movie, marathon: Marathon, completion: @escaping(Result <String, MarathonError>) -> Void){
        
        // TODO: Changed parameter to movie, pull movie.ID into 
        
        let movieID = MovieID(movieID: "\(movie.id ?? -1)")// TODO: BUG FIX THIS
        let ckRecord = CKRecord(movie: movieID, parent: marathon)
        
        privateDB.save(ckRecord) { record, error in
            
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return(completion(.failure(.couldNotUnwrap)))
            }
            
            guard let record = record,
                  let savedMovie = MovieID(ckRecord: record),
                  let index = self.marathons.firstIndex(of: marathon) else { return completion(.failure(.couldNotUnwrap))}
            
            self.marathons[index].movieIDs.append(savedMovie)
            self.marathons[index].movies.append(movie)
            
            completion(.success("Movie added with ID of: \(movieID)"))
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
        let predicate = NSPredicate(format: "owningMarathon == %@", recordToMatch)
        
        let query = CKQuery(recordType: MovieIDStrings.recordTypeKey, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil){ records, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return(completion(.failure(.cKerror(error))))
            }
            guard let records = records else { return completion(.failure(.couldNotUnwrap))}
            
            let fetchedRecords = records.compactMap{ MovieID(ckRecord: $0) }
            
            // TODO: fetched records into Movies
            for movieID in fetchedRecords{
                MovieAPIController.fetchMovie(with: movieID.movieID) { result in
                    switch result{
                    case .success(let movie):
                        marathon.movies.append(movie)
                    case .failure(let error):
                        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    }
                }
            }
            
            
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
    
    func deleteMarathon(marathon: Marathon, completion: @escaping(Result<String, MarathonError>) -> Void){
        privateDB.delete(withRecordID: marathon.recordID) { recordID, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return(completion(.failure(.cKerror(error))))
            }
            
            guard let recordID = recordID else { return completion(.failure(.couldNotUnwrap))}
            
            guard let index = self.marathons.firstIndex(of: marathon) else { return completion(.failure(.couldNotUnwrap))}
            self.marathons.remove(at: index)
            
            completion(.success("Successfully deleted Marathon with id: \(recordID.recordName)"))
            
        }
    }
    
    func deleteReference(marathon: Marathon, movieID: MovieID, completion: @escaping (Result<String, MarathonError>) -> Void ){
        privateDB.delete(withRecordID: movieID.recordID) { recordID, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return(completion(.failure(.cKerror(error))))
            }
            
            guard let recordID = recordID else { return completion(.failure(.couldNotUnwrap))}
            
            guard let marathonIndex = self.marathons.firstIndex(of: marathon),
                  let movieIndex = self.marathons[marathonIndex].movieIDs.firstIndex(of: movieID) else { return completion(.failure(.couldNotUnwrap))}
            
            self.marathons[marathonIndex].movieIDs.remove(at: movieIndex)
            
            completion(.success("Successfully deleted Marathon with id: \(recordID.recordName)"))
        }
    }
}// End of class
