//
//  NewsViewController.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 12/20/21.
//


import UIKit
import SkeletonView

class NewsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
        
    // MARK: - Propterties
    let reuseConstant = "newsArticleCell"
    var newsArticles: [Article] = []
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 128.5
        tableView.separatorColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        
        fetchNewsArticles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
        if newsArticles.isEmpty{
            tableView.isSkeletonable = true
            tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .silver), animation: nil, transition: .crossDissolve(0.25))
        }
    }
    
    // MARK: - Helper Methods
    func fetchNewsArticles(){
        BingNewsAPIController.fetchNews { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let news):
                    self.newsArticles = news.articles
                    
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
                self.tableView.stopSkeletonAnimation()
                self.view.hideSkeleton()
            }
        }
    }
} // End of class

extension NewsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseConstant, for: indexPath) as? NewsArticleTableViewCell else { return UITableViewCell()}
        cell.article = newsArticles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: newsArticles[indexPath.row].url){
            UIApplication.shared.open(url)
        }
    }
}// End of Extension

// MARK: - Skeleton TableView Data Source
extension NewsViewController: SkeletonTableViewDataSource{
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return reuseConstant
    }
}// End of Extension

