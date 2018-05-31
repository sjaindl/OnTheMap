//
//  PinTableViewController.swift
//  OnTheMap
//
//  Created by Stefan Jaindl on 23.05.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import UIKit

class PinTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        fetchData()
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        AuthenticationClient.sharedInstance.reset()
        FacebookClient.sharedInstance.facebookLoginManager.logOut()
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    private func fetchData() {
        ParseClient.sharedInstance.studentInformation.removeAll()
        tableView.reloadData()
        
        ParseClient.sharedInstance.fetchStudentLocations() { (success, errorString, studentInformation) in
            performUIUpdatesOnMain {
                if success {
                    let studentInformation = StudentInformation(studentInformation)
                    if studentInformation.hasCompleteInformation() {
                        //append valid entries to the studentInformation array
                        ParseClient.sharedInstance.addStudentInfo(studentInformation)
                        self.tableView.reloadData()
                        
                    }
                } else {
                    //show alertview with error message
                    let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance.studentInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CELL_REUSE_ID)!
        
        let studentInfo = ParseClient.sharedInstance.studentInformation[indexPath.row]
        cell.textLabel?.text = studentInfo.title
        cell.detailTextLabel?.text = studentInfo.subtitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentInfo = ParseClient.sharedInstance.studentInformation[indexPath.row]
        var urlString = studentInfo.link
        
        if !(urlString.hasPrefix("http://") || urlString.hasPrefix("https://")) {
            urlString = "http://\(urlString)"
        }
        
        UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
    }
}
