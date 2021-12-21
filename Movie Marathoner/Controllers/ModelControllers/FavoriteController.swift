//
//  FavoriteController.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 12/20/21.
//

import Foundation
import CloudKit

class FavoriteController{
    
    static let shared = FavoriteController()
    var favorites: [Favorite] = []
    
    //step 1: Declare if private or public DB
    let privateDB = CKContainer.default().privateCloudDatabase
    
    //CRUD
    func createFavorite(with id: String, title: String, completion: @escaping(Result<String, FavoriteError>) -> Void) {
        let favorite = Favorite(id: id, title: title)
        
        //Step 2: after creating object, call the ckRecord init
        let ckRecord = CKRecord(favorite: favorite)
        
        privateDB.save(ckRecord) { record, error in
            if let error = error{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.couldNotUnwrap))
            }
            //step 3 unwrap and then save record
            
            guard let record = record,
                  let savedFavorite = Favorite(ckRecord: record) else { return completion(.failure(.couldNotUnwrap))}
            
            self.favorites.append(savedFavorite)
            
            completion(.success("successfully created a favorite with recordID: \(savedFavorite.recordID.recordName) for movieID: \(id)"))
        }
    }
    
    //query the db
    func fetchAllFavorites(completion: @escaping (Result<String, FavoriteError>) -> Void){
        
        //predicate states that we want everything
        let predicate = NSPredicate (value: true)
        
        // look for ckRecord that has this type, that confroms to the predicate
        let query = CKQuery(recordType: FavoriteStrings.recordTypeKey, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil){ records, error in
            if let error = error{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure((.cKerror(error))))
            }
            
            guard let records = records else { return completion(.failure(.couldNotUnwrap))}
            
            let fetchedFavorites = records.compactMap{Favorite(ckRecord: $0) }
            self.favorites = fetchedFavorites
            
            completion(.success(("Successfully fetched \(fetchedFavorites.count) favorites")))
        }
    }
    
    func update(favorite: Favorite, completion: @escaping(Result<String, FavoriteError>) -> Void){
        let record = CKRecord(favorite: favorite)
        
        let modOP = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        
        modOP.savePolicy = .changedKeys
        modOP.qualityOfService = .userInteractive
        
        modOP.modifyRecordsCompletionBlock = { records, _ , error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.cKerror(error)))
            }
            
            guard let record = records?.first,
                  let updatedFavorite = Favorite(ckRecord: record) else { return completion(.failure(.couldNotUnwrap))}
            
            return completion(.success("Successfully updated Favorite with id:\(updatedFavorite.recordID.recordName)"))
            
        }
        
        privateDB.add(modOP)
    }
    
    func deleteFavorite(favorite: Favorite, completion: @escaping(Result<String, FavoriteError>) -> Void){
        privateDB.delete(withRecordID: favorite.recordID) { recordID, error in
            if let error = error{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.cKerror(error)))
            }
            guard let recordID = recordID else { return completion(.failure(.couldNotUnwrap))}
            
            guard let index = self.favorites.firstIndex(of: favorite) else { return completion(.failure(.couldNotUnwrap))}
            self.favorites.remove(at: index)
            
            completion(.success("Successfully deleted favorite with id: \(recordID.recordName)"))
        }
    }
    
    // MARK: - Helepr methods
    func doesContain(film: Film) -> Bool{
        var retVal = false
        
        if getFavoriteFromSource(with: film).filmID == film.id {
            retVal.toggle()
        }
        
        print("doesContain is \(retVal)")
        return retVal
    }
    
    ///This function takes in a Film and returns the favorite that it's associated with in our source of truth
    func getFavoriteFromSource(with film: Film) -> Favorite{
        var retVal = Favorite(id: "", title: "")
        
        for favorite in favorites{
            if favorite.filmID == film.id{
                retVal = favorite
                
            }
        }
        return retVal
    }
    
    func favoriteTapped(with favorite: Favorite?){
        guard let favorite = favorite else { return }
        if FavoriteController.shared.favorites.contains(favorite){
            print("Removing favorite")
            if let index = FavoriteController.shared.favorites.firstIndex(of: favorite){
                FavoriteController.shared.favorites.remove(at: index)
            }
        }else{
            print("Adding new favorite")
            FavoriteController.shared.favorites.append(favorite)
            
        }
    }
} // End of class
