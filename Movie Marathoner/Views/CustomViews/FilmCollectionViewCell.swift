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
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var filmImageView: UIImageView!
    
    // MARK: - PROPERTIES
    var movie: Movie?
    var film: Film?{
        didSet{
            updateViews()
        }
    }
    
    weak var delegate: ReloadCollectionDelegate?
    
    //Default poster if movie poster comesback nil
    let defaultURL: URL = URL(string: "https://image.tmdb.org/t/p/w500/xi8z6MjzTovVDg8Rho6atJCcKjL.jpg")!
    
    //false = "Only Yesterday". true = "The Cat Returns"
    private var isCat: Bool = false
    
    // MARK: - Actions
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        guard let film = film else { return }
        //On load, compare if film being loaded is in the favorites list, if so, mark the heart as favorited
        //on tap, check if filmID is in the favorites array. if false, then crete new ckRecord. if true, remove it.
        //if
        
        favoriteHelper(with: film)
        setFavoriteButton(for: film)
        
    }
    // MARK: - Helper Methods
    
    ///This function checks for a matching film and determins if it needs to create a ckRecord with that film or remove a ckRecord of that film
    func favoriteHelper(with film: Film){
        
        //case: There is a matching film
        if FavoriteController.shared.doesContain(film: film){
            
            FavoriteController.shared.deleteFavorite(favorite: FavoriteController.shared.getFavoriteFromSource(with: film)) { result in
                DispatchQueue.main.async {
                    switch result{
                    
                    case .success(let message):
                        print(message)
                    //self.setFavoriteButton(for: film)
                    case .failure(let error):
                        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    }
                }
            }
            
        }else{
            FavoriteController.shared.createFavorite(with: film.id, title: film.title) { result in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let message):
                        print(message)
                    //self.setFavoriteButton(for: film)
                    case .failure(let error):
                        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    }
                }
            }
        }
    }
    
    func updateViews(){
        guard let film = film else { return }
        
        //Because films "Only Yesterday and "The Cat Returns" fail at fetching posters, this is my work around for setting thier respective posters
        if film.id == "4e236f34-b981-41c3-8c65-f8c9000b94e7" { isCat.toggle()}
        
        //setFavoriteButton(for: film)
        setHearts(for: film)
        MovieAPIController.fetchMovies(with: film.originalTitle) { (result) in
            
            //dispatch has to do with the view. if in background thread CANNOT UPDATE VIEW. print statemetns are okay, code changes are okay.
            
            DispatchQueue.main.async {
                switch result{
                
                case .success(let movie):
                    
                    if movie.id != 15370 {self.isCat.toggle()}
                    
                    self.fetchPoster(for: movie)
                    
                case .failure(let error):
                    
                    self.fetchPoster(with: self.isCat)
                    
                    print("Film collection view Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    func fetchPoster(for movie: Movie){
        //move into own function (param of movie) pass in move[0]
        MovieAPIController.fetchMoviePoster(with: movie.posterPath ?? defaultURL) { [weak self]result in
            
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
    
    func fetchPoster(with isCat: Bool){
        MovieAPIController.fetchMoviePoster(for: isCat) { [weak self]result in
            
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
    
    func setFavoriteButton(for film: Film){
        if FavoriteController.shared.doesContain(film: film){
            
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }else{
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            
        }
    }
    
    //This function finds finds all the matching filmIDs stored in the favorites array and changes the hearts into heart.fill
    func setHearts(for film: Film){
        if FavoriteController.shared.doesContain(film: film){
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
}// End of class

