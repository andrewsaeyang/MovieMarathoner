//
//  MovieSearchTableViewCell.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 1/11/22.
//

import UIKit

class MovieSearchTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // MARK: - Properties
    var movie: Movie?{
        didSet{
            updateView()
        }
    }
    
    func updateView(){
        guard let movie = movie else { return }
        titleLabel.text = movie.originalTitle
        releaseDateLabel.text = movie.releaseDateFormatted
        scoreLabel.text = "\(movie.rating ?? 0.0)"
    }
}// End of class
