//
//  Capital.swift
//  Covid-19PWC
//
//  Created by Ramez Khawaldeh on 18/05/2021.
//

import Foundation
import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String

    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
