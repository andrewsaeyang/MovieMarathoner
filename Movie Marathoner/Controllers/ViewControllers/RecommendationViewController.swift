//
//  ReccomendationViewController.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 1/10/22.
//

import UIKit

class RecommendationViewController: UIViewController {
    
    // MARK: - Outlets
    
    // MARK: - Properties
    var movie: Movie?
    
    var hours: Int = -1
    private var totalTime = 0
    
    private var movieData: [Movie] = []
    
    private var movieList: [Movie] = []{
        didSet{
            setUpRecommendations()
        }
    }
    private var recommendations: [Movie] = []
    private var dummy: [Movie] = []
    
    private let cellID = "reccomendationCell"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        
    }
    
    // MARK: - Helper Methods
    func updateView(){
        guard let movie = movie else { return }
        if let movieID = movie.id{
            fetchRecommendations(with: "\(movieID)")
        }
    }
    
    //First Function
    func fetchRecommendations(with movieID: String){
        MovieAPIController.fetchRecommendations(with: movieID) { [weak self]result in
            
            DispatchQueue.main.async {
                switch result{
                case .success(let movies):
                    self?.movieData = movies
                    self?.setUpRecommendations()
                    print("Number of Recommendations found: \(movies.count)")
                    
                    //                    MovieAPIController.translateData(with: movies) { result in
                    //                        DispatchQueue.main.async {
                    //                            self?.movies = movies
                    //                        }
                    //                    }
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    //second Function
    
    func setUpRecommendations(){
        
        MovieAPIController.translateData(with: movieData) { result in
            
            switch result{
                
            case .success(var movies):
                movies.shuffle()
                print(" 🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔")
                self.printCheck(with: movies)
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            
        }
    }
    
    func printCheck(with movies: [Movie]) -> Void{
        for movie in movies{
            if let title = movie.originalTitle{
                print("\(title) Successfully fetched. Runtime \(movie.runtime!)")
            } else {
                print("\(movie.id!) Missing")
            }
            
            
        }
        
    }
    
    
    //    func continueSetup(){
    //
    //
    //
    //        hours = hours * 60
    //
    //
    //        for movie in movies{
    //            if let runTime = movie.runtime{
    //                let timeCheck = runTime + totalTime
    //                if timeCheck <= hours{
    //                    recommendations.append(movie)
    //                    totalTime += runTime
    //                }
    //            }
    //        }
    //
    //        print(countRunTime(for: recommendations))
    //    }
    
    func countRunTime(for marathon: [Movie]) -> Int {
        var retVal = 0
        
        for movie in movieList {
            if let time = movie.runtime{
                retVal += time
            }
        }
        return retVal
    }
    
    //Third function
    func fetchMovie(with movieID: String){
        
        MovieAPIController.fetchMovie(with: movieID) { (result) in
            
            DispatchQueue.main.async {
                switch result{
                case .success(let movie):
                    if let title = movie.originalTitle{
                        
                        print("\(title) Successfully fetched. Runtime \(movie.runtime!)")
                    } else {
                        print("\(movie.id!) Missing")
                    }
                    self.dummy.append(movie)
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    
    
}// End of class
