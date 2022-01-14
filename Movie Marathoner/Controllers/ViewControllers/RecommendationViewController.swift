//
//  ReccomendationViewController.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 1/10/22.
//

import UIKit

class RecommendationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Outlets
    
    @IBOutlet weak var runTimeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - Properties
    var movie: Movie?{
        didSet{
            updateView()
        }
    }
    
    var marathonTime: Int = -1
    private var finalRunTime = -1
    private var movieRecommendations: [Movie] = []
    private var finalRecommendation: [Movie] = []
    
    private let cellID = "reccomendationCell"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //updateView()
        
    }
    
    // MARK: - Helper Methods
    func updateView(){
        guard let movie = movie else { return }
        if let movieID = movie.id{
            fetchRecommendations(with: "\(movieID)")
        }
    }
    
    //First Function
    func fetchRecommendations(with movieID: String){
        MovieAPIController.fetchRecommendations(with: movieID) { [weak self]result in
            
            DispatchQueue.main.async {
                switch result{
                case .success(let movies):
                    self?.translateData(with: movies)
                    print("Number of Recommendations found: \(movies.count)")
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    //second Function
    
    func translateData(with movieData: [Movie]){
        MovieAPIController.translateData(with: movieData) { result in
            self.movieRecommendations = result
            self.movieRecommendations.shuffle()
            self.configureRecommendation()
        }
    }

    func configureRecommendation(){
        marathonTime = marathonTime * 60
        
        for movie in movieRecommendations{
            if let runTime = movie.runtime{
                let doesTimeFit = runTime + finalRunTime
                
                if doesTimeFit <= marathonTime{
                    finalRecommendation.append(movie)
                    finalRunTime += runTime
                    print("Current runtime: \(countRunTime(for: finalRecommendation)) with \(finalRecommendation.count) movies")
                    
                }
            }
        }
        
        print(countRunTime(for: finalRecommendation))
        runTimeLabel.text = "Total runtime: \(printRunTime())"
        collectionView.reloadData()
    }
    
    func countRunTime(for marathon: [Movie]) -> Int {
        var retVal = 0
        
        for movie in finalRecommendation {
            if let time = movie.runtime{
                retVal += time
            }
        }
        return retVal
    }
    
    func printRunTime() -> String{
       
        let minuites = finalRunTime%60
        let hours = finalRunTime/60
        
        return "\(hours) hours \(minuites) minuites"
    }
    
    func printCheck(with movies: [Movie]) -> Void{
        for movie in movies{
            if let title = movie.originalTitle{
                print("\(title) Successfully fetched. Runtime \(movie.runtime!)")
            } else {
                print("\(movie.id!) Missing")
            }
        }
    }
}// End of class

extension RecommendationViewController{
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return finalRecommendation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? RecommendationCollectionViewCell else { return UICollectionViewCell()}
        
        cell.movie = finalRecommendation[indexPath.row]
        //cell.delegate = self
        return cell
    }
}

//MARK: - Collection View Flow Layout Delegate Methods
extension RecommendationViewController: UICollectionViewDelegateFlowLayout {
    
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
