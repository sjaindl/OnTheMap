//
//  Constants.swift
//  OnTheMap
//
//  Created by Stefan Jaindl on 15.05.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import Foundation

struct UdacityConstants {
    static let UDACITY_SIGNUP_LINK = "https://www.udacity.com/account/auth#!/signup"
    
    struct UrlComponents {
        static let PROTOCOL = "https"
        static let DOMAIN = "onthemap-api.udacity.com"
    }
    
    struct Methods {
        static let SESSION = "/v1/session"
        static let PUBLIC_INFO = "/v1/users/"
    }
    
    struct ParameterKeys {
        static let FACEBOOK_MOBILE = "facebook_mobile"
        static let FACEBOOK_ACCESS_TOKEN = "access_token"
        
        static let UDACITY = "udacity"
        static let USERNAME = "username"
        static let PASSWORD = "password"
        static let SESSION = "session"
        
        static let ID = "id"
        
        static let ACCOUNT = "account"
        static let KEY = "key"
        static let USER = "user"
        
        static let FIRST_NAME = "first_name"
        static let LAST_NAME = "last_name"
        static let XSRF_TOKEN = "XSRF-TOKEN"
        static let X_XSRF_TOKEN = "X-XSRF-TOKEN"
        
        static let WHERE = "where"
        static let UNIQUE_KEY = "uniqueKey"
        static let FIRSTNAME = "firstName"
        static let LASTNAME = "lastName"
        static let MAPSTRING = "mapString"
        static let MEDIA_URL = "mediaURL"
        static let LATITUDE = "latitude"
        static let LONGITUDE = "longitude"
    }
}
