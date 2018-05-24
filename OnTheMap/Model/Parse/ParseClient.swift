//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Stefan Jaindl on 23.05.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import Foundation

class ParseClient {
    static let sharedInstance = ParseClient()
    
    func fetchStudentLocations(completionHandler: @escaping (_ success: Bool, _ errorString: String?, _ firstName: String?, _ lastName: String?, _ link: String?, _ latitude: Double?, _ longitude: Double?) -> Void) {
        
        let queryItems = [ParseConstants.ParameterKeys.ORDER: ParseConstants.ParameterValues.UPDATED_AT]
        let url = WebClient.sharedInstance.createUrl(forScheme: ParseConstants.UrlComponents.PROTOCOL, forHost: ParseConstants.UrlComponents.DOMAIN, forMethod: ParseConstants.Methods.STUDENT_LOCATION, withQueryItems: queryItems)
        
        let request = buildRequest(withUrl: url, withHttpMethod: WebConstants.ParameterKeys.HTTP_GET)
        
        WebClient.sharedInstance.taskForWebRequest(request, errorDomain: "fetchStudentLocations") { (results, error) in
            
            /* Send the desired value(s) to completion handler */
            if let error = error {
                //unsuccessful sample responses
                //{"status": 403, "error": "Account not found or invalid credentials."}
                //{"status": 400, "error": "Failed to parse JSON body."}
                completionHandler(false, error.localizedDescription, nil, nil, nil, nil, nil)
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
                        guard let firstName = result[ParseConstants.ParameterKeys.FIRST_NAME] as? String, let lastName = result[ParseConstants.ParameterKeys.LAST_NAME] as? String, let latitude = result[ParseConstants.ParameterKeys.LATITUDE] as? Double, let longitude = result[ParseConstants.ParameterKeys.LONGITUDE] as? Double, let link = result[ParseConstants.ParameterKeys.LINK] as? String else {
                            print("Result data not complete, skipping: \(result)")
                            continue
                        }
                        
                        print(result)
                        print("\(firstName) \(lastName), \(longitude), \(latitude) \(link)")
                        completionHandler(true, nil, firstName, lastName, link, latitude, longitude)
                    }
                } else {
                    print("Could not find \(ParseConstants.ParameterKeys.RESULTS) in \(results!)")
                    completionHandler(false, "Fetching of Student Locations failed (no results).", nil, nil, nil, nil, nil)
                }
            }
        }
    }
    
    private func buildRequest(withUrl url: URL, withHttpMethod httpMethod: String) -> URLRequest {
        var request = WebClient.sharedInstance.buildRequest(withUrl: url, withHttpMethod: WebConstants.ParameterKeys.HTTP_GET)
        request.addValue(ParseConstants.ParameterValues.API_KEY, forHTTPHeaderField: ParseConstants.ParameterKeys.API_KEY)
        request.addValue(ParseConstants.ParameterValues.APPLICATION_ID, forHTTPHeaderField: ParseConstants.ParameterKeys.APPLICATION_ID)
        
        return request
    }
}
