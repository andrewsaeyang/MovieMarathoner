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
            print("Number of movies recieved: \(marathon!.movies.count)")
        }
    }
    
    var movies: [Movie] = [] // TODO: Set this into the singleton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - UITableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let marathon = marathon else {
            return 0
        }
//TESTRUN
        return marathon.movies.count
        //return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? WatchListTableViewCell,
        let marathon = marathon else { return UITableViewCell()}
        
        cell.movie = marathon.movies[indexPath.row]
        //cell.movie = movies[indexPath.row]
        //TEST RUN
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueID, sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let marathon = marathon else { return }
        
        if editingStyle == .delete{
            
            let movieToDelete = marathon.movieIDs[indexPath.row]
            
            MarathonController.shared.deleteReference(marathon: marathon, movieID: movieToDelete) { [weak self] result in
                
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
            
            //TESTRUN
            //let movieToSend = movies[indexPath.row]
            
            guard let marathon = marathon else {
                return
            }
            let movieToSend = marathon.movies[indexPath.row]
            
            destination.movie = movieToSend
        }
    }
    
    // MARK: - Helper Functions
    
    func updateView(){
        
        guard let marathon = marathon else { return }
        self.title = marathon.name
        //TESTRUN
        //fetchMovies()
        //tableView.reloadData()
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
                        //print(movie)
                        self?.tableView.reloadData()
                    case .failure(let error):
                        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                        
                    }
                }
            }
        }
    }
}// End of class
