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
    let uniqueKey: String
    let link: String
    let coordinate: CLLocationCoordinate2D
    
    init(_ studentInformation: [String: Any]?) {
        if let studentInformation = studentInformation,
            let firstName = studentInformation[ParseConstants.ParameterKeys.FIRST_NAME] as? String,
            let lastName = studentInformation[ParseConstants.ParameterKeys.LAST_NAME] as? String,
            let uniqueKey = studentInformation[ParseConstants.ParameterKeys.UNIQUE_KEY] as? String,
            let latitude = studentInformation[ParseConstants.ParameterKeys.LATITUDE] as? Double,
            let longitude = studentInformation[ParseConstants.ParameterKeys.LONGITUDE] as? Double,
            let link = studentInformation[ParseConstants.ParameterKeys.LINK] as? String {
            
            self.firstName = firstName
            self.lastName = lastName
            self.uniqueKey = uniqueKey
            self.link = link
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            self.firstName = ""
            self.lastName = ""
            self.uniqueKey = ""
            self.link = ""
            self.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            print("Result data not complete, skipping: \(studentInformation?.description ?? "unknown")")
        }
        
        super.init()
    }
    
    init(firstName: String, lastName: String, uniqueKey: String, link: String, location: CLLocationCoordinate2D) {
        self.firstName = firstName
        self.lastName = lastName
        self.uniqueKey = uniqueKey
        self.link = link
        self.coordinate = location
        
        super.init()
    }
    
    var title: String? {
        return "\(firstName) \(lastName)"
    }
    
    var subtitle: String? {
        return link
    }
    
    func hasCompleteInformation() -> Bool {
        return firstName != "" && lastName != "" && link != ""
    }
}
