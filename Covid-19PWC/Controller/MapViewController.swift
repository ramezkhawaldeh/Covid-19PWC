//
//  MapViewController.swift
//  Covid-19PWC
//
//  Created by Ramez Khawaldeh on 17/05/2021.
//

import UIKit
import CoreLocation
import MapKit
import SVGKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let annotations = [MKPointAnnotation]()
    var country: String?
    var allCapitals = [AllCountries]()
    var covidCases: CovidCases?
    var capitals = [Capital]()
    var countryDetails: Country?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        mapView.delegate = self
        mapView.isHidden = true
        
        self.getAllCountriesData { flag in
            if flag {
                self.addCapitals(cases: self.covidCases)
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
            mapView.setRegion(region, animated: true)
            mapView.addAnnotations(annotations)
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
        let reuseIdentifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            let countryAnnotation = annotation as! Capital
            btn.accessibilityIdentifier = countryAnnotation.title
            btn.addTarget(self, action: #selector(openNewsPageButtonPressed(sender:)), for: .touchUpInside)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    @objc func openNewsPageButtonPressed(sender: UIButton) {
        self.country = sender.accessibilityIdentifier
        self.performSegue(withIdentifier: "goToSelectedCountry", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSelectedCountry" {
            if let viewController = segue.destination as? SelectedCountryViewController {
                let today = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let dateString = formatter.string(from: today)
                
                viewController.country = self.country
                viewController.date = dateString
            }
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let capital = view.annotation as? Capital else { return }
            let placeName = capital.title
            let placeInfo = capital.info
            self.performSegue(withIdentifier: "goToSelectedCountry", sender: self)
        }
    }
}


extension MapViewController {
    
    func addCapitals(cases: CovidCases?) {
        for country in allCapitals {
            guard let title = country.name, let coordinate = country.latlng, let cases = cases else { return }
            cases.dates.values.first?.countries.first?.value
            if !coordinate.isEmpty && covidCases != nil {
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
