//
//  NewsViewController.swift
//  Covid-19PWC
//
//  Created by Ramez Khawaldeh on 17/05/2021.
//

import UIKit

class NewsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var countryTextField: UITextField!
    
    var news: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        tableView.register(NewsTableViewCell.self)
    }
    
    @IBAction func didPressGoButton(_ sender: Any) {
        guard let countryText = countryTextField.text else { return }
        self.tableView.isHidden = true
        getCases()
        reloadData()
//        getData(with: countryText) {
//            self.reloadData()
//        }
    }
    
    private func getData(with country: String, completionHandler: @escaping () -> Void = {}) {
        if let url = URL(string: "https://newsapi.org/v2/top-headlines?country=\(country)&category=\(NewsCategory.health)&apiKey=\(APIKey.news.rawValue)") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription)
                    return
                }
                self.news = self.parseJSON(with: data)
            }
            task.resume()
            completionHandler()
        }
    }
    
    private func reloadData() {
        self.tableView.reloadData()
        self.tableView.isHidden = false
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

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let newsData = self.news, newsData.totalResults > 0 else {
            return UITableViewCell()
        }
        let cell: NewsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.config(with: newsData.articles[indexPath.row])
        return cell
    }
}

extension NewsViewController {
    
    private func parseJSON2(with data: Data) -> CovidCases? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CovidCases.self, from: data)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
    
    func getCases() {
        if let url = URL(string:"https://api.covid19tracking.narrativa.com/api/2020-05-22/country/jordan") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription)
                    return
                }
                //print(String(data: data, encoding: .utf8))
                print(self.parseJSON2(with: data))
            
            }
            task.resume()
        }
//        let url = URL(string: "https://api.covid19tracking.narrativa.com/api/2020-05-22/country/jordan")
//        let task = URLSession(configuration: .default).dataTask(with: url!) {(data, response, error) in
//
//            do {
//                // make sure this JSON is in the format we expect
//                guard let data = data else {return}
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                    // try to read out a string array
//                    if let names = json["names"] as? [String] {
//                        print(names)
//                    }
//                }
//            } catch let error as NSError {
//                print("Failed to load: \(error.localizedDescription)")
//            }
//        }
//        task.resume()
        
       
    }
}
