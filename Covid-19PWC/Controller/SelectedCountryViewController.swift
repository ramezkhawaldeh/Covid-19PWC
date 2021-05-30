//
//  SelectedCountryViewController.swift
//  Covid-19PWC
//
//  Created by Ramez Khawaldeh on 19/05/2021.
//

import UIKit
import SVGKit

class SelectedCountryViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var recoveredCasesLabel: UILabel!
    @IBOutlet var activeCasesLabel: UILabel!
    @IBOutlet var deadCasesLabel: UILabel!
    @IBOutlet var casesStackView: UIStackView!
    
    var country: String?
    var news: News?
    var countryData: Country?
    var cases: CovidCases?
    var date: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.isHidden = true
        self.casesStackView.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        guard let selectedCountry = country else { return }
        guard let date = date else { return }

        DispatchQueue.main.async {
            self.getCountryData(with: selectedCountry)
            self.getCases(date: date, country: selectedCountry)
            self.getNewsData(country: selectedCountry) { news in
                self.news = news
                DispatchQueue.main.async {
                    self.tableView.reloadData()

                }
            }
            
                
            
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

extension SelectedCountryViewController {
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
    
    func getCases(date: String, country: String) {
        //"https://api.covid19tracking.narrativa.com/api/\(date)/country/\(country)"
        if let url = URL(string:"https://api.covid19tracking.narrativa.com/api/\(date)/country/\(country)") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription as Any)
                    return
                }
                let cases = self.parseJSON(with: data)
                guard let openCases = cases?.dates.first?.value.countries.first?.value.today_open_cases else {return}
                guard let recoveredCases = cases?.dates.first?.value.countries.first?.value.today_recovered else {return }
                guard let deadCases = cases?.dates.first?.value.countries.first?.value.today_deaths else {return}
                DispatchQueue.main.async {
                    self.activeCasesLabel.text = "\(openCases)"
                    self.deadCasesLabel.text = "\(deadCases)"
                    self.recoveredCasesLabel.text = "\(recoveredCases)"
                    self.casesStackView.isHidden = false
                }
            }
            task.resume()
        }
    }

    private func parseJSON(with data: Data) -> CovidCases? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CovidCases.self, from: data)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
    
    private func getCountryData(with country: String) {
        if let url = URL(string: "https://restcountries.eu/rest/v2/name/\(country)?fields=name;flag;alpha3Code") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription)
                    return
                }
                self.countryData = self.parseCountryJSON(with: data)
            }
            task.resume()
        }
    }
    
    private func parseCountryJSON(with data: Data) -> Country? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([Country].self, from: data)
            return decodedData.first
        }
        catch {
            print(error)
            return nil
        }
    }
    
    private func getFlagImage(from string: String?) {
        var flagImage: UIImage? = nil
        if let flagURL = string {
            guard let url = URL(string: flagURL)
            else {
                print("Unable to create URL")
                return
            }
            
            do {
                let data = try Data(contentsOf: url, options: [])
                let flagSVGImage: SVGKImage = SVGKImage(data: data)
                flagImage = flagSVGImage.uiImage
                DispatchQueue.main.async {
                    self.imageView.image = flagImage
                    self.imageView.isHidden = false
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
        }

    }
}
