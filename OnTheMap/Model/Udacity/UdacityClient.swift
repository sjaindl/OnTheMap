//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Stefan Jaindl on 15.05.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import Foundation

class UdacityClient {
    
    static let sharedInstance = UdacityClient()
    
    var sessionId: String?
    var userId: String?
    
    func loginWithCredentials(forUser user: String, password: String, completionHandler: @escaping (_ success: Bool, _ errorString: String) -> Void) {
        getSessionAndUserId(forUser: user, password: password) { (success, errorString, sessionId, userId) in
            if success {
                self.sessionId = sessionId
                self.userId = userId
                
                self.getPublicUserData() { (success, errorString, lastName) in
                    if success {
                        completionHandler(true, "")
                    } else {
                        completionHandler(false, errorString!)
                    }
                }
            } else {
                completionHandler(false, errorString!)
            }
        }
    }
    
    func getSessionAndUserId(forUser user: String, password: String, completionHandler: @escaping (_ success: Bool, _ errorString: String?, _ sessionId: String?, _ userId: String?) -> Void) {
        let url = WebClient.sharedInstance.createUrl(forScheme: UdacityConstants.UrlComponents.PROTOCOL, forHost: UdacityConstants.UrlComponents.DOMAIN, forMethod: UdacityConstants.Methods.POST_SESSION, withQueryItems: nil)
        var request = WebClient.sharedInstance.buildRequest(withUrl: url, withHttpMethod: WebConstants.ParameterKeys.HTTP_POST)
        let requestBody = [UdacityConstants.ParameterKeys.USERNAME: user, UdacityConstants.ParameterKeys.PASSWORD: password]
        
        request.httpBody = WebClient.sharedInstance.buildJson(from: requestBody, withKey: UdacityConstants.ParameterKeys.UDACITY)
        
        WebClient.sharedInstance.taskForWebRequest(request, errorDomain: "getUdacitySessionId", withOffset: 5) { (results, error) in
            
            /* Send the desired value(s) to completion handler */
            if let error = error {
                //unsuccessful sample responses
                //{"status": 403, "error": "Account not found or invalid credentials."}
                //{"status": 400, "error": "Failed to parse JSON body."}
                completionHandler(false, error.localizedDescription, nil, nil)
            } else {
                //successful sample response:
                //{"account": {"registered": true, "key": "8985380585"}, "session": {"id": "1557960201Sc034166577229ae8ac2a6e0a9e90114b", "expiration": "2018-07-14T22:43:21.686740Z"}}
                if let session = results?[UdacityConstants.ParameterKeys.SESSION] as? [String: Any], let sessionId = session[UdacityConstants.ParameterKeys.ID] as? String, let account = results?[UdacityConstants.ParameterKeys.ACCOUNT] as? [String: Any], let userId = account[UdacityConstants.ParameterKeys.KEY] as? String {
                    completionHandler(true, nil, sessionId, userId)
                } else {
                    print("Could not find \(UdacityConstants.ParameterKeys.ID) in \(results!)")
                    completionHandler(false, "Login Failed (no Session or user ID).", nil, nil)
                }
            }
        }
    }
    
    func getPublicUserData(completionHandler: @escaping (_ success: Bool, _ errorString: String?, _ lastName: String) -> Void) {
        let url = WebClient.sharedInstance.createUrl(forScheme: UdacityConstants.UrlComponents.PROTOCOL, forHost: UdacityConstants.UrlComponents.DOMAIN, forMethod: UdacityConstants.Methods.PUBLIC_INFO + String(userId!), withQueryItems: nil)
        
        let request = WebClient.sharedInstance.buildRequest(withUrl: url, withHttpMethod: WebConstants.ParameterKeys.HTTP_GET)
        
        WebClient.sharedInstance.taskForWebRequest(request, errorDomain: "getPublicUserData", withOffset: 5) { (results, error) in
            
            /* Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(false, error.localizedDescription, "")
            } else {
                if let user = results?[UdacityConstants.ParameterKeys.USER] as? [String: Any], let lastName = user[UdacityConstants.ParameterKeys.LAST_NAME] as? String {
                    completionHandler(true, nil, lastName)
                } else {
                    print("Could not find \(UdacityConstants.ParameterKeys.LAST_NAME) in \(results!)")
                    completionHandler(false, "No public profile info found.", "")
                }
            }
        }
    }
}
