//
//  ViewController.swift
//  OnTheMap
//
//  Created by Stefan Jaindl on 14.05.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import FacebookCore
import FacebookLogin
import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginWithFacebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if AccessToken.current != nil {
            // User is logged in, use 'accessToken' here.
            self.performSegue(withIdentifier: Constants.MAP_SEGUE, sender: self)
        }
    }

    @IBAction func signUp(_ sender: UIButton) {
        if let url = URL(string: UdacityConstants.UDACITY_SIGNUP_LINK) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        UdacityClient.sharedInstance.loginWithCredentials(forUser: emailText.text!, password: passwordText.text!) {  (success, errorString) in
            performUIUpdatesOnMain {
                if success {
                    //perform segue to MapView
                    self.emailText.text = ""
                    self.passwordText.text = ""
                    
                    self.performSegue(withIdentifier: Constants.MAP_SEGUE, sender: self)
                } else {
                    //show alertview with error message
                    let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        FacebookClient.sharedInstance.login(withViewController: self) { (success, error) in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            } else {
                self.performSegue(withIdentifier: Constants.MAP_SEGUE, sender: self)
            }
        }
    }
        
}
