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
        static let DOMAIN = "www.udacity.com"
    }
    
    struct Methods {
        static let POST_SESSION = "/api/session"
        static let PUBLIC_INFO = "/api/users/"
    }
    
    struct ParameterKeys {
        static let ACCEPT_TYPE = "Accept"
        static let CONTENT_TYPE = "Content-Type"
        static let HTTP_POST = "POST"
        static let HTTP_GET = "GET"
        
        static let UDACITY = "udacity"
        static let USERNAME = "username"
        static let PASSWORD = "password"
        static let SESSION = "session"
        
        static let STATUS = "status"
        static let ERROR = "error"
        static let ID = "id"
        
        static let ACCOUNT = "account"
        static let KEY = "key"
        static let USER = "user"
        static let LAST_NAME = "last_name"

    }
    
    struct ParameterValues {
        static let TYPE_JSON = "application/json"
        static let CONTENT_TYPE = "Content-Type"
    }
    
    //{"status": 403, "error": "Account not found or invalid credentials."}
    //{"status": 400, "error": "Failed to parse JSON body."}
    
    //{"account": {"registered": true, "key": "8985380585"}, "session": {"id": "1557960201Sc034166577229ae8ac2a6e0a9e90114b", "expiration": "2018-07-14T22:43:21.686740Z"}}
    
}
