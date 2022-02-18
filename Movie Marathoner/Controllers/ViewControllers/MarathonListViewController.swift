//
//  MarathonListViewController.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 2/2/22.
//

import UIKit

class MarathonListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private let cellID = "marathonListCell"
    private let segueID = "toMovieList"
    
    var marathons: [Marathon] = []
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        updateView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - Actions
    
    @IBAction func newMarathonButtonTapped(_ sender: Any) {
        presentAddNewMarathonAlertController()
    }
    
    // MARK: - UITable Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MarathonController.shared.marathons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = MarathonController.shared.marathons[indexPath.row].name
        content.secondaryText = "\(MarathonController.shared.marathons[indexPath.row].movieIDs.count) movies"
        
        cell.contentConfiguration = content
        return cell// TODO: MAKE A CELL
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueID, sender: self)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segueID{
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? WatchListViewController else { return }
            
            
            let moviesToSend = MarathonController.shared.marathons[indexPath.row].movieIDs
            
            destination.movieIDs = moviesToSend
        }
    }
    
    // MARK: - Helper Methods
    func presentAddNewMarathonAlertController(){
        let alertController = UIAlertController(title: "What do you want to name your new Marathon?", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Marathon name"
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { alert in
            print("Canceled completed")
        }
        
        let addAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            print("Submitted completed")
            
            guard let nameText = alertController.textFields?.first?.text, !nameText.isEmpty else { return }
            
            self.createMarathon(name: nameText)
            
            self.tableView.reloadData()
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func updateView(){
        fetchMarathons()
        
    }
    
    func createMarathon(name: String){
        MarathonController.shared.createMarathon(with: name) { (result) in
            switch result{
            case .success(let p):
                print(p)
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                
            }
        }
    }
    
    func fetchMarathons(){
        MarathonController.shared.fetchMarathons{ [weak self](result) in
            
            switch result{
            case .success(let p):
                print(p)
                self?.fetchReferences()
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            
        }
    }
    
    func fetchReferences(){
        
        for marathon in MarathonController.shared.marathons{
            MarathonController.shared.fetchMovieReferences(with: marathon) { [weak self] (result) in
                DispatchQueue.main.async {
                    switch result{
                        
                    case .success(let finish):
                        print(finish)
                        self?.tableView.reloadData()
                    case .failure(let error):
                        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    }
                }
            }
        }
    }
}// End of class
