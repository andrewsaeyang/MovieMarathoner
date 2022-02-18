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
    
    var movieIDs: [String] = []{
        didSet{
            updateView()
            print("Number of movies recieved: \(movieIDs.count)")
            
        }
    }
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UITableViewSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = movieIDs[indexPath.row] // TODO: ADD NAME
        content.secondaryText = "Secondary Text" // TODO: Add more info
        cell.contentConfiguration = content
        
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    // MARK: - Helper Functions
    
    func updateView(){
        for id in movieIDs{
            
            MovieAPIController.fetchMovie(with: id) { result in
                DispatchQueue.main.async {
                    
                    switch result{
                        
                    case .success(let movie):
                        print(movie)
                    case .failure(let error):
                        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    }
                }
            }
        }
    }
}// End of class
