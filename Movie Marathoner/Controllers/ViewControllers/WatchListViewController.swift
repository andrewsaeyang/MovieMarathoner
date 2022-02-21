//
//  WatchListViewController.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 2/2/22.
//

import UIKit

class WatchListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private let cellID = "watchListCell"
    private let segueID = "toDetailView"
    
    var marathon: Marathon?{
        didSet{
            updateView()
            print("Number of movies recieved: \(marathon!.movieIDs.count)")
        }
    }
    
    var movies: [Movie] = [] // TODO: Set this into the singleton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - UITableViewSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = movies[indexPath.row].originalTitle // TODO: ADD NAME
        content.secondaryText = movies[indexPath.row].releaseDate // TODO: Add more info
        cell.contentConfiguration = content
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueID, sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let marathon = marathon else {
            return
        }
        
        
        if editingStyle == .delete{
            
            let movieToDelete = marathon.movieIDs[indexPath.row]
            
            MarathonController.shared.deleteReference(marathon: marathon, movieID: movieToDelete) { [weak self]result in
                
                DispatchQueue.main.async {
                    switch result{
                    case .success(let finish):
                        print(finish)
                        self?.fetchMovies()
                    case .failure(let error):
                        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Identifier
        if segue.identifier == segueID{
            
            // Index Path
            // Destination
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? MovieDetailViewController else { return }
            
            let movieToSend = movies[indexPath.row]
            
            destination.movie = movieToSend
        }
    }
    
    // MARK: - Helper Functions
    
    func updateView(){
        
        guard let marathon = marathon else { return }
        self.title = marathon.name
        fetchMovies()
    }
    
    func fetchMovies(){
        
        guard let marathon = marathon else { return }
        movies = []
        for id in marathon.movieIDs{
            MovieAPIController.fetchMovie(with: id.movieID) { [weak self] result in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let movie):
                        self?.movies.append(movie)
                        self?.tableView.reloadData()
                    case .failure(let error):
                        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                        
                    }
                }
            }
        }
    }
}// End of class
