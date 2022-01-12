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
        MovieAPIController.fetchRecommendation(with: movieID) { [weak self]result in
            switch result{
            case .success(let movies):
                self?.recommendations = movies
                
                print("Number of Recommendations found: \(movies.count)")
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    // TODO: get movie recommendation list
    
    
}// End of class
