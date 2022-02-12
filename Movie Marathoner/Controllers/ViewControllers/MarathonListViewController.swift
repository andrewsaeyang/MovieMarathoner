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
    
    var marathons: [Marathon] = []
    
    let firstMovie = Movie(originalTitle: "First Movie", posterPath: (URL.init(string: "/6FfCtAuVAW8XJjZ7eWeLibRLWTw.jpg")), overview: "This is the first movie", rating: 6.6, id: 123, runtime: 120, releaseDate: "1977-05-25")
    let secondMovie = Movie(originalTitle: "Second Movie", posterPath: (URL.init(string: "/6FfCtAuVAW8XJjZ7eWeLibRLWTw.jpg")), overview: "This is the first movie", rating: 6.6, id: 123, runtime: 120, releaseDate: "1977-05-25")
    
    let test1 = Marathon(movies:["MovieOne", "MovieTwo", "MovieThree"], name: "First Marathon")

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateView()
        
        
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
        
        return UITableViewCell()// TODO: MAKE A CELL
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
           
            self.createMarathon(with: self.test1.movies, name: nameText)
            
            self.tableView.reloadData()
                  
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func updateView(){
        //fetchMarathons()
    }
    
    func createMarathon(with movies: [String], name: String){
        MarathonController.shared.createMarathon(with: movies, name: name) { (result) in
            switch result{
            case .success(let p):
                print(p)
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                
            }
        }
    }
    func fetchMarathons(){
        MarathonController.shared.fetchAllMarathons { [weak self](result) in
            switch result{
                
            case .success(let p):
                print(p)
                self?.tableView.reloadData()
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
}
