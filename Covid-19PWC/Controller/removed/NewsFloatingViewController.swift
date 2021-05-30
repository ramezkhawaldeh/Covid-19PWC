//
//  NewsFloatingViewController.swift
//  Covid-19PWC
//
//  Created by Ramez Khawaldeh on 17/05/2021.
//

import UIKit

class NewsFloatingViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var news: News?
    var flag: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isHidden = true
    }
    

}

extension NewsFloatingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news?.totalResults ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension NewsFloatingViewController {

    private func getData(with country: String) {
        if let url = URL(string: "https://newsapi.org/v2/top-headlines?country=\(country)&category=\(NewsCategory.health)&apiKey=\(APIKey.news.rawValue)") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription as Any)
                    return
                }
                self.news = self.parseJSON(with: data)
            }
            task.resume()
        }
    }
    
    private func parseJSON(with data: Data) -> News? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(News.self, from: data)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
}
