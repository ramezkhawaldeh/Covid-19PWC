//
//  MainViewController.swift
//  Covid-19PWC
//
//  Created by Ramez Khawaldeh on 17/05/2021.
//

import UIKit
import CoreLocation
import MapKit

class MainViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var cases: CovidCases?
    var country: String?
    var coordinates: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(DashboardGlobalDeathTableViewCell.self)
        tableView.register(DashboardGlobalRecoveryTableViewCell.self)
        tableView.register(DashboardTotalGlobalCasesTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.country = self.getReversedGeoLocation(coordinates: locationManager.location?.coordinate)
        guard let country = country else {return}
        self.getCases(country: country)
    }

    private func parseJSON(with data: Data) -> CovidCases? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CovidCases.self, from: data)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
    
    func getCases(country: String) {
        if let url = URL(string:"https://api.covid19tracking.narrativa.com/api/2020-05-22/country/\(country)") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription as Any)
                    return
                }
                
                self.cases = self.parseJSON(with: data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                }
            }
            task.resume()
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = cases else {
            return UITableViewCell()
        }
        switch indexPath.row {
        case 0:
            let cell: DashboardTotalGlobalCasesTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.fill(with: data.total.today_confirmed)
            return cell
        case 1:
            let cell: DashboardGlobalDeathTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.fill(with: data.total.today_deaths)
            return cell
        case 2:
            let cell: DashboardGlobalRecoveryTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.fill(with: data.total.today_recovered)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension MainViewController: CLLocationManagerDelegate {
 
    func getReversedGeoLocation(coordinates: CLLocationCoordinate2D?) -> String? {
        var country: String?
        guard let coordinates = coordinates else { return "" }
        geoCoder.reverseGeocodeLocation(CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)) { placemarks, _ in
            country = placemarks?.first?.country
        }
        return country
    }
}