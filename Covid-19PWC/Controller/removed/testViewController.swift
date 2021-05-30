//
//  testViewController.swift
//  Covid-19PWC
//
//  Created by Ramez Khawaldeh on 18/05/2021.
//

import UIKit

class testViewController: UIViewController {

  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
       // print(countriesList)
    }
    

    private func getData() {
        if let url = URL(string: "https://restcountries.eu/rest/v2/all") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription)
                    return
                }
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String: Any]]
                    var c = [AllCountries]()
                    if let js = jsonResult {
                        for d in js {
                            let data = AllCountries(d)
                            c.append(data)
                        }
                        
                    }
                } catch {}
            }
            task.resume()
        }
    }

}
