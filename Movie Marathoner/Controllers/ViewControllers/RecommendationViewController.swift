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
    
    var marathonTime: Int = -1
    private var finalRunTime = -1
    private var movieRecommendations: [Movie] = []
    private var finalRecommendation: [Movie] = []
    
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
                    self?.translateData(with: movies)
                    print("Number of Recommendations found: \(movies.count)")
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    //second Function
    
    func translateData(with movieData: [Movie]){
        MovieAPIController.translateData(with: movieData) { result in
            self.movieRecommendations = result
            self.movieRecommendations.shuffle()
            self.continueSetup()
        }
    }
    
    func setupReccomendation(){
        
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
    
    
    func continueSetup(){
        marathonTime = marathonTime * 60
        
        for movie in movieRecommendations{
            if let runTime = movie.runtime{
                let doesTimeFit = runTime + finalRunTime
                
                if doesTimeFit <= marathonTime{
                    finalRecommendation.append(movie)
                    finalRunTime += runTime
                    print("Current runtime:\(countRunTime(for: finalRecommendation)) with \(finalRecommendation.count) movies")
                }
            }
        }
        
        print(countRunTime(for: finalRecommendation))
    }
    
    func countRunTime(for marathon: [Movie]) -> Int {
        var retVal = 0
        
        for movie in finalRecommendation {
            if let time = movie.runtime{
                retVal += time
            }
        }
        return retVal
    }
}// End of class
