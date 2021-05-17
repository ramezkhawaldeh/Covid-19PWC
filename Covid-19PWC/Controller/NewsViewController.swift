//
//  NewsViewController.swift
//  Covid-19PWC
//
//  Created by Ramez Khawaldeh on 17/05/2021.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
