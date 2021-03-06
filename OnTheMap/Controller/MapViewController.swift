//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Stefan Jaindl on 23.05.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import CoreLocation
import FacebookCore
import FacebookLogin
import GoogleMaps
import MapKit
import UIKit

class MapViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var map: GMSMapView!
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        fetchData()
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        FacebookClient.sharedInstance.facebookLoginManager.logOut()
        
        AuthenticationClient.sharedInstance.logout() { (success, error) in
            if success {
                AuthenticationClient.sharedInstance.reset()
                performUIUpdatesOnMain {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                performUIUpdatesOnMain {
                    //show alertview with error message
                    let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        map.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    private func fetchData() {
        ParseClient.sharedInstance.studentInformation.removeAll()
        map.clear()
        
        ParseClient.sharedInstance.fetchStudentLocations() { (success, errorString, studentInformation) in
            performUIUpdatesOnMain {
                if success {
                    self.addPin(studentInformation)
                } else {
                    //show alertview with error message
                    let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }

    private func addPin(_ studentInformation: [String: Any]?) {
        let studentInformation = StudentInformation(studentInformation)
        if studentInformation.hasCompleteInformation() {
            //append valid entries to the studentInformation array
            ParseClient.sharedInstance.addStudentInfo(studentInformation)
            
            let marker = GMSMarker(position: studentInformation.coordinate)
            
            marker.title = studentInformation.title
            marker.snippet = studentInformation.subtitle
            marker.icon = UIImage(named: "icon_pin")
            marker.isFlat = true
            marker.map = map
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard var urlString = marker.snippet else {
            return
        }
        
        if !(urlString.hasPrefix("http://") || urlString.hasPrefix("https://")) {
            urlString = "http://\(urlString)"
        }
        
        UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
    }
}
