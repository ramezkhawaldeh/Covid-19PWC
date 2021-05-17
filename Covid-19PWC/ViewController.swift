//
//  ViewController.swift
//  Covid-19PWC
//
//  Created by Ramez Khawaldeh on 17/05/2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var textField: UITextField!
    
    var country: Country?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func getDataButtonPressed(_ sender: Any) {
        guard let country = textField.text else { return }
        getData(with: country)
    }
}

extension ViewController {
    
    private func getData(with country: String) {
        if let url = URL(string: "https://restcountries.eu/rest/v2/name/\(country)?fields=name;flag;alpha3Code") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription)
                    return
                }
                self.country = self.parseJSON(with: data)
            }
            task.resume()
        }
    }
    
    private func parseJSON(with data: Data) -> Country? {
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
}
