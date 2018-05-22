//
//  ViewController.swift
//  OnTheMap
//
//  Created by Stefan Jaindl on 14.05.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
                    //perform segue to Map and Table Tabbed View.
                    let alert = UIAlertController(title: "Success", message: "all ok", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    
                } else {
                    //show alertview with error message
                    let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
}
