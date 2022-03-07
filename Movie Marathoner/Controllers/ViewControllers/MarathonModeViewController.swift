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
        
        fetchMarathons()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MarathonModeViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MarathonModeViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    // MARK: - Actions
    
    @IBAction func findMoviesButtonTapped(_ sender: Any) {
        guard let hours = textField.text, !hours.isEmpty else { return }
        // TODO: Validate that the number is an Integer > 0
        performSegue(withIdentifier: segueID, sender: self)
    }
    
    // MARK: - Helper Functions
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        //self.view.frame.origin.y = 0 - keyboardSize.height
        let keyboardHeight = keyboardSize.height
        let bottomSpace = self.view.frame.height - (findMoviesButton.frame.origin.y + findMoviesButton.frame.height)
        self.view.frame.origin.y -= keyboardHeight - bottomSpace + 10
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.view.frame.origin.y = 0
    }
    
    @objc func dissmissedKeyboard() {
        textField.resignFirstResponder()
    }
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func fetchMarathons(){
        MarathonController.shared.fetchMarathons{ [weak self](result) in
            
            switch result{
            case .success(let finish):
                print(finish)
                self?.fetchReferences()
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    func fetchReferences(){
        for marathon in MarathonController.shared.marathons{
            MarathonController.shared.fetchMovieReferences(with: marathon) { result in
                
                switch result{
                case .success(let finish):
                    print(finish)
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
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
