//
//  Country.swift
//  Covid-19PWC
//
//  Created by Ramez Khawaldeh on 17/05/2021.
//

import Foundation

struct Country: Codable {
    let flag: String
    let name: String
    let alpha3Code: String
    let alpha2Code: String
}

struct Coordinates {
    var lat: Double?
    var lng: Double?
}


struct AllCountries {
    
    let flag: String?
    let name: String?
    let alpha3Code: String?
    let alpha2Code: String?
    let latlng: [Double]?
    
    init(_ data: [String: Any]) {
        self.flag = data["flag"] as? String
        self.name = data["name"] as? String
        self.alpha2Code = data["alpha2Code"] as? String
        self.alpha3Code = data["alpha3Code"] as? String
        self.latlng = data["latlng"] as? [Double]
    }
}


