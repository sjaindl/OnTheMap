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
    
    func loginWithCredentials(forUser user: String, password: String, completionHandler: @escaping (_ success: Bool, _ errorString: String) -> Void) {
        getUdacitySessionId(forUser: user, password: password) { (success, errorString, sessionId) in
            if success {
                //move on to next API call
                completionHandler(true, "")
            } else {
                completionHandler(false, errorString!)
            }
        }
    }
    
    func getUdacitySessionId(forUser user: String, password: String, completionHandler: @escaping (_ success: Bool, _ errorString: String?, _ sessionId: String) -> Void) {
        let url = WebClient.sharedInstance.createUrl(forMethod: UdacityConstants.Methods.POST_SESSION, withQueryItems: nil)
        var request = WebClient.sharedInstance.buildRequest(withUrl: url, withHttpMethod: UdacityConstants.ParameterKeys.HTTP_POST)
        let requestBody = [UdacityConstants.ParameterKeys.USERNAME: user, UdacityConstants.ParameterKeys.PASSWORD: password]
        
        request.httpBody = WebClient.sharedInstance.buildJson(from: requestBody, withKey: UdacityConstants.ParameterKeys.UDACITY)
        
        WebClient.sharedInstance.taskForWebRequest(request, errorDomain: "getUdacitySessionId", withOffset: 5) { (results, error) in
            
            /* Send the desired value(s) to completion handler */
            if let error = error {
                //unsuccessful sample responses
                //{"status": 403, "error": "Account not found or invalid credentials."}
                //{"status": 400, "error": "Failed to parse JSON body."}
                completionHandler(false, error.localizedDescription, "")
            } else {
                
                //successful sample response:
                //{"account": {"registered": true, "key": "8985380585"}, "session": {"id": "1557960201Sc034166577229ae8ac2a6e0a9e90114b", "expiration": "2018-07-14T22:43:21.686740Z"}}
                if let session = results?[UdacityConstants.ParameterKeys.SESSION] as? [String: Any], let sessionId = session[UdacityConstants.ParameterKeys.ID] as? String {
                    completionHandler(true, nil, sessionId)
                } else {
                    print("Could not find \(UdacityConstants.ParameterKeys.ID) in \(results!)")
                    completionHandler(false, "Login Failed (no Session ID).", "")
                }
            }
        }
    }
    
    
}
