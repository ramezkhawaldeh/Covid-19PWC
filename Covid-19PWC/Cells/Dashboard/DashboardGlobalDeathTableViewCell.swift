//
//  DashboardGlobalDeathTableViewCell.swift
//  Covid-19PWC
//
//  Created by Ramez Khawaldeh on 17/05/2021.
//

import UIKit

class DashboardGlobalDeathTableViewCell: UITableViewCell, ReusableView, NibLoadableView {

    @IBOutlet var containerView: UIView!
    @IBOutlet var totalCasesLabel: UILabel!
    
    override func awakeFromNib() {
        containerView.layer.cornerRadius = 20
    }
    func fill(with cases: Double) {
        self.totalCasesLabel.text = "\(cases)"
    }
    
}
