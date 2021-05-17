//
//  NewsTableViewCell.swift
//  Covid-19PWC
//
//  Created by Ramez Khawaldeh on 17/05/2021.
//

import UIKit

class NewsTableViewCellPOC: UITableViewCell, ReusableView, NibLoadableView {
    
    @IBOutlet var newsImageView: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var sourceName: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var url: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func config(with data: Article) {
        self.title.text = data.title
        self.sourceName.text = data.source.name
        self.descriptionLabel.text = data.description
        self.date.text = data.publishedAt
        self.url.text = data.url
        guard let imageURLString = data.urlToImage else {return}
        if let imageURL = URL(string: imageURLString) {
            print(imageURL)
            if let data = try? Data(contentsOf: imageURL) {
                print(data)
                self.newsImageView.image = UIImage(data: data)
            }
        }
    }
    
    
}
