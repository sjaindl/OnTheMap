//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Stefan Jaindl on 27.05.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import FacebookCore
import Foundation

class UdacityClient {
    
    static let sharedInstance = UdacityClient()
    
    func loginWithCredentials(forUser user: String, password: String, completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let requestBody = [UdacityConstants.ParameterKeys.USERNAME: user, UdacityConstants.ParameterKeys.PASSWORD: password]
        let httpBody = WebClient.sharedInstance.buildJson(from: requestBody, withKey: UdacityConstants.ParameterKeys.UDACITY)
        login(withRequestBody: httpBody, completionHandler: completionHandler)
    }
    
    func loginWithFacebook(completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let requestBody = [UdacityConstants.ParameterKeys.FACEBOOK_ACCESS_TOKEN: AccessToken.current?.authenticationToken]
        let httpBody = WebClient.sharedInstance.buildJson(from: requestBody, withKey: UdacityConstants.ParameterKeys.FACEBOOK_MOBILE)
        login(withRequestBody: httpBody, completionHandler: completionHandler)
    }
    
    func login(withRequestBody requestBody: Data?, completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        getSessionAndUserId(withRequestBody: requestBody) { (success, errorString, sessionId, userId) in
            if success {
                AuthenticationClient.sharedInstance.personalInformation.udacitySessionId = sessionId
                AuthenticationClient.sharedInstance.personalInformation.userId = userId
                
                self.getPublicUserData() { (success, errorString, uniqueKey, firstName, lastName) in
                    if success {
                        AuthenticationClient.sharedInstance.personalInformation.uniqueKey = uniqueKey
                        AuthenticationClient.sharedInstance.personalInformation.firstName = firstName
                        AuthenticationClient.sharedInstance.personalInformation.lastName = lastName
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
    
    func getSessionAndUserId(withRequestBody requestBody: Data?, completionHandler: @escaping (_ success: Bool, _ errorString: String?, _ sessionId: String?, _ userId: String?) -> Void) {
        let url = WebClient.sharedInstance.createUrl(forScheme: UdacityConstants.UrlComponents.PROTOCOL, forHost: UdacityConstants.UrlComponents.DOMAIN, forMethod: UdacityConstants.Methods.SESSION, withQueryItems: nil)
        var request = WebClient.sharedInstance.buildRequest(withUrl: url, withHttpMethod: WebConstants.ParameterKeys.HTTP_POST)
        
        request.httpBody = requestBody
        
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
                if let session = results?[UdacityConstants.ParameterKeys.SESSION] as? [String: Any],
                    let sessionId = session[UdacityConstants.ParameterKeys.ID] as? String,
                    let account = results?[UdacityConstants.ParameterKeys.ACCOUNT] as? [String: Any],
                    let userId = account[UdacityConstants.ParameterKeys.KEY] as? String {
                    completionHandler(true, nil, sessionId, userId)
                } else {
                    print("Could not find \(UdacityConstants.ParameterKeys.ID) in \(results!)")
                    completionHandler(false, "Login Failed (no Session or user ID).", nil, nil)
                }
            }
        }
    }
    
    func getPublicUserData(completionHandler: @escaping (_ success: Bool, _ errorString: String?, _ uniqueKey: String, _ firstName: String, _ lastName: String) -> Void) {
        let personalInformation = AuthenticationClient.sharedInstance.personalInformation
        let url = WebClient.sharedInstance.createUrl(forScheme: UdacityConstants.UrlComponents.PROTOCOL, forHost: UdacityConstants.UrlComponents.DOMAIN, forMethod: UdacityConstants.Methods.PUBLIC_INFO + String(personalInformation.userId!), withQueryItems: nil)
        
        let request = WebClient.sharedInstance.buildRequest(withUrl: url, withHttpMethod: WebConstants.ParameterKeys.HTTP_GET)
        
        WebClient.sharedInstance.taskForWebRequest(request, errorDomain: "getPublicUserData", withOffset: 5) { (results, error) in
            
            /* Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(false, error.localizedDescription, "", "", "")
            } else {
                if let user = results?[UdacityConstants.ParameterKeys.USER] as? [String: Any],
                    let uniqueKey = user[UdacityConstants.ParameterKeys.KEY] as? String,
                    let firstName = user[UdacityConstants.ParameterKeys.FIRST_NAME] as? String,
                    let lastName = user[UdacityConstants.ParameterKeys.LAST_NAME] as? String {
                    completionHandler(true, nil, uniqueKey, firstName, lastName)
                } else {
                    print("Could not find \(UdacityConstants.ParameterKeys.LAST_NAME) in \(results!)")
                    completionHandler(false, "No public profile info found.", "", "", "")
                }
            }
        }
    }
    
    func logout(completionHandler: @escaping (_ success: Bool, _ errorString: String) -> Void) {
        let url = WebClient.sharedInstance.createUrl(forScheme: UdacityConstants.UrlComponents.PROTOCOL, forHost: UdacityConstants.UrlComponents.DOMAIN, forMethod: UdacityConstants.Methods.SESSION, withQueryItems: nil)
        var request = WebClient.sharedInstance.buildRequest(withUrl: url, withHttpMethod: WebConstants.ParameterKeys.HTTP_DELETE)
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == UdacityConstants.ParameterKeys.XSRF_TOKEN {
                xsrfCookie = cookie
            }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: UdacityConstants.ParameterKeys.X_XSRF_TOKEN)
        }
        
        WebClient.sharedInstance.taskForWebRequest(request, errorDomain: "logout", withOffset: 5) { (results, error) in
            
            /* Send the desired value(s) to completion handler */
            if let error = error {
                //unsuccessful sample responses
                //{"status": 403, "error": "Account not found or invalid credentials."}
                //{"status": 400, "error": "Failed to parse JSON body."}
                completionHandler(false, error.localizedDescription)
            } else {
                //successful sample response:
                /*
                 {
                 "session": {
                 "id": "1463940997_7b474542a32efb8096ab58ced0b748fe",
                 "expiration": "2015-07-22T18:16:37.881210Z"
                 }
                 }
                 */
                
                if let session = results?[UdacityConstants.ParameterKeys.SESSION] as? [String: Any], let sessionId = session[UdacityConstants.ParameterKeys.ID] as? String {
                    if sessionId == AuthenticationClient.sharedInstance.personalInformation.udacitySessionId {
                        completionHandler(true, "")
                    } else {
                        completionHandler(false, "Server and client sessions do not match.")
                    }
                } else {
                    print("Could not find \(UdacityConstants.ParameterKeys.ID) in \(results!)")
                    completionHandler(false, "Logout Failed (no confirmation from server).")
                }
            }
        }
    }
}
