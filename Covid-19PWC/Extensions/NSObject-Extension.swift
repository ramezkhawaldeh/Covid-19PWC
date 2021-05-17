//
//  NSObject-Extension.swift
//  Covid-19PWC
//
//  Created by Ramez Khawaldeh on 17/05/2021.
//

import Foundation

extension NSObject {

    static var dynamicTypeString: String {
        let string = String(describing: type(of: self.classForCoder()))
        return string.components(separatedBy: ".").first ?? string
    }
}
