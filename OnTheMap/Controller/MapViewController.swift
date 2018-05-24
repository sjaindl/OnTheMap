//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Stefan Jaindl on 23.05.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ParseClient.sharedInstance.fetchStudentLocations() { (success, errorString, firstName, lastName, link, latitude, longitude) in
            if success {
                self.addPin(firstName: firstName!, lastName: lastName!, link: link!, latitude: latitude!, longitude: longitude!)
            } else {
                //show alertview with error message
                let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }

    private func addPin(firstName: String, lastName: String, link: String, latitude: Double, longitude: Double) {
        let studentInformation = StudentInformation(firstName: firstName, lastName: lastName, link: link, latitude: latitude, longitude: longitude)
        map.addAnnotation(studentInformation)
    }
}
