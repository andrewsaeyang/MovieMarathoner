
//
//  AddMovieToMarathonViewController.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 2/20/22.
//

import UIKit
import CloudKit

class AddMovieToMarathonViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private let cellID = "marathonCell"
    var movie: Movie?
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    
    @IBAction func createMarathonButtonTapped(_ sender: Any) {
        
        presentAddNewMarathonAlertController()
    }
    
    @IBAction func addToMarathonTapped(_ sender: Any) {
        guard let movieid = movie?.id,
              let indexPath = tableView.indexPathForSelectedRow else { return }
        let selectedMarathon = MarathonController.shared.marathons[indexPath.row]
        let movieID = "\(movieid)" // TODO: FIX THIS
        
        MarathonController.shared.createMovieReferences(with: movieID, marathon: selectedMarathon) { result in
            DispatchQueue.main.async {
                
                switch result{
                case .success(let finish):
                    print(finish)
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    // MARK: - UITableView Datasource Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MarathonController.shared.marathons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = MarathonController.shared.marathons[indexPath.row].name
        cell.contentConfiguration = content
        
        return cell
    }
    
    // MARK: - Helper Functions
    
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
    
    func createMarathon(name: String){
        MarathonController.shared.createMarathon(with: name) { (result) in
            DispatchQueue.main.async {
                
                switch result{
                case .success(let finish):
                    print(finish)
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    
                }
            }
        }
    }
}// End of class
