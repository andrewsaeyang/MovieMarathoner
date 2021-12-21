//
//  FavoritesTableViewCell.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 12/20/21.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var favoriteFilm: Favorite?{
        didSet{
            updateView()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var filmTitle: UILabel!
    
    // MARK: - Helper Methods
    func updateView(){
        guard let favoriteFilm = favoriteFilm else { return }
        filmTitle.text = favoriteFilm.filmTitle
    }
    
}// End of class
