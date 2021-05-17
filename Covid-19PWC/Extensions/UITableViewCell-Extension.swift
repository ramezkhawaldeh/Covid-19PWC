//
//  UITableViewCell-Extension.swift
//  Covid-19PWC
//
//  Created by Ramez Khawaldeh on 17/05/2021.
//

import UIKit

extension UITableViewCell {

    static var nib: UINib {
        return UINib(nibName: self.dynamicTypeString, bundle: nil)
    }
    
    static var cellIdentifier: String {
        return self.dynamicTypeString
    }
}
