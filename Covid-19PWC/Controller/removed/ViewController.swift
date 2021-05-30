//
//  ViewController.swift
//  Covid-19PWC
//
//  Created by Ramez Khawaldeh on 17/05/2021.
//

import UIKit
import SVGKit

class ViewController: UIViewController {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    var country: Country?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func getDataButtonPressed(_ sender: Any) {
        guard let countryText = textField.text else { return }
        getData(with: countryText)
        guard let flagURL = self.country?.flag else { return }
        imageView.image = getImage(from: flagURL)
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
    
   private func getImage(from string: String) -> UIImage? {
        var flagImage: UIImage? = nil
        guard let url = URL(string: string)
        else {
            print("Unable to create URL")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url, options: [])
            let flagSVGImage: SVGKImage = SVGKImage(data: data)
            flagImage = flagSVGImage.uiImage
        }
        catch {
            print(error.localizedDescription)
        }
        return flagImage
    }
}
