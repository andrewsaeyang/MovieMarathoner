//
//  HomeViewController.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 12/6/21.
//

import UIKit
import SkeletonView

class CatalogViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    var movies: [Movie] = []
    var filteredMovies: [Movie] = []
    var castMemebers: [Cast]?
    let highPriorityQueue = DispatchQueue.global(qos: .userInitiated)
    
    private var debouncedSearch: Timer?
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        collectionView.isSkeletonable = true
        self.title = "Catalog"
        
        collectionView.keyboardDismissMode = .onDrag
        //        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        //        tap.cancelsTouchesInView = false
        //        view.addGestureRecognizer(tap)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        if filteredMovies.isEmpty{
        //
        //            collectionView.isSkeletonable = true
        //            collectionView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .concrete), animation: nil, transition: .crossDissolve(0.25))
        //            //collectionView.showSkeleton(usingColor: .wetAsphalt, transition: .crossDissolve(0.25))
        //
        //        }
    }
    
    // MARK: - Actions
    
    
    // MARK: - Helper Methods
    func fetchMovies(with searchTerm: String){
        
        MovieAPIController.searchMovies(with: searchTerm) { [weak self](result) in
            DispatchQueue.main.async {
                switch result{
                case .success(let movies):
                    self?.filteredMovies = movies
                    // self?.collectionView.reloadData()
                    // self?.skeletonOff()
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
                
                self?.collectionView.reloadData()
                self?.skeletonOff()
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filmCell", for: indexPath) as? FilmCollectionViewCell else { return UICollectionViewCell()}
        
        cell.movie = filteredMovies[indexPath.row]
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let cell = sender as? FilmCollectionViewCell,
                  let indexPath = collectionView.indexPath(for: cell),
                  let destination = segue.destination as? MovieDetailViewController else { return }
            
            let filmToSend = filteredMovies[indexPath.row]
            
            destination.movie = filmToSend
        }
    }
} // End of class

//MARK: - Collection View Flow Layout Delegate Methods
extension CatalogViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //we want 90% of the screen to be used, / 2 - 45%
        
        let width = view.frame.width * 0.45
        
        return CGSize(width: width, height: width * 3/2 )
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let width = view.frame.width * 0.45
        let cellsTotalWidth = width * 2
        let leftOverWidth = view.frame.width - cellsTotalWidth
        let inset = leftOverWidth / 3
        //insets == padding
        return UIEdgeInsets(top: inset, left: inset, bottom: 0, right: inset)
    }
} //End of extension

// MARK: - Skeleton CollectionView Data Source Function
extension CatalogViewController: SkeletonCollectionViewDataSource{
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "filmCell"
    }
    
    func skeletonOn(){
        view.showSkeleton()
        collectionView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .concrete), animation: nil, transition: .crossDissolve(0.25))
        //collectionView.showSkeleton(usingColor: .wetAsphalt, transition: .crossDissolve(0.25))
        
    }
    
    func skeletonOff(){
        collectionView.stopSkeletonAnimation()
        view.hideSkeleton()
    }
}

// MARK: - Search Bar Delegate Methods
extension CatalogViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filteredMovies = movies
        
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else {
            self.collectionView.reloadData()
            return
        }
        //skeletonOn()
        debouncedSearch?.invalidate()
        
        debouncedSearch = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            
            self.fetchMovies(with: searchTerm)
            
            self.collectionView.reloadData()
            //self.skeletonOff()
            
        })
    } 
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredMovies = movies
        collectionView.reloadData()
        skeletonOff()
        searchBar.resignFirstResponder()
    }
} //End of extension
