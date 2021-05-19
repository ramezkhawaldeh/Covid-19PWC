//
//  NewsTableViewCell.swift
//  Covid-19PWC
//
//  Created by Ramez Khawaldeh on 17/05/2021.
//

import UIKit

class NewsTableViewCell: UITableViewCell, ReusableView, NibLoadableView {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var sourceLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var newsImageView: UIImageView!
    
    private var urlLink: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsImageView.layer.borderWidth = 4
        newsImageView.layer.borderColor = UIColor(named: "Image-Border")?.cgColor
    }
    
    func fillDate(with data: Article?) {
        titleLabel.text = data?.title
        sourceLabel.text = data?.source.name
        descriptionLabel.text = data?.description
        dateLabel.text = data?.publishedAt
        self.setNewsImage(url: data?.urlToImage)
        self.urlLink = data?.url
    }
    
    @IBAction func cellButtonPressed(_ sender: Any) {
        guard let url = self.urlLink else { return }
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func setNewsImage(url: String?) {
        guard let url = url else { return }
        if let imageURL = URL(string: url) {
            print(imageURL)
            if let data = try? Data(contentsOf: imageURL) {
                print(data)
                self.newsImageView.image = UIImage(data: data)
            }
        }
    }
}
