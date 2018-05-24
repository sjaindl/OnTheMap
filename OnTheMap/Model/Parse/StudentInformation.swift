//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Stefan Jaindl on 24.05.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import Foundation
import MapKit

class StudentInformation: NSObject, MKAnnotation {
    let firstName: String
    let lastName: String
    let link: String
    var coordinate: CLLocationCoordinate2D
    
    init(firstName: String, lastName: String, link: String, latitude: Double, longitude: Double) {
        self.firstName = firstName
        self.lastName = lastName
        self.link = link
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        super.init()
    }
    
    var title: String? {
        return "\(firstName) \(lastName)"
    }
    
    var subtitle: String? {
        return link
    }
}
