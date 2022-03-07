//
//  WatchListTableViewCell.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 3/2/22.
//

import UIKit

class WatchListTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties
    var movie: Movie?{
        didSet{
            updateView()
        }
    }
    
    // MARK: - Helper Functions
    func updateView(){
        guard let movie = movie,
        let title = movie.originalTitle else { return }
        titleLabel.text = title
        fetchPoster()
    }
    
    func fetchPoster(){
        guard let posterPath = movie?.posterPath else { return }
        
        MovieAPIController.fetchMoviePoster(with: posterPath) { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let image):
                    self.posterImageView.image = image
                    self.posterImageView.contentMode = .scaleAspectFit
                    
                    self.posterImageView.layer.cornerRadius = 8
                    
                    print("Poster done")
                case.failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }

}// End of class
