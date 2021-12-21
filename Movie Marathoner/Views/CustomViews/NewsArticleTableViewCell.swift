//
//  NewsArticleTableViewCell.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 12/20/21.
//

import UIKit

class NewsArticleTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var article: Article?{
        didSet{
            updateView()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var providerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    // MARK: - Helper methods
    func updateView(){
        guard let article = article else { return }
        if let link = article.articleImage?.thumbnail.contentUrl {
            let url = URL(string: link)
            let data = try? Data(contentsOf: url!)
            
            if let imageData = data{
                let image = UIImage(data: imageData)
                articleImage.image = image
            }else{
                print("NO DATA FOR ARTICLE IMAGE")
            }
        } else {
            
            let defaultURL: URL = URL(string: "https://image.tmdb.org/t/p/w500/xi8z6MjzTovVDg8Rho6atJCcKjL.jpg")!
            let data = try? Data(contentsOf: defaultURL)
            
            if let imageData = data{
                let image = UIImage(data: imageData)
                articleImage.image = image
            }
        }
        
        articleImage.contentMode = .scaleAspectFit
        articleImage.layer.cornerRadius = 8
        
        providerLabel.text = article.provider[0].name
        
        dateLabel.text = article.datePublished
        articleTitle.text = article.name
        synopsisLabel.text = article.description
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssssss'Z'"
        let date = dateFormatter.date(from:article.datePublished)!
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        
        dateLabel.text = dateFormatterPrint.string(from: date)
    }
    
    func dateFormat(date1: String) -> Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss UTC"
        let date = dateFormatter.date(from:date1)!
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month,.day], from: date)
        
        let finalDate = calendar.date(from: components)!
        
        return finalDate
    }
}// End of class
