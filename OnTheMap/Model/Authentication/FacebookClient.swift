//
//  FacebookClient.swift
//  OnTheMap
//
//  Created by Stefan Jaindl on 27.05.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import FacebookCore
import FacebookLogin
import Foundation
import UIKit

class FacebookClient {
    static let sharedInstance = FacebookClient()
    
    let facebookLoginManager = LoginManager()
    
//    struct MyProfileRequest: GraphRequestProtocol {
//        struct Response: GraphResponseProtocol {
//            var firstName: String?
//            var lastName: String?
//
//            init(rawResponse: Any?) {
//                // Decode JSON from rawResponse
//                guard let response = rawResponse as? Dictionary<String, Any> else {
//                    return
//                }
//
//                if let name = response["first_name"] as? String {
//                    self.firstName = name
//                }
//
//                if let name = response["last_name"] as? String {
//                    self.lastName = name
//                }
//            }
//        }
//
//        var graphPath = "/me"
//        var parameters: [String : Any]? = ["fields": "id, first_name, last_name"]
//        var accessToken = AccessToken.current
//        var httpMethod: GraphRequestHTTPMethod = .GET
//        var apiVersion: GraphAPIVersion = .defaultVersion
//    }
    
    func login(withViewController viewController: UIViewController?, completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        facebookLoginManager.logIn(readPermissions: [.publicProfile], viewController: viewController) { (loginResult) in
            var errorString: String?
            
            switch loginResult {
            case .failed(let error):
                errorString = error.localizedDescription
            case .cancelled:
                // Login attempt was cancelled by the user.
                errorString = "Login cancelled"
            case .success( _, _, _):
                // User succesfully logged in. Contains granted, declined permissions and access token.
                //self.fetchUserData(withUserId: token.userId!, completionHandler: completionHandler)
                UdacityClient.sharedInstance.loginWithFacebook() { (success, error) in
                    if let errorString = errorString {
                        completionHandler(false, errorString)
                    } else {
                        completionHandler(true, nil)
                    }
                }
            }
        }
    }
    
//    func fetchUserData(withUserId userId: String?, completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
//        let connection = GraphRequestConnection()
//
//        connection.add(MyProfileRequest()) { (response, result) in
//            switch result {
//            case .success(let response):
//                AuthenticationClient.sharedInstance.personalInformation.firstName = response.firstName
//                AuthenticationClient.sharedInstance.personalInformation.lastName = response.lastName
//
//                completionHandler(true, nil)
//            case .failed(let error):
//                completionHandler(false, error.localizedDescription)
//            }
//        }
//
//        connection.start()
//    }
}
