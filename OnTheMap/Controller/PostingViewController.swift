//
//  PostingViewController.swift
//  OnTheMap
//
//  Created by Stefan Jaindl on 25.05.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import CoreLocation
import GoogleMaps
import UIKit

class PostingViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var link: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var map: GMSMapView!
    @IBOutlet weak var stackView: UIStackView!
    
    var pinnedLocation: CLLocationCoordinate2D?
    
    @IBAction func cancel(_ sender: Any) {
        ParseClient.sharedInstance.ownInformation = nil
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishPost(_ sender: Any) {
        enableMapView(false)
        activityIndicator.startAnimating()
        let location = self.location.text!
        let link = self.link.text!
        
        ParseClient.sharedInstance.getStudentLocation((ParseClient.sharedInstance.ownInformation?.uniqueKey)!) { (success, error, objectId) in
            if let error = error {
                performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            } else if let objectId = objectId {
                
                performUIUpdatesOnMain {
                    //location already existing, overwriting it?
                    let alert = UIAlertController(title: "Location already existing", message: "Do you want to override your previous location?", preferredStyle: .alert)
                    
                    let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) -> Void in
                        ParseClient.sharedInstance.putStudentLocation(objectId, mapString: self.location.text!, link: self.link.text!, location: self.pinnedLocation!) { (success, error) in
                            performUIUpdatesOnMain {
                                self.activityIndicator.stopAnimating()
                            
                                if let error = error {
                                    let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    self.present(alert, animated: true)
                                } else {
                                    self.dismiss(animated: true, completion: nil)
                                }
                            }
                        }
                    }
                    
                    let noAction = UIAlertAction(title: "No", style: .default) { (action) -> Void in
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    alert.addAction(yesAction)
                    alert.addAction(noAction)
                    
                    // Present Alert Controller
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                //location not yet existing, post it!
                ParseClient.sharedInstance.postStudentLocation(mapString: location, link: link, location: self.pinnedLocation!) { (success, error) in
                    performUIUpdatesOnMain {
                        self.activityIndicator.stopAnimating()
                        
                        if let error = error {
                            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        } else {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func findLocation(_ sender: Any) {
        if link.text!.isEmpty {
            let alert = UIAlertController(title: "Link empty", message: "Please provide a link", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            
            return
        }
        
        setupUiForGeocoding()
        
        let text = self.location.text!
        
        DispatchQueue.global().async {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(text) { (placemark, error) in
                performUIUpdatesOnMain {
                    self.resetUi()
                }
                
                if let error = error {
                    performUIUpdatesOnMain {
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                } else {
                    //For most geocoding requests, this array should contain only one entry. Otherwise the first result is used.
                    guard let placemark = placemark, let location = placemark[0].location?.coordinate else {
                        performUIUpdatesOnMain {
                            let alert = UIAlertController(title: "Error", message: "No location could be found.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                        
                        return
                    }
                    
                    performUIUpdatesOnMain {
                        self.enableMapView(true)
                        self.placePin(atLocation: location)
                    }
                }
            }
        }
    }
    
    func setupUiForGeocoding() {
        location.resignFirstResponder()
        link.resignFirstResponder()
        
        activityIndicator.startAnimating()
        
        for subview in self.stackView.subviews {
            subview.alpha = 0.5
        }
    }
    
    func resetUi() {
        activityIndicator.stopAnimating()
        
        for subview in self.stackView.subviews {
            subview.alpha = 1.0
        }
    }
    
    func placePin(atLocation location2D: CLLocationCoordinate2D) {
        let personalInfo = AuthenticationClient.sharedInstance.personalInformation
        
        if let firstName = personalInfo.firstName, let lastName = personalInfo.lastName, let uniqueKey = personalInfo.uniqueKey, let link = link.text {
            ParseClient.sharedInstance.ownInformation = StudentInformation(firstName: firstName, lastName: lastName, uniqueKey: uniqueKey, link: link, location: location2D)
       
            let camera = GMSCameraPosition.camera(withLatitude: location2D.latitude,
                                              longitude: location2D.longitude,
                                              zoom: 14)
            map.camera = camera
            
            let marker = GMSMarker(position: location2D)
            
            marker.title = location.text
            marker.icon = UIImage(named: "icon_pin")
            marker.isFlat = true
            marker.map = map
            
            pinnedLocation = location2D
        } else {
            let alert = UIAlertController(title: "Error", message: "Pin couldn't be placed because personal info is not available.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let cornerRadius: CGFloat = 5.0
        findButton.layer.cornerRadius = cornerRadius
        finishButton.layer.cornerRadius = cornerRadius
        
        location.delegate = self
        link.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        enableMapView(false)
    }
    
    func enableMapView(_ enable: Bool) {
        self.stackView.isHidden = enable
        for subview in self.stackView.subviews {
            subview.isHidden = enable
        }
        
        self.map.isHidden = !enable
        self.finishButton.isHidden = !enable
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
