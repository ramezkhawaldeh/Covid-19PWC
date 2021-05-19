//
//  SelectedCountryViewController.swift
//  Covid-19PWC
//
//  Created by Ramez Khawaldeh on 19/05/2021.
//

import UIKit

class SelectedCountryViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var sickLabel: UILabel!
    @IBOutlet var dead: UILabel!
    @IBOutlet var recovered: UILabel!
    
    var country: String?
    var news: News?
    var status: CovidCases?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let selectedCountry = country else { return }
        DispatchQueue.main.async {
            self.getNewsData(country: selectedCountry) { news in
                self.news = news
            }
        }
        
    }
    func getNewsData(country: String, completionHandler: @escaping (News?) -> Void) {
        if let url = URL(string: "https://newsapi.org/v2/top-headlines?\(country)&category=\(NewsCategory.health)&apiKey=\(APIKey.news.rawValue)") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { [weak self] data, response, error in
                let news: News?
                guard let data = data, error == nil else {
                    print(error?.localizedDescription)
                    return
                }
                news = self?.parseNewsJSON(with: data)
                completionHandler(news)
            }
            task.resume()
        }
    }
    
    private func parseNewsJSON(with data: Data) -> News? {
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
    
    extension SelectedCountryViewController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            guard let news = self.news else {return 0}
            return news.totalResults
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let news = self.news else {return UITableViewCell()}
            let cell: NewsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.fillDate(with: news.articles[indexPath.row])
            return cell
        }
    }

