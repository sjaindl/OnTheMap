//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Stefan Jaindl on 15.05.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import Foundation

class AuthenticationClient {
    
    static let sharedInstance = AuthenticationClient()
    
    struct PersonalInformation {
        var udacitySessionId: String?
        var userId: String?
        var firstName: String?
        var lastName: String?
        var uniqueKey: String?
        
        mutating func clear() {
            udacitySessionId = nil
            userId = nil
            firstName = nil
            lastName = nil
            uniqueKey = nil
        }
    }
    
    var personalInformation = PersonalInformation()
    
    func logout(completionHandler: @escaping (_ success: Bool, _ errorString: String) -> Void) {
        if AuthenticationClient.sharedInstance.personalInformation.udacitySessionId != nil {
            UdacityClient.sharedInstance.logout(completionHandler: completionHandler)
        }
        FacebookClient.sharedInstance.facebookLoginManager.logOut()
    }
    
    func reset() {
        personalInformation.clear()
    }
}
