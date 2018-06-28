//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Stefan Jaindl on 23.05.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import Foundation

struct FlickrConstants {
    
    struct UrlComponents {
        static let PROTOCOL = "https"
        static let DOMAIN = "api.flickr.com"
        static let PATH = "/services/rest"
    }
    
    struct Methods {
        static let STUDENT_LOCATION = "/parse/classes/StudentLocation"
    }
    
    // MARK: Flickr
    struct Flickr {
        static let SearchBBoxHalfWidth = 1.0
        static let SearchBBoxHalfHeight = 1.0
        static let SearchLatRange = (-90.0, 90.0)
        static let SearchLonRange = (-180.0, 180.0)
    }
    
    // MARK: Flickr Parameter Keys
    struct FlickrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let GalleryID = "gallery_id"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let Text = "text"
        static let BoundingBox = "bbox"
        static let Page = "page"
    }
    
    // MARK: Flickr Parameter Values
    struct FlickrParameterValues {
        static let SearchMethod = "flickr.photos.search"
        static let APIKey = "c9044642523990c5adbde35ae6cfd0e5"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1" /* 1 means "yes" */
        static let GalleryPhotosMethod = "flickr.galleries.getPhotos"
        static let GalleryID = "5704-72157622566655097"
        static let MediumURL = "url_m"
        static let UseSafeSearch = "1"
    }
    
    // MARK: Flickr Response Keys
    struct FlickrResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_m"
        static let Pages = "pages"
        static let Total = "total"
    }
    
    // MARK: Flickr Response Values
    struct FlickrResponseValues {
        static let OKStatus = "ok"
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
        static let LIMIT = "limit"
    }
    
    struct ParameterValues {
        static let APPLICATION_ID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let API_KEY = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        static let UPDATED_AT = "-updatedAt"
        static let LIMIT = "100"
    }
}
