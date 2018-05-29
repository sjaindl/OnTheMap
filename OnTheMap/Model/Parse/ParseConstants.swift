//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Stefan Jaindl on 23.05.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import Foundation

struct ParseConstants {
    
    struct UrlComponents {
        static let PROTOCOL = "https"
        static let DOMAIN = "parse.udacity.com"
    }
    
    struct Methods {
        static let STUDENT_LOCATION = "/parse/classes/StudentLocation"
    }
    
    struct ParameterKeys {
        static let APPLICATION_ID = "X-Parse-Application-Id"
        static let API_KEY = "X-Parse-REST-API-Key"
        
        static let RESULTS = "results"
        static let FIRST_NAME = "firstName"
        static let LAST_NAME = "lastName"
        static let LATITUDE = "latitude"
        static let LONGITUDE = "longitude"
        static let LINK = "mediaURL"
        static let UNIQUE_KEY = "uniqueKey"
        static let OBJECT_ID = "objectId"
        
        static let ORDER = "order"
        static let CREATED_AT = "createdAt"
    }
    
    struct ParameterValues {
        static let APPLICATION_ID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let API_KEY = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        static let UPDATED_AT = "-updatedAt"
    }
}
