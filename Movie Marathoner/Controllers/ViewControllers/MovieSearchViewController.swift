//
//  MovieSearchViewController.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 1/11/22.
//

import UIKit

class MovieSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    var hours: Int = -1
    
    private let cellID = "movieCell"
    private let segueID = "toRecommendation"
    
    private var movies: [Movie] = []
    private var debouncedSearch: Timer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    // MARK: - Helper Functions
    func fetchMovies(with searchTerm: String){
        MovieAPIController.searchMovies(with: searchTerm) { [weak self](result) in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                switch result{
                case .success(let results):
                    strongSelf.movies = results
                    strongSelf.tableView.reloadData()
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    // MARK: - Tableview DataSource Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? MovieSearchTableViewCell else { return UITableViewCell()}
        
        cell.movie = movies[indexPath.row]
        
        return cell
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Identifier
        if segue.identifier == segueID{
            
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? RecommendationViewController else { return }
            
            let selectedMovie = movies[indexPath.row]
            
            destination.movie = selectedMovie
            destination.marathonTime = hours
        }
    }
    
    
    
} // End of class

// MARK: - Search Bar Delegate Methods
extension MovieSearchViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            resetSearch()
            return
        }
        debouncedSearch?.invalidate()
        debouncedSearch = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            self.fetchMovies(with: searchText)
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetSearch()
        searchBar.resignFirstResponder()
    }
    
    func resetSearch(){
        debouncedSearch?.invalidate()
        debouncedSearch = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            self.movies = []
            self.tableView.reloadData()
        }
    }
}
