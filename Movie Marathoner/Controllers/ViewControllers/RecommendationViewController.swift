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
    var movie: Movie?{
        didSet{
            updateView()
        }
    }
    
    private var movieData: [Movie] = []
    private var movies: [Movie] = []
    private var recommendations: [Movie] = []
    
    private let cellID = "reccomendationCell"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Helper Methods
    func updateView(){
        guard let movie = movie else { return }
        if let movieID = movie.id{
            fetchRecommendations(with: "\(movieID)")
        }
        
    }
    
    func fetchRecommendations(with movieID: String){
        MovieAPIController.fetchRecommendations(with: movieID) { [weak self]result in
            switch result{
            case .success(let movies):
                self?.movieData = movies
                print("Number of Recommendations found: \(movies.count)")
                self?.setUpRecommendations()
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    func setUpRecommendations(){
        for movie in movieData{
            if let movieID = movie.id{
                fetchMovies(with: "\(movieID)")
            }
        }
        // TODO: Get list of recommendations > use list to do getMovies to new array > Shuffle new array > give reccomendations.
        movies.shuffle()
        
    }
    
    func fetchMovies(with movieID: String){
        
        MovieAPIController.fetchMovie(with: movieID) { (result) in
            switch result{
            case .success(let movie):
                if let title = movie.originalTitle{
                    
                    print("\(title) Successfully fetched")
                } else {
                    print("\(movie.id!) Missing")
                }
                self.movies.append(movie)
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    
    
}// End of class
