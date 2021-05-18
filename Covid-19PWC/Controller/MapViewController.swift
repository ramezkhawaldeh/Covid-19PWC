//
//  MapViewController.swift
//  Covid-19PWC
//
//  Created by Ramez Khawaldeh on 17/05/2021.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let annotations = [MKPointAnnotation]()
    var country: String?
    var allCapitals = [AllCountries]()
 
    var capitals = [Capital]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        mapView.delegate = self
        mapView.isHidden = true
        
        //self.addCapitals
        self.getAllCountriesData { flag in
            if flag {
            self.addCapitals()
            }
        }
        
    }
   
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let region = MKCoordinateRegion(center: location.coordinate,
                                            latitudinalMeters: 50,
                                            longitudinalMeters: 50)
            //self.fetchAnnotations()
            mapView.setRegion(region, animated: true)
            mapView.addAnnotations(annotations)
//            annotation.coordinate = location.coordinate
//            mapView.addAnnotation(annotation)
            mapView.isHidden = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                //4
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true

                // 5
                let btn = UIButton(type: .detailDisclosure)
                annotationView?.rightCalloutAccessoryView = btn
            } else {
                // 6
                annotationView?.annotation = annotation
            }

            return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        let placeName = capital.title
        let placeInfo = capital.info

        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

extension MapViewController {
    
    func addCapitals() {
        for country in allCapitals {
            guard let title = country.name, let coordinate = country.latlng else { return }
            print(country)
            if !coordinate.isEmpty {
                capitals.append(Capital(title: title, coordinate: CLLocationCoordinate2D(latitude: coordinate[0], longitude: coordinate[1]), info: ""))
            }
        }
        mapView.addAnnotations(self.capitals)
    }
    
    private func getAllCountriesData(completion: @escaping (Bool) -> Void) {
        if let url = URL(string: "https://restcountries.eu/rest/v2/all") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription as Any)
                    return
                }
                
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String: Any]]
                    if let result = jsonResult {
                        for country in result {
                            let data = AllCountries(country)
                            self.allCapitals.append(data)
                        }
                        completion(true)
                    }
                } catch {
                    print("Unable to parse country data!")
                }
                
            }
            task.resume()
        }
    }
//   private func getImage(from string: String) -> UIImage? {
//        var flagImage: UIImage? = nil
//        guard let url = URL(string: string)
//        else {
//            print("Unable to create URL")
//            return nil
//        }
//
//        do {
//            let data = try Data(contentsOf: url, options: [])
//            let flagSVGImage: SVGKImage = SVGKImage(data: data)
//            flagImage = flagSVGImage.uiImage
//        }
//        catch {
//            print(error.localizedDescription)
//        }
//        return flagImage
//    }
    
    
    
    
}
extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
