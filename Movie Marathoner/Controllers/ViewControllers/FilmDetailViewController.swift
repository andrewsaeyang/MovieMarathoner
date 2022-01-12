//
//  FilmDetailViewController.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 12/20/21.
//

import UIKit
import SkeletonView

class FilmDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var filmImageView: UIImageView!
    @IBOutlet weak var filmTitleLabel: UILabel!
    @IBOutlet weak var filmYearLabel: UILabel!
    @IBOutlet weak var synopsisTextView: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    // MARK: - Properties
    var movie: Movie?
    var castMembers: [Cast] = []
    
    let defaultURL: URL = URL(string: "https://image.tmdb.org/t/p/w500/xi8z6MjzTovVDg8Rho6atJCcKjL.jpg")!
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        if filmTitleLabel.text == "(title)"{
            
            fireSkeleton()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"{
            if let newValue = change?[.newKey]{
                let newSize = newValue as! CGSize
                tableViewHeight.constant = newSize.height
            }
        }
    }
    
    // MARK: - Helper Methods
    func updateViews(){
        
        guard let movie = movie else { return }
        
        title = movie.originalTitle
        filmTitleLabel.text = movie.originalTitle
        filmYearLabel.text = "TODO" // TODO: Add year release
        synopsisTextView.text = movie.overview
        tableView.reloadData()
        
        fetchPoster(for: movie)
        fetchCastMembers(for: movie)
        
        
    }
    
    func fireSkeleton(){
        filmImageView.isSkeletonable = true
        filmTitleLabel.isSkeletonable = true
        filmYearLabel.isSkeletonable = true
        synopsisTextView.isSkeletonable = true
        
        filmImageView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .silver), animation: nil, transition: .crossDissolve(0.25))
        filmTitleLabel.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .silver), animation: nil, transition: .crossDissolve(0.25))
        filmYearLabel.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .silver), animation: nil, transition: .crossDissolve(0.25))
        synopsisTextView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .silver), animation: nil, transition: .crossDissolve(0.25))
    }
    
    
    func fetchPoster(for movie: Movie){
        MovieAPIController.fetchMoviePoster(with: movie.posterPath ?? defaultURL) { [weak self]result in
            DispatchQueue.main.async {
                switch result{
                    
                case .success(let image):
                    self?.view.contentMode = .scaleAspectFill
                    
                    self?.filmImageView.image = image
                    self?.filmImageView.contentMode = .scaleAspectFill
                    self?.filmImageView.layer.cornerRadius = 8
                case .failure(let error):
                    print("Error IMAGE in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
                self!.filmImageView.stopSkeletonAnimation()
                self!.filmTitleLabel.stopSkeletonAnimation()
                self!.filmYearLabel.stopSkeletonAnimation()
                self!.synopsisTextView.stopSkeletonAnimation()
                self!.view.hideSkeleton()
                
            }
        }
    }
    
    func fetchCastMembers(for movie: Movie){
        MovieAPIController.fetchCastMembers(for: movie.id!) { (result) in
            DispatchQueue.main.async {
                
                switch result{
                case .success(let cast):
                    self.castMembers = cast
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
            
        }
    }
} // End of class

extension FilmDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return castMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "actorCell", for: indexPath) as? VoiceActorTableViewCell else { return UITableViewCell()}
        
        //cell.nameLabel.text = castMembers[indexPath.row].name
        //cell.roleLabel.text = castMembers[indexPath.row].character
        
        cell.castMember = castMembers[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}// End of Extension
