//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Stefan Jaindl on 23.05.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import CoreLocation
import Foundation

class ParseClient {
    static let sharedInstance = ParseClient()
    
    var studentInformation: [StudentInformation] = []
    var ownInformation: StudentInformation?
    
    func addStudentInfo(_ studentInfo: StudentInformation) {
        studentInformation.append(studentInfo)
    }
    
    func fetchStudentLocations(completionHandler: @escaping (_ success: Bool, _ errorString: String?, _ studentInformation: [String: Any]?) -> Void) {
        let queryItems = [ParseConstants.ParameterKeys.ORDER: ParseConstants.ParameterValues.UPDATED_AT,
                          ParseConstants.ParameterKeys.LIMIT: ParseConstants.ParameterValues.LIMIT]
        let url = WebClient.sharedInstance.createUrl(forScheme: ParseConstants.UrlComponents.PROTOCOL, forHost: ParseConstants.UrlComponents.DOMAIN, forMethod: ParseConstants.Methods.STUDENT_LOCATION, withQueryItems: queryItems)
        
        let request = buildRequest(withUrl: url, withHttpMethod: WebConstants.ParameterKeys.HTTP_GET)
        
        WebClient.sharedInstance.taskForWebRequest(request, errorDomain: "fetchStudentLocations") { (results, error) in
            
            /* Send the desired value(s) to completion handler */
            if let error = error {
                //unsuccessful sample responses
                //{"status": 403, "error": "Account not found or invalid credentials."}
                //{"status": 400, "error": "Failed to parse JSON body."}
                completionHandler(false, error.localizedDescription, nil)
            } else {
                //successful sample response:
                /*
                 {
                 "results":[
                 {
                 "createdAt": "2015-02-25T01:10:38.103Z",
                 "firstName": "Jarrod",
                 "lastName": "Parkes",
                 "latitude": 34.7303688,
                 "longitude": -86.5861037,
                 "mapString": "Huntsville, Alabama ",
                 "mediaURL": "https://www.linkedin.com/in/jarrodparkes",
                 "objectId": "JhOtcRkxsh",
                 "uniqueKey": "996618664",
                 "updatedAt": "2015-03-09T22:04:50.315Z"
                 }
                 ]
                 }
                 */
                if let results = results?[ParseConstants.ParameterKeys.RESULTS] as? [[String: Any]] {
                    for result in results {
                        completionHandler(true, nil, result)
                    }
                } else {
                    print("Could not find \(ParseConstants.ParameterKeys.RESULTS) in \(results!)")
                    completionHandler(false, "Fetching of Student Locations failed (no results).", nil)
                }
            }
        }
    }
    
    func postStudentLocation(mapString: String, link: String, location: CLLocationCoordinate2D, completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let url = WebClient.sharedInstance.createUrl(forScheme: ParseConstants.UrlComponents.PROTOCOL, forHost: ParseConstants.UrlComponents.DOMAIN, forMethod: ParseConstants.Methods.STUDENT_LOCATION, withQueryItems: nil)
        let request = buildRequest(withUrl: url, withHttpMethod: WebConstants.ParameterKeys.HTTP_POST)
        postOrPutStudentLocation(withRequest: request, mapString: mapString, link: link, location: location, completionHandler: completionHandler)
    }
    
    func putStudentLocation(_ objectId: String, mapString: String, link: String, location: CLLocationCoordinate2D, completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let url = WebClient.sharedInstance.createUrl(forScheme: ParseConstants.UrlComponents.PROTOCOL, forHost: ParseConstants.UrlComponents.DOMAIN, forMethod: ParseConstants.Methods.STUDENT_LOCATION + "/" + objectId, withQueryItems: nil)
        let request = buildRequest(withUrl: url, withHttpMethod: WebConstants.ParameterKeys.HTTP_PUT)
        postOrPutStudentLocation(withRequest: request, mapString: mapString, link: link, location: location, completionHandler: completionHandler)
    }
    
    func postOrPutStudentLocation(withRequest request: URLRequest, mapString: String, link: String, location: CLLocationCoordinate2D, completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        var request = request
        let personalInfo = AuthenticationClient.sharedInstance.personalInformation
        let requestBody = [UdacityConstants.ParameterKeys.UNIQUE_KEY: personalInfo.uniqueKey!, UdacityConstants.ParameterKeys.FIRSTNAME: personalInfo.firstName!, UdacityConstants.ParameterKeys.LASTNAME: personalInfo.lastName!, UdacityConstants.ParameterKeys.MAPSTRING: mapString, UdacityConstants.ParameterKeys.MEDIA_URL: link, UdacityConstants.ParameterKeys.LATITUDE: location.latitude, UdacityConstants.ParameterKeys.LONGITUDE: location.longitude] as [String : Any]
        
        request.httpBody = WebClient.sharedInstance.buildJson(from: requestBody)
        
        WebClient.sharedInstance.taskForWebRequest(request, errorDomain: "postStudentLocation") { (results, error) in
            
            /* Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(false, error.localizedDescription)
            } else {
                //successful sample response:
                /*
                 {
                 "createdAt":"2015-03-11T02:48:18.321Z",
                 "objectId":"CDHfAy8sdp"
                 }
                 */
                if results?[ParseConstants.ParameterKeys.CREATED_AT] != nil {
                    completionHandler(true, nil)
                } else {
                    print("Could not find \(ParseConstants.ParameterKeys.CREATED_AT) in \(results!)")
                    completionHandler(false, "Posting of Student Location failed.")
                }
            }
        }
    }
    
    func getStudentLocation(_ uniqueKey: String, completionHandler: @escaping (_ success: Bool, _ errorString: String?, _ objectId: String?) -> Void) {
        let queryDict = [ParseConstants.ParameterKeys.UNIQUE_KEY: uniqueKey]
        let queryItem = [UdacityConstants.ParameterKeys.WHERE: WebClient.sharedInstance.buildJsonString(from: queryDict)]
        let url = WebClient.sharedInstance.createUrl(forScheme: ParseConstants.UrlComponents.PROTOCOL, forHost: ParseConstants.UrlComponents.DOMAIN, forMethod: ParseConstants.Methods.STUDENT_LOCATION, withQueryItems: queryItem)
        let request = buildRequest(withUrl: url, withHttpMethod: WebConstants.ParameterKeys.HTTP_GET)
        
        WebClient.sharedInstance.taskForWebRequest(request, errorDomain: "getStudentLocation") { (results, error) in
            
            var objectId: String?
            /* Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(false, error.localizedDescription, nil)
            } else {
                
                guard let results = results?[ParseConstants.ParameterKeys.RESULTS] as? [[String: Any]] else {
                    print("Could not find \(ParseConstants.ParameterKeys.UNIQUE_KEY) or \(ParseConstants.ParameterKeys.OBJECT_ID)")
                    completionHandler(false, "Checking of Student Location failed.", nil)
                    return
                }
                
                if results.count > 0 {
                    objectId = results[0][ParseConstants.ParameterKeys.OBJECT_ID] as? String
                }

                completionHandler(true, nil, objectId)
            }
        }
    }
    
    private func buildRequest(withUrl url: URL, withHttpMethod httpMethod: String) -> URLRequest {
        var request = WebClient.sharedInstance.buildRequest(withUrl: url, withHttpMethod: httpMethod)
        request.addValue(ParseConstants.ParameterValues.API_KEY, forHTTPHeaderField: ParseConstants.ParameterKeys.API_KEY)
        request.addValue(ParseConstants.ParameterValues.APPLICATION_ID, forHTTPHeaderField: ParseConstants.ParameterKeys.APPLICATION_ID)
        
        return request
    }
}
