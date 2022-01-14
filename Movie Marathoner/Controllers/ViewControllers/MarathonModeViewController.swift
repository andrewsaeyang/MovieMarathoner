//
//  MarathonModeViewController.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 1/10/22.
//

import UIKit

class MarathonModeViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var findMoviesButton: UIButton!
    
    // MARK: - Properties
    private let segueID = "toMovieSearch"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        findMoviesButton.isUserInteractionEnabled = false
        findMoviesButton.alpha = 0.5
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dissmissedKeyboard)))
        
      
    }

    // MARK: - Actions
    
    @IBAction func findMoviesButtonTapped(_ sender: Any) {
        guard let hours = textField.text, !hours.isEmpty else { return }
        // TODO: Validate that the number is an Integer > 0
        performSegue(withIdentifier: segueID, sender: self)
    }
    
    
    // MARK: - Helper Functions
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if text.isEmpty{
            findMoviesButton.isUserInteractionEnabled = false
            findMoviesButton.alpha = 0.5
        } else {
            findMoviesButton.isUserInteractionEnabled = true
            findMoviesButton.alpha = 1.0
            
        }
        
        
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return string.rangeOfCharacter(from: invalidCharacters) == nil
        
        
    }
    
    @objc func dissmissedKeyboard() {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segueID{
            guard let destination = segue.destination as? MovieSearchViewController,
                  let runTime = textField.text else { return }
            
            destination.hours = Int(runTime)!
            
        }
    }
}// End of class
