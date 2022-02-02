//
//  FilmCollectionViewCell.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 12/20/21.
//

import UIKit
protocol ReloadCollectionDelegate: AnyObject{
    func updateCollectionView()
}

class FilmCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var filmImageView: UIImageView!
    
    // MARK: - PROPERTIES
    var hours: Int = -1
    var movie: Movie?{
        didSet{
            updateViews()
        }
    }
    
    weak var delegate: ReloadCollectionDelegate?
    
    
    // MARK: - Actions
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        guard let _ = movie else { return }
        //On load, compare if film being loaded is in the favorites list, if so, mark the heart as favorited
        //on tap, check if filmID is in the favorites array. if false, then crete new ckRecord. if true, remove it.
        //if
        
        
    }
    // MARK: - Helper Methods
    
    ///This function checks for a matching film and determins if it needs to create a ckRecord with that film or remove a ckRecord of that film
    
    
    func updateViews(){
        guard let movie = movie else { return }
        
        fetchPoster(for: movie)
        
    }
    
    func fetchPoster(for movie: Movie){
        guard let posterPath = movie.posterPath else { return }
        MovieAPIController.fetchMoviePoster(with: posterPath) { [weak self]result in
            
            DispatchQueue.main.async {
                switch result{
                    
                case .success(let image):
                    
                    self?.filmImageView.image = image
                    self?.filmImageView.contentMode = .scaleAspectFill
                    self?.filmImageView.layer.cornerRadius = 8
                    
                case .failure(let error):
                    print("Error IMAGE in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
}// End of class
