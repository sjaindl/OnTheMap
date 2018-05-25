//
//  PinTableViewController.swift
//  OnTheMap
//
//  Created by Stefan Jaindl on 23.05.18.
//  Copyright © 2018 Stefan Jaindl. All rights reserved.
//

import UIKit

class PinTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
}
