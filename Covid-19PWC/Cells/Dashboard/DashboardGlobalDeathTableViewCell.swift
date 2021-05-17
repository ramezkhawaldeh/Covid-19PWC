//
//  DashboardGlobalDeathTableViewCell.swift
//  Covid-19PWC
//
//  Created by Ramez Khawaldeh on 17/05/2021.
//

import UIKit

class DashboardGlobalDeathTableViewCell: UITableViewCell, ReusableView, NibLoadableView {

    @IBOutlet var totalCasesLabel: UILabel!
    
    func fill(with cases: Double) {
        self.totalCasesLabel.text = "\(cases)"
    }
    
}
