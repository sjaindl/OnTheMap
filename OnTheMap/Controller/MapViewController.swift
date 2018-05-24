//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Stefan Jaindl on 23.05.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import CoreLocation
import GoogleMaps
import MapKit
import UIKit

class MapViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var map: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        // Do any additional setup after loading the view.
        ParseClient.sharedInstance.fetchStudentLocations() { (success, errorString, studentInformation) in
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

    //private func addPin(firstName: String, lastName: String, link: String, latitude: Double, longitude: Double) {
    private func addPin(_ studentInformation: [String: Any]?) {
        let studentInformation = StudentInformation(studentInformation)
        let marker = GMSMarker(position: studentInformation.coordinate)
        
        marker.title = studentInformation.title
        marker.snippet = studentInformation.subtitle
        marker.icon = UIImage(named: "icon_pin")
        marker.isFlat = true
        marker.map = map
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if let url = URL(string: marker.snippet!) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
